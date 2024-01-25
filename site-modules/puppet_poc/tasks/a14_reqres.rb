#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI('https://reqres.in/api/users')

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Get.new(url)
request['Content-Type'] = 'application/json'
request.body = JSON.dump({
                           "username": 'srinivasan',
  "email": 'test@gmail.com',
  "password": 'Welcometo2024*'
                         })

response = https.request(request)
puts response.read_body
