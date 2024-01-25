#!/opt/puppetlabs/puppet/bin/ruby
require 'uri'
require 'net/http'
require 'json'
require 'open3'
require 'puppet'

url = URI('http://api.crossref.org/works?query.bibliographic="Toward a Unified Theory of High-Energy Metaphysics, Josiah Carberry 2008-08-13"&rows=2')

http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Get.new(url)

response = http.request(request)
puts response.read_body
