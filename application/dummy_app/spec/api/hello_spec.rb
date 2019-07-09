require 'rails_helper'

RSpec.describe '/hello endpoint', type: :request do
  let(:service_instance_double) {
    instance_double(HelloService).tap do |dbl|
      allow(dbl).to receive(:process).with(given_request_payload).and_return(target_response_payload)
    end
  }

  let(:given_request_payload) {
    { uuid: test_uuid }
  }

  let(:test_uuid) { SecureRandom.uuid.to_s }

  let(:target_response_payload) {
    {
      uuid:        test_uuid,
      instance_id: test_instance_id,
      image_id:    test_image_id,
    }
  }

  let(:test_uuid)        { SecureRandom.uuid.to_s }
  let(:test_instance_id) { 'i-01f61e42a73670c18' }
  let(:test_image_id)    { 'ami-5fb8c835' }

  before(:each) do
    allow(HelloService).to receive(:new).and_return(service_instance_double)
  end

  context 'when the request payload is valid' do
    it 'the HelloService is called with the given payload' do
      response_status, response_body = hello_request(request_payload: given_request_payload)
      expect(service_instance_double).to have_received(:process).with(given_request_payload)
    end

    it 'the response status is 200 (success)' do
      response_status, response_body = hello_request(request_payload: given_request_payload)
      expect(response_status).to eq(200)
    end

    it 'the HelloService result is returned in the response payload' do
      response_status, response_body = hello_request(request_payload: given_request_payload)
      expect(response_body).to eq(target_response_payload)
    end
  end

  context 'when the request payload is invalid' do
    xit 'returns a 4xx status'
    xit 'other?'
  end
end

def hello_request(request_payload:)
  make_post_request(
    route: '/hello',
    headers: {'Content-Type' => 'application/json'},
    body: request_payload.to_json
  )

  response_status = response.status
  response_body   = JSON.parse(response.body, symbolize_names: true)

  return [response_status, response_body]
end

def make_post_request(route:, headers:, body: nil)
  post route, params: body, headers:headers
end
