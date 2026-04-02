# frozen_string_literal: true

require 'spec_helper'

RSpec.describe InceApi::CreateAccessToken do
  it 'invalid credentials' do
    VCR.use_cassette('invalid_credentials') do
      response = described_class.new(username: 'Wrong', password: 'Credentials').create_token
      expect(response['statusCode']).to eq 400
      expect(response['errorCode']).to eq 'CognitoAuthenticationError'
      expect(response['message']).to eq 'User does not exist.'
    end
  end

  it 'invalid password' do
    VCR.use_cassette('invalid_password') do
      response = described_class.new(username: 'Proper Username', password: 'Invalid Password').create_token
      expect(response['statusCode']).to eq 400
      expect(response['errorCode']).to eq 'CognitoAuthenticationError'
      expect(response['message']).to eq 'Incorrect username or password.'
    end
  end

  it 'valid credentials' do
    VCR.use_cassette('valid_credentials') do
      response = described_class.new(username: 'Good Username', password: 'Good Password').create_token
      expect(response['status_code']).to eq 200
      expect(response['access_token']).not_to be_nil
      expect(response['expires_in']).to eq 3600
      expect(response['token_type']).to eq 'bearer'
    end
  end
end
