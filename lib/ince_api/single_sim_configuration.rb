# frozen_string_literal: true

module InceApi
  class SingleSimConfiguration
    def initialize(access_token:, iccid:, params: {})
      @access_token = access_token
      @iccid = iccid
      @params = params
    end

    def update
      response = connection.request(request)
      if response.code.to_i == 200
        allowed_params.merge(status: 'OK')
      else
        { status: 'FAILED',
          error_code: response.code.to_i }
      end
    end

    private

    ALLOWED_KEYS = %i[label imei_lock status].freeze
    def allowed_params
      @params.slice(*ALLOWED_KEYS)
    end

    def url
      @url ||= URI("https://api.1nce.com/management-api/v1/sims/#{@iccid}")
    end

    def connection
      @connection ||= Net::HTTP.new(url.host, url.port).tap do |http|
        http.use_ssl = true
      end
    end

    def request
      Net::HTTP::Put.new(url).tap do |request|
        request.body = allowed_params.to_json
        request['Accept'] = 'application/json'
        request['Content-Type'] = 'application/json;charset=UTF-8'
        request['Authorization'] = "Bearer #{@access_token}"
      end
    end
  end
end
