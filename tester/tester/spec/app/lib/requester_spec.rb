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

RSpec.describe Driver do
  let(:driver) {
    Driver.new()
  }

  # Tests for request driver.
  context 'when driver is initalized but nothing in db' do
    it 'throws exception' do
      expect{
        Driver.new()
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
      driver.get_pinger_data()
      expect(driver.desired_rate).to be(5)
      expect(driver.num_instances).to be(1)

    end

  end
end

RSpec.describe DriverChild do
  let(:driver_child) {
    lambda = -> { }
    DriverChild.new(lambda, 5, 1)
  }

  context 'always' do
    it 'can run the lambda' do
      lambda = -> { puts "Example Lambda" }
      driver_child.instance_variable_set(:@lambda, lambda)

      expect{
        driver_child.run_lambda_timed()
      }.to output('Example Lambda' + "\n").to_stdout
    end

    it 'has a float value for target_interval' do
      expect(driver_child.instance_variable_get(:@target_interval)).is_a?(Float)
    end

    it 'times a lambda' do
      expect(driver_child.run_lambda_timed()).is_a? (Integer)
      expect(driver_child.run_lambda_timed() > 0)
    end
  end

  context 'when one iteration of lambda is tested' do
    it 'returns the debt if there is debt' do
      expect(driver_child.run_lambda_target_time(0.0)).to be > 0
    end

    it 'does not return debt if there is none' do
      expect(driver_child.run_lambda_target_time(1.0)).to be == 0
    end
  end

  context 'runs a cycle of lambda' do
    it 'outputs to standard out five times' do
      lambda = -> { puts "Example Lambda" }
      driver_child.instance_variable_set(:@lambda, lambda)

      expect{
        driver_child.run_many(stop = true, num_iterations = 5)
      }.to output(('Example Lambda' + "\n") * 5).to_stdout
    end

    # 2.5 percent tolerance
    it 'takes about one seconds to to run everything' do

      beginning_time = Time.now
      driver_child.run_many(stop = true, num_iterations = 5)
      end_time = Time.now

      expect(end_time - beginning_time).to be_an_between(0.975, 1.025)
    end

  end
end