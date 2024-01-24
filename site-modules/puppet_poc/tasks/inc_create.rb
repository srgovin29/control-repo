require "uri"
require "net/http"

url = URI("https://dev218806.service-now.com/api/now/table/incident?sysparm_display_value=true&sysparm_exclude_reference_link=true&sysparm_fields=number,short_description,sys_created_on,state,sys_created_by,impact,priority,caller_id,description")

https = Net::HTTP.new(url.host, url.port)
https.use_ssl = true

request = Net::HTTP::Post.new(url, {'Content-Type' => 'application/json'})
#request["admin"] = "AIEJLtR5EvO6zX3bbDhxRPl6pQrWfCbP-2y_v3zgWEme"
request["Authorization"] = "Basic YWRtaW46Q2g9YURKbko4ZDMl"
#request["Cookie"] = "BIGipServerpool_dev218806=276864778.58176.0000; JSESSIONID=338349E90BFC309C5CF31FB1757177E4; glide_session_store=6223A0FB47F331101792D879316D4340; glide_user_route=glide.35672988f823e85c84a3b19747181b6e"

response = https.request(request)