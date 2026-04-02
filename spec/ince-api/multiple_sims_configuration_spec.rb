# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::MultipleSimsConfiguration do
  it 'updates one sim card - no changes' do
    VCR.use_cassette('update_sims_empty_list') do
      response = described_class.new(access_token: 'VALID TOKEN').update_many
      expect(response[:status]).to eq 'OK'
    end
  end

  it 'updates one sim card - changes' do
    VCR.use_cassette('update_sims_label_change') do
      params = [{ iccid: '8988228066602306711', label: 'Test Label 1' },
                { iccid: '8988228066602307111', label: 'Test Label 2' }]
      response = described_class.new(access_token: 'VALID TOKEN', changes_array: params).update_many
      expect(response[:status]).to eq 'OK'
    end
  end
end
