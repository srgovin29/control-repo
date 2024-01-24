require 'json'
require 'open3'
require 'puppet'
require "uri"
require "net/http"

params = JSON.parse($stdin.read)
snow_server = params['snow_server']
inc_ep = params['inc_ep']
sysparm_display_value = params['sysparm_display_value']
sysparm_exclude_reference_link = params['sysparm_exclude_reference_link']
use_ssl = params['use_ssl']
sysparm_fields = params['sysparm_fields']
token = params['token']

incident_ep = snow_server + inc_ep
params = { "sysparm_display_value": sysparm_display_value,
    "sysparm_exclude_reference_link": sysparm_exclude_reference_link, "sysparm_fields": sysparm_fields }
puts incident_ep
puts params

uri = URI(incident_ep)
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = use_ssl
request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
request["Authorization"] = token


# url = URI("https://dev218806.service-now.com/api/now/table/incident?sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=number,short_description,sys_created_on,state,sys_created_by,impact,priority,caller_id,description")
# request["Cookie"] = "BIGipServerpool_dev218806=276864778.58176.0000; JSESSIONID=61BB83B8FC0BD6674B1EA111D27C7F62; glide_session_store=9886FBE347F331101792D879316D4362; glide_user_route=glide.35672988f823e85c84a3b19747181b6e"
begin
    response = https.request(request)
    puts response.read_body
rescue Puppet::Error => e
    puts({ status: 'failure', error: e.message }.to_json)
    exit 1    
end

