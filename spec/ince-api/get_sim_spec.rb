# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::GetSim do
  it 'get one sim card' do
    VCR.use_cassette('get_sim') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '8988228066602306711').sim
      expect(response['status']).to eq 'Activated'
      expect(response['label']).to eq 'Test API'
    end
  end

  it 'wrond iccid' do
    VCR.use_cassette('get_sim_wrong_iccid') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '11111222233444').sim
      expect(response['error_message']).to eq 'SIM with ICCID not found'
      expect(response['status_code']).to eq 404
    end
  end

  it 'invalid token' do
    VCR.use_cassette('get_sim_wrong_token') do
      response = described_class.new(access_token: 'INVALID TOKEN', iccid: '8988228066602306711').sim
      expect(response['error']).to eq 'Unauthorized'
      expect(response['message']).to eq 'The token is invalid: Illegal base64 character 20'
      expect(response['status']).to eq 401
    end
  end
end
