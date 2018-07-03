module Scrapbox2docbase
  class Gyazo
    BASE_URL = 'https://api.gyazo.com/api/oembed'

    def self.get_response(url)
      uri = URI.parse("#{BASE_URL}?url=#{url}")

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.open_timeout = 5
        http.read_timeout = 10
        http.get(uri.request_uri)
      end

      case response.code
      when '200'
        JSON.parse(response.body)
      else
        message = JSON.parse(response.body)['message']
        puts "Error: #{message}"
        nil
      end
    end
  end
end
