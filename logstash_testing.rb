require_relative 'api/logstash_api/logstash_api.rb'

logstash= API::LogstashApi.new({env: "test03"})
logs = logstash.search(["XR52325004D9A", "preserve-ip-settings"], 10)
puts logs
logs.each do |log|
  item=log["_source"]["message"]
  puts item
end
sleep 1