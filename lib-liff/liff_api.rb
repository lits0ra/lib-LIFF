require 'net/http'
require 'uri'
require 'json'
require './lib-liff/liff_config'
class LIFF
    def initialize(channel_access_token)
        @CHANNEL_ACCESS_TOKEN = channel_access_token
    end

    def add_liff(view_type=nil, view_url=nil)
        if view_type == nil and view_url == nil
            raise("You must enter view_type and view_url.")
        elsif view_type == nil
            raise("You must enter view_type.")
        elsif view_url == nil
            raise("You must enter view_url.")
        else
            uri = URI.parse(LIFFConfig::HOST)
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
            if response.code == "200"
                return "line://app/#{JSON.load(response.body)["liffId"]}"
            elsif response.code == "400"
                raise("400 Error\n・The request contains an invalid value.\n・The maximum number of LIFF applications that can be added to the channel has been reached.")
            elsif response.code == "401"
                raise("401 Error\nCertification failed.")
            end
        end
    end
    def delete_liff(liffId=nil)
        if liffId == nil
            raise("You must enter liffId.")
        else
            uri = URI.parse("#{LIFFConfig::HOST}/#{liffId}")
            request = Net::HTTP::Delete.new(uri)
            request["Authorization"] = "Bearer #{@CHANNEL_ACCESS_TOKEN}"
            req_options = {
                use_ssl: uri.scheme == "https",
            }
            response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
                http.request(request)
            end
            if response.code == "200"
                return "Success"
            elsif response.code == "401"
                raise("401 Error\nCertification failed.")
            elsif response.code == "404"
                raise("404 Error\n・The specified LIFF application does not exist.\n・The specified LIFF application belongs to another channel.")
            end
        end
    end
end