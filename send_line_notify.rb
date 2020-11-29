#! /usr/local/bin/ruby
# coding: utf-8

require 'net/http'
require 'uri'
require 'dotenv/load'

class Line
  TOKEN = ENV['LINETOKEN']
  URI = URI.parse('https://notify-api.line.me/api/notify')

  def make_request(msg)
    request = Net::HTTP::Post.new(URI)
    request['Authorization'] = "Bearer #{TOKEN}"
    request.set_form_data(message: msg)
    request
  end
  
  def send(msg)
    request = make_request(msg)
    Net::HTTP.start(URI.hostname, URI.port, use_ssl: URI.scheme == 'https') do |https|
        https.request(request)
    end
  end
end

# line = Line.new

# msg = 'サイトに更新がありました - http://www.pet-home.jp/dogs/cg_1060/baby/girl/'

# res = line.send(msg)
# puts res.code
# puts res.body