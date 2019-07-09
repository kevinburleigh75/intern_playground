require 'rails_helper'

RSpec.describe '/ping get request endpoint', type: :request do
  let(:service_instance_double) {
    instance_double(PingService).tap do |dbl|
      allow(dbl).to receive(:process).with(no_args).and_return(nil)
    end
  }

  before(:each) do
    allow(PingService).to receive(:new).and_return(service_instance_double)
  end

  it 'the PingService is called with with no arguments' do
    response_status, response_body = ping_request
    expect(service_instance_double).to have_received(:process).with(no_args)
  end

  it 'the response payload is an empty hash' do
    response_status, response_body = ping_request
    expect(response_body).to eq({})
  end

  it 'the response status is 200 (success)' do
    response_status, response_body = ping_request
    expect(response_status).to eq(200)
  end
end

def ping_request
  make_get_request(
      route: '/ping',
      headers: {'Content-Type' => 'application/json'},
  )

  response_status = response.status
  response_body   = JSON.parse(response.body, symbolize_names: true)
  return [response_status, response_body]
end

def make_get_request(route:, headers:)
  get route, headers: headers
end
