require 'rails_helper'
require 'securerandom'

RSpec.describe RequestHandler, :truncation do

  context 'when request_record is called' do

    let(:test_uuid) {
      SecureRandom.uuid.to_s
    }

    it 'one new RequestRecord is created' do
      expect{RequestHandler.new.record_request({uuid: test_uuid})}.to change {RequestRecord.count}.by 1
    end
  end

end