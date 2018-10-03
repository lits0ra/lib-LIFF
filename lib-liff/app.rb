require 'net/http'
require 'uri'
require 'json'
require './lib-liff/config'
class LINEFrontEndFramework
    def initialize(channel_access_token)
        @CHANNEL_ACCESS_TOKEN = channel_access_token
    end

    def add_liff(view_type, view_url)
        uri = URI.parse(Config::HOST)
        request = Net::HTTP::Post.new(uri)
        request.content_type = "application/json"
        request["Authorization"] = "Bearer #{@CHANNEL_ACCESS_TOKEN}"
        request.body = JSON.dump({
            "view" => {
                "type" => view_type,
                "url" => view_url
            }
        })
        req_options = {
            use_ssl: uri.scheme == "https",
        }
        response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
            http.request(request)
        end
        return response.body
    end
    
end
