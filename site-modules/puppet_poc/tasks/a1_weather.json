#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'


url = URI("https://pro.openweathermap.org/data/2.5/forecast/climate?q=Singapore&appid=680d7e603f21fa21cce61dd3fb08c935")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)

response = https.request(request)
puts response.read_body