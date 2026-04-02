# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::CreateSms do
  it 'sends SMS to sim card' do
    VCR.use_cassette('create_sms') do
      payload = 'test SMS'
      response = described_class.new(access_token: @token, iccid: '8988228066602306770',
                                     params: { payload: payload }).send
      expect(response[:status]).to eq 'OK'
      expect(response[:payload]).to eq payload
    end
  end
end
