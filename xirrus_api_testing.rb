require_relative 'api/api_client/api_client.rb'
require 'json'

api= API::ApiClient.new({host: "https://login-test01.cloud.xirrus.com", username: "kartik.aiyar@riverbed.com", password: "Kartik@123"})
tenants = JSON.parse(api.get_search_tenants("employee").body)
puts tenants.size
tenants = JSON.parse(api.get_tenants.body)['data']
puts tenants.size