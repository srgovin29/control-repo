#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI("https://dummy.restapiexample.com/api/v1/create")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url)
request["Content-type"] = "application/json"
request.body = JSON.dump({
  "name": "test100",
  "salary": "123",
  "age": "23"
})

response = https.request(request)
puts response.read_body

