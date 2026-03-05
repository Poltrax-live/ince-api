module InceApi
  class GetSimDataQuota
    def initialize(access_token:, iccid:)
      @access_token = access_token
      @iccid = iccid
    end

    def sim_status
      response = connection.request(request)
      if response.body.to_s.empty?
        {'status_code' => 404, 'error_message' => 'SIM with ICCID not found'}
      else
        JSON.parse(response.body)
      end
    rescue JSON::ParserError
      {'status_code' => response.code.to_i, 'error_message' => "Invalid JSON response: #{response.body[0..200]}"}
    end

    private

    def url
      @url ||= URI("https://api.1nce.com/management-api/v1/sims/#{@iccid}/quota/data")
    end

    def connection
      @connection ||= Net::HTTP.new(url.host, url.port).tap do |http|
        http.use_ssl = true
      end
    end

    def request
      Net::HTTP::Get.new(url).tap do |request|
        request["Accept"] = 'application/json'
        request['Authorization'] = "Bearer #{@access_token}"
      end
    end
  end
end
