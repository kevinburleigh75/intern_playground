require 'rails_helper'

RSpec.describe '/ping get request endpoint', type: :request, truncation: true do
  let(:service_instance_double) {
    instance_double(PingService).tap do |dbl|
      allow(dbl).to receive(:process).with({}).and_return({})
    end
  }

  before(:each) do
    allow(PingService).to receive(:new).and_return(service_instance_double)
  end

    it 'Ping is called with an empty request payload' do
      response_status, response_body = create_request(request_payload: {})
      expect(service_instance_double).to have_received(:process).with({})
    end

    it 'Nothing is returned in the response payload' do
      response_status, response_body = create_request(request_payload: {})
      expect(response_body).to eq({})
    end

    it 'The response status is 200 (success)' do
      response_status, response_body = create_request(request_payload: {})
      expect(response_status).to eq(200)
    end
  end

def create_request(request_payload:)
  make_get_request(
      route: '/ping',
      headers: {'Content-Type' => 'application/json'},
  )

  response_status = response.status
  return [response_status, {}]
end

def make_get_request(route:, headers:)
  get route, headers:headers
end