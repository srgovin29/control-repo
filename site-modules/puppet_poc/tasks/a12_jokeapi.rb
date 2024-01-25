#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI('https://v2.jokeapi.dev/joke/Any?type=twopart')

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)
puts response.read_body
