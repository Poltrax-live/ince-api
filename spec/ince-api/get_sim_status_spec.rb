# frozen_string_literal: true

require 'spec_helper'
require 'webmock/rspec'

RSpec.describe InceApi::GetSimStatus do
  it 'get one sim card status' do
    VCR.use_cassette('get_sim_status') do
      response = described_class.new(access_token: @token, iccid: '8988228066602306770').sim_status
      expect(response['status']).to eq 'ATTACHED'
      expect(response['location']['country']['name']).to eq 'Poland'
      expect(response['location']['operator']['name']).to eq 'Plus'
    end
  end

  it 'returns error hash when API returns HTML instead of JSON' do
    html_body = '<!doctype html><html><body>Service Unavailable</body></html>'
    stub_request(:get, 'https://api.1nce.com/management-api/v1/sims/123/status')
      .to_return(status: 503, body: html_body, headers: { 'Content-Type' => 'text/html' })

    response = described_class.new(access_token: 'token', iccid: '123').sim_status
    expect(response['status_code']).to eq 503
    expect(response['error_message']).to start_with('Invalid JSON response:')
  end

  it 'returns 404 error hash when body is empty' do
    stub_request(:get, 'https://api.1nce.com/management-api/v1/sims/123/status')
      .to_return(status: 200, body: '', headers: {})

    response = described_class.new(access_token: 'token', iccid: '123').sim_status
    expect(response['status_code']).to eq 404
    expect(response['error_message']).to eq 'SIM with ICCID not found'
  end
end
