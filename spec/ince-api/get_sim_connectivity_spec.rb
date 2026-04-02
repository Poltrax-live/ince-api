# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::GetSimConnectivity do
  it 'get one sim card - idle' do
    VCR.use_cassette('get_sim_connectivity') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '123456789').sim
      expect(response['subscriber_info']['state']).to eq 'assumed_idle'
    end
  end
end
