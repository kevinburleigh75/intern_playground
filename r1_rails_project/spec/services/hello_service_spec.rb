require 'rails_helper'

RSpec.describe HelloService, :truncation do
  context 'a valid JSON payload is sent' do
    let(:test_uuid) {
      SecureRandom.uuid.to_s
    }
    it 'one RequestRecord is created' do
      expect{HelloService.new.process({uuid: test_uuid})}.to change{RequestRecord.count}.by 1
    end
    it 'the uuid of the request record matches the payload uuid' do
      HelloService.new.process({uuid: test_uuid})
      expect(RequestRecord.first[:uuid]).to eq(test_uuid)
      ## create other test records
    end
  end
end