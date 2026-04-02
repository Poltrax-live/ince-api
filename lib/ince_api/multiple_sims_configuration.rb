# frozen_string_literal: true

module InceApi
  class MultipleSimsConfiguration
    def initialize(access_token:, changes_array: [])
      @access_token = access_token
      @changes_array = changes_array
    end

    def update_many
      response = connection.request(request)
      response.code.to_i == 201 ? { status: 'OK' } : { status: 'FAILED', error_code: response.code.to_i }
    end

    private

    ALLOWED_KEYS = %i[iccid label imei_lock status].freeze
    def body
      @changes_array.reject { |sim_params| sim_params[:iccid].nil? }
                    .map { |sim_params| sim_params.slice(*ALLOWED_KEYS) }.to_json
    end

    def url
      @url ||= URI('https://api.1nce.com/management-api/v1/sims')
    end

    def connection
      @connection ||= Net::HTTP.new(url.host, url.port).tap do |http|
        http.use_ssl = true
      end
    end

    def request
      Net::HTTP::Post.new(url).tap do |request|
        request.body = body
        request['Accept'] = 'application/json'
        request['Content-Type'] = 'application/json;charset=UTF-8'
        request['Authorization'] = "Bearer #{@access_token}"
      end
    end
  end
end
