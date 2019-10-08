require_relative 'api/api_client/api_client.rb'
require_relative 'api/entitlement_api/entitlement_api.rb'
require_relative 'vmd/fog/fog_session.rb'
require 'json'
require 'active_support/time'
@username= "suspicious+entitlement+update+automation+xms+admin@xirrus.com"
@password = "Qwerty1@"
@erpid = "suspicious-entitlement-update-automation-xms-admin"
@env = "test03"
@login_url = "https://login-#{@env}.cloud.xirrus.com"

# Add Access Points
fog = VMD::FogSession.new({username: @username, password: @password, env: @env, aosVersion: "8.4.9-7335"})
# # fog.add_array_into_tenant_to_current_tenant("NODEJS31D3B20F73")
# # fog.add_array_into_tenant_to_current_tenant("NODEJS8D63E9C3A6")
# # fog.add_array_into_tenant_to_current_tenant("NODEJS18836B8575")
# # fog.activate_array_by_serial("NODEJS6D58654295")
# fog.stop_all_process_running_for_ap_serial("NODEJS31D3B20F73")
# fog.stop_all_process_running_for_ap_serial("NODEJS8D63E9C3A6")
# fog.stop_all_process_running_for_ap_serial("NODEJS18836B8575")
# fog.stop_all_process_running_for_ap_serial("NODEJS6D58654295")
# fog.tun_on_array("NODEJS31D3B20F73")
# fog.tun_on_array("NODEJS8D63E9C3A6")
# fog.tun_on_array("NODEJS18836B8575")
# fog.tun_on_array("NODEJS6D58654295")
# time = Time.now + 10.days
# fog.add_N_number_Arrays(4, time.to_i*1000)


api= API::ApiClient.new({host: @login_url, username: "kartik.aiyar@riverbed.com", password: "Kartik@123"})
# tenants = JSON.parse(api.get_search_tenants("employee").body)
# puts tenants.size
# tenants = JSON.parse(api.get_tenants.body)['data']
# puts tenants.size
get_entitlement_api_args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test03-api-94151060.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
    }
    
eapi = API::EntitlementApi.new(get_entitlement_api_args)
response = eapi.get_tenant_by_erpid(@erpid)
# response = eapi.post_renew_tenant(tenant_load={erpId: @erpid,
                 # transactionId: "1234567890",
                 # product: "XMS", 
                 # term: 12, 
                 # count: 1, 
                 # appControl: true, 
                 # easyPass: true})
response = eapi.post_add_tenant({erpId: @erpid,
                 transactionId: "1234567890",
                 name: @erpid, 
                 contactEmail: [ "testing.user02@contact.com" ],  
                 product: "XMS", 
                 term: 12, 
                 count: 1, 
                 appControl: true, 
                 easyPass: true})
response = eapi.get_tenant_by_erpid(@erpid)
sleep 1