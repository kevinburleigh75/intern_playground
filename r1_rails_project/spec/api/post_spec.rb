require 'rails_helper'
require 'securerandom'

RSpec.describe '/hello post request endpoint', type: :request, truncation: true do
  let(:service_instance_double) {
    instance_double(HelloService).tap do |dbl|
      allow(dbl).to receive(:process).with(given_request_payload).and_return(target_response_payload)
    end
  }

  before(:each) do
    allow(HelloService).to receive(:new).and_return(service_instance_double)
  end

  context 'when sent valid input' do
    let(:test_uuid) {
      SecureRandom.uuid.to_s
    }
    let(:test_instance_id) {
      "i-01f61e42a73670c18"
    }
    let(:test_image_id) {
      "ami-5fb8c835"
    }

    let(:given_request_payload) {
      {uuid: test_uuid}
    }

    let(:bad_request_payload) {
      {id: 123}
    }

    let(:target_response_payload) {
      {uuid: test_uuid,
       instance_id: test_instance_id,
       image_id: test_image_id}
    }

    it 'hello is called with the given request payload' do
      response_status, response_body = create_request(request_payload: given_request_payload)
      expect(service_instance_double).to have_received(:process).with(given_request_payload)
    end

    it 'the result of hello is returned in the response payload' do
      response_status, response_body = create_request(request_payload: given_request_payload)
      expect(response_body).to eq(target_response_payload)
    end

    it 'the response status is 200 (success)' do
      response_status, response_body = create_request(request_payload: given_request_payload)
      expect(response_status).to eq(200)
    end

    it 'one new RequestRecord is created' do
      create_request(request_payload: given_request_payload)
      expect(RequestRecord.count).to eq(1)
    end

    it 'the RequestRecord uuid matches the request uuid' do
      create_request(request_payload: given_request_payload)
      expect(RequestRecord.first[:uuid]).to eq(test_uuid)
    end

    it 'some time has elapsed in recording the request' do
      create_request(request_payload: given_request_payload)
      expect(RequestRecord.first[:elapsed]).not_to eq(0)
    end
  end
end


def create_request(request_payload:)
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