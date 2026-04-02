# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::GetSims do
  it 'get all sim cards' do
    VCR.use_cassette('get_sims') do
      response = described_class.new(access_token: 'VALID TOKEN').sims
      expect(response.first['status']).to eq 'Enabled'
      expect(response.first['label']).to eq 'Test API'
    end
  end

  it 'get sim cards with params' do
    VCR.use_cassette('get_sims_with_params') do
      response = described_class.new(access_token: 'VALID TOKEN', params: { page: 2, pageSize: 5 }).sims
      expect(response.size).to eq 5
    end
  end

  it 'paginates results' do
    VCR.use_cassette('get_sims_with_params_page_1') do
      @response_p1 = described_class.new(access_token: 'VALID TOKEN', params: { page: 1, pageSize: 5 }).sims
      expect(@response_p1.size).to eq 5
    end

    VCR.use_cassette('get_sims_with_params') do
      @response_p2 = described_class.new(access_token: 'VALID TOKEN', params: { page: 2, pageSize: 5 }).sims
      expect(@response_p2.size).to eq 5
    end

    expect(@response_p1.first['iccid']).not_to eq(@response_p2.first['iccid'])
  end

  it 'returns headers too' do
    VCR.use_cassette('get_sims_with_params') do
      service = described_class.new(access_token: 'VALID TOKEN', params: { page: 2, pageSize: 5 })
      response = service.sims
      headers = service.headers
      expect(response.size).to eq 5

      expect(headers['x-current-page']).to eq '2'
    end
  end

  it 'invalid token' do
    VCR.use_cassette('get_sims_wrong_token') do
      response = described_class.new(access_token: 'INVALID TOKEN').sims
      expect(response['error']).to eq 'Unauthorized'
      expect(response['message']).to eq 'The token is invalid: Illegal base64 character 20'
      expect(response['status']).to eq 401
    end
  end
end
