# frozen_string_literal: true

module InceApi
  class GetSims
    attr_reader :headers

    def initialize(access_token:, params: {})
      @access_token = access_token
      @params = params
    end

    def sims
      response = connection.request(request)
      @headers = response.each_header.to_h

      JSON.parse(response.body)
    rescue JSON::ParserError
      { 'status_code' => response.code.to_i, 'error_message' => "Invalid JSON response: #{response.body[0..200]}" }
    end

    private

    ALLOWED_KEYS = %i[page pageSize q sort].freeze
    def params_query
      URI.encode_www_form @params.slice(*ALLOWED_KEYS)
    end

    def url
      @url ||= URI("https://api.1nce.com/management-api/v1/sims?#{params_query}")
    end

    def connection
      @connection ||= Net::HTTP.new(url.host, url.port).tap do |http|
        http.use_ssl = true
      end
    end

    def request
      Net::HTTP::Get.new(url).tap do |request|
        request['Accept'] = 'application/json'
        request['Authorization'] = "Bearer #{@access_token}"
      end
    end
  end
end
