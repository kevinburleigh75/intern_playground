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
      end
      context 'it does not report:' do
        it 'elapsed time' do
          expect(result.elapsed_sec).to be_nil
        end
        it 'a connection error' do
          expect(result.connection_error?).to be_falsy
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
          expect(result.connection_error?).to be_falsy
        end
        it 'a timeout error' do
          expect(result.timeout_error?).to be_falsey
        end
      end
    end
  end
end
