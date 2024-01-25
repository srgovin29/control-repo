#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI('http://api.qrserver.com/v1/create-qr-code/?data=HelloWorld!&size=100x100')

http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Post.new(url)

response = http.request(request)
puts response.read_body
