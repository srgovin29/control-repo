#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI("http://asterank.com/api/asterank?query={\"e\":{\"$lt\":0.1},\"i\":{\"$lt\":4},\"a\":{\"$lt\":1.5}}&limit=1")

http = Net::HTTP.new(url.host, url.port);
request = Net::HTTP::Get.new(url)

response = http.request(request)
puts response.read_body