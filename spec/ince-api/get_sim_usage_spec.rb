# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::GetSimUsage do
  it 'get all sim cards' do
    VCR.use_cassette('get_sim_usage') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '8988228066602306770').sim_usage
      expect(response['stats'].size).to eq 15
      expect(response['stats'].first['date']).to eq '2021-11-14'
      expect(response['stats'].first['data']['volume']).to eq '0'
    end
  end

  xit 'get sim usage with params' do
    VCR.use_cassette('get_sims_usage_with_params') do
      described_class.new(access_token: @token, iccid: '8988228066602306770',
                          params: { start_dt: 2021 - 11 - 10, end_dt: 2021 - 11 - 12 }).sim_usage
    end
  end
end
