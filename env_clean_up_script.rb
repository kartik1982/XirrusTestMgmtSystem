require_relative 'api/sfdc_api/sfdc_api.rb'
require_relative 'api/api_client/api_client.rb'


@env = "test03"
api= API::ApiClient.new({host: "https://login-#{@env}.cloud.xirrus.com", username: "kartik.aiyar@riverbed.com", password: "Kartik@123"})
  

#Delete all tenants include name filter
search_filter = "xmsc_automation"
tenants = JSON.parse(api.get_search_tenants(search_filter).body)
tenants.each do |tenant|
  api.delete_tenant_by_tenantid(tenant['id'])
end