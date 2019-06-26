require 'rails_helper'

RSpec.describe HelloService do
  context 'a valid JSON payload is sent' do
    let(:test_uuid) {
      SecureRandom.uuid.to_s
    }

    it 'the uuid of the response matches the request uuid' do
      response = HelloService.new.process({uuid: test_uuid})
      expect(response[:uuid]).to eq(test_uuid)
    end
  end
end