require 'rails_helper'

RSpec.describe Requester do
  let(:result) {
    Requester.request(
      http_verb:     http_verb,
      url:           url,
      timeout_sec:   timeout_sec,
    )
  }
  let(:http_verb)   { :get }
  let(:url)         { 'http://www.google.com' }
  let(:timeout_sec) { 10.0 }

  # Tests for requests
  context 'it always reports:' do
    it 'a request uuid' do
      expect(result.request_uuid).to be_a(String)
      expect(result.request_uuid.length).to eq(32 + 4)
    end
    it 'a request time' do
      expect(result.request_time).to be_a(Time)
    end
  end

  context 'when the URL is invalid' do
    let(:url) { 'http://blahgarbageblah.com' }

    context 'it reports:' do
      it 'a connection error' do
        expect(result.connection_error?).to be_truthy
      end
      it 'an error' do
        expect(result.error?).to be_truthy
      end
    end
    context 'it does not report:' do
      it 'elapsed time' do
        expect(result.elapsed_sec).to be_nil
      end
      it 'a timeout error' do
        expect(result.timeout_error?).to be_falsey
      end
      it 'an HTTP response' do
        expect(result.http_response).to be_nil
      end
    end
  end

  context 'when the URL is valid' do
    context 'when the connection times out' do
      let(:timeout_sec) { 0.00001 }

      context 'it reports:' do
        it 'a timeout error' do
          expect(result.timeout_error?).to be_truthy
        end
        it 'an error' do
          expect(result.error?).to be_truthy
        end
      end
      context 'it does not report:' do
        it 'elapsed time' do
          expect(result.elapsed_sec).to be_nil
        end
        it 'a connection error' do
          expect(result.connection_error?).to be_falsey
        end
        it 'an HTTP response' do
          expect(result.http_response).to be_nil
        end
      end
    end
    context 'when the connection does not time out' do
      context 'it reports:' do
        it 'elapsed time' do
          expect(result.elapsed_sec).to be_a(Float)
        end
        it 'a HTTP response' do
          expect(result.http_response).to be_a(HTTP::Response)
        end
      end
      context 'it does not report:' do
        it 'a connection error' do
          expect(result.connection_error?).to be_falsey
        end
        it 'a timeout error' do
          expect(result.timeout_error?).to be_falsey
        end
        it 'an error' do
          expect(result.error?).to be_falsey
        end
      end
    end
  end

end

RSpec.describe DriverData do
  let(:driver_data) {
    DriverData.new()
  }

  # Tests for request driver.
  context 'when driver is initalized but nothing in db' do
    it 'throws exception' do
      expect{
        DriverData.new()
      }.to raise_error("Database is empty!")
    end
  end

  context 'when driver is initalized with info in db' do
    # Question: Would I update the db here, or in seeds.rb?

    before do
      PingerData.create!(
                    rate: 5,
                    num_instances: 1
      )
    end

    it 'populates fields from database' do
      data = driver_data.return_data()

      expect(data["desired_rate"]).to eq(5)
      expect(data["num_instances"]).to eq(1)

    end

    it 'updates when fields are updated' do
      data = driver_data.return_data()

      expect(data["desired_rate"]).to eq(5)
      expect(data["num_instances"]).to eq(1)

      pinger_data = PingerData.first
      pinger_data.num_instances = 2
      pinger_data.rate = 2
      pinger_data.save()

      driver_data.pull_data()
      data = driver_data.return_data()

      expect(data["desired_rate"]).to eq(2)
      expect(data["num_instances"]).to eq(2)
    end

  end
end

RSpec.describe Driver do
end

RSpec.describe DriverChild do
  before(:each) do
    PingerData.create!(
        rate: 5,
        num_instances: 1
    )
  end

  let(:driver_data) {
    DriverData.new()
  }

  let(:driver_child) {
    lambda = -> { }
    DriverChild.new(lambda, driver_data, 1, 5)
  }

  context 'when driver_child is initiated with above param' do
    it 'target_interval is 0.2' do
      expect(driver_child.instance_variable_get(:@target_interval)).is_a?(Float)
      expect(driver_child.instance_variable_get(:@target_interval)).to eq(0.2)
    end

    it 'changes interval when pointer driver_data object is updated and wants to update' do

      pinger_data = PingerData.first
      expect(pinger_data.rate).to eq(5)
      expect(pinger_data.num_instances).to eq(1)

      expect(driver_child.instance_variable_get(:@target_interval)).to eq(0.2)

      pinger_data.rate = 5
      pinger_data.num_instances = 2
      pinger_data.save()

      driver_data.pull_data()

      driver_child.get_driver_data()
      expect(driver_child.instance_variable_get(:@target_interval)).to eq(0.4)
    end
  end

    # 2.5 percent tolerance
    it 'takes about one seconds to to run everything' do

      beginning_time = Time.now
      driver_child.run_many(stop = true, num_iterations = 5)
      end_time = Time.now

      expect(end_time - beginning_time).to be_an_between(0.975, 1.025)
    end

    it 'takes less than one second to run five iterations when rate is updated' do
      driver_child = DriverChild.new(-> { }, driver_data, 1, 0.2)

      pinger_data = PingerData.first
      pinger_data.rate = 30
      pinger_data.num_instances = 1
      pinger_data.save()

      driver_data.pull_data()

      beginning_time = Time.now
      driver_child.run_many(stop = true, num_iterations = 5)
      end_time = Time.now

      # One or two iterations at 0.2 seconds, four or three iterations at 0.03333333333 seconds
      # Estimated 0.4 + .09, or 0.2 + 0.12. Lower bound is 0.32; if below, then it is all at faster rate.
      expect(end_time - beginning_time).to be_an_between(0.32, 0.55)
    end
end