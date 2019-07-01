require 'rails_helper'

RSpec.describe 'json verifier', truncation: true do
  context 'when sent valid payload' do

    it 'no errors are found when verifying against schema' do
      errors = JsonVerifier.new.validate_json('{"uuid": "c314de55-d7fa-49a3-9feb-ac8d0b27dbbd"}')
      expect(errors).to eq([])
    end
  end

  context 'when sent invalid payload' do
    it 'errors are found when verifying against schema' do
      errors = JsonVerifier.new.validate_json('{"id": "c314de55-d7fa-49a3-9feb-ac8d0b27dbbd"}')
      expect(errors).not_to eq([])
    end
  end


end