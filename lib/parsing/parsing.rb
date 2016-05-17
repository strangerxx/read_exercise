# coding: utf-8
require 'net/http'
require 'nokogiri'
require 'open-uri'

#Абстрактный класс для парсинга страниц
class Parsing
  def initialize(url)
    @url = url
  end

  def get_url()
    url = URI.encode(@url.strip)
    # url = fetch(url)
    begin
      page = Nokogiri::HTML(open(url, "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36"))
    rescue SocketError => ex
      p "No Internet"
      exit
    end
    return page
  end

  def fetch(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    ua = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36"

    url = URI.parse(uri_str)
    req = Net::HTTP::Get.new(url.path, { 'User-Agent' => ua })
    response = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    case response
    when Net::HTTPSuccess     then return url
    when Net::HTTPRedirection then fetch(URI.encode(response['location']), limit - 1)
    else
      response.error!
    end
  end
end
