# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::SingleSimConfiguration do
  it 'updates one sim card - no changes' do
    VCR.use_cassette('update_sim_no_change') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '8988228066602306770').update
      expect(response[:status]).to eq 'OK'
    end
  end

  it 'updates one sim card - changes' do
    VCR.use_cassette('update_sim_label_change') do
      response = described_class.new(access_token: 'VALID TOKEN', iccid: '8988228066602306770',
                                     params: { label: 'Test Label' }).update
      expect(response[:status]).to eq 'OK'
    end
  end
end
