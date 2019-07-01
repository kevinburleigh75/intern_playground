require 'rails_helper'
require 'securerandom'

RSpec.describe RequestHandler, :truncation do

  context 'when request_record is called once' do

    let(:test_uuid) {
      SecureRandom.uuid.to_s
    }

    it 'one new RequestRecord is created' do
    end
  end

end