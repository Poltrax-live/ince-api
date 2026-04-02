# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::GetSimSmsQuota do
  it 'get one sim sms quota' do
    VCR.use_cassette('get_sim_sms_quota') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '8988228066602306770').sim_status
      expect(response['volume']).to eq 240
      expect(response['total_volume']).to eq 250
      expect(response['threshold_percentage']).to eq 20
    end
  end
end
