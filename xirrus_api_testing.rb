require_relative 'api/api_client/api_client.rb'
require_relative 'api/entitlement_api/entitlement_api.rb'
require_relative 'vmd/fog/fog_session.rb'
require 'json'
require 'active_support/time'
@username= "kartik.aiyar@riverbed.com" #"suspicious+entitlement+update+automation+xms+admin@xirrus.com"
@password = "Kartik@123" #"Qwerty1@"
@erpid = "01NM7" #"suspicious-entitlement-update-automation-xms-admin"
@env = "test01"
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
args = { name: "suspicious-entitlement-update-automation-xms-admin",
                  erpId: "suspicious-entitlement-update-automation-xms-admin",
                  tenantProperties: {
                    apCountLimit: 4,
                    easypassPortalExpiration: Time.now + 12.months*1000,
                    allowEasypass: true,
                    allowAosAppcon: true},
                    expirationDate: Time.now + 12.months*1000,
                  products: ["XMS"]}

api= API::ApiClient.new({host: @login_url, username: "kartik.aiyar@riverbed.com", password: "Kartik@123"})
# tenants = JSON.parse(api.get_search_tenants("employee").body)
# puts tenants.size
# tenants = JSON.parse(api.get_tenants.body)['data']
# puts tenants.size
get_entitlement_api_args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test01-api-311195077.cloud.xirrus.com", #"https://test03-api-94151060.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
    }
    
eapi = API::EntitlementApi.new(get_entitlement_api_args)
response = eapi.get_eapi_tenant_by_erpid(@erpid)
# response = eapi.post_renew_tenant(tenant_load={erpId: @erpid,
                 # transactionId: "1234567890",
                 # product: "XMS", 
                 # term: 12, 
                 # count: 1, 
                 # appControl: true, 
                 # easyPass: true})
response = eapi.post_eapi_add_tenant({erpId: @erpid,
                 transactionId: "kar#{Time.now.to_i}",
                 name: @erpid, 
                 contactEmail: [ "kartik.aiyar@riverbed.com" ],  
                 product: "XMS", 
                 term: 60, 
                 count: 1, 
                 appControl: true, 
                 easyPass: true})
response = eapi.get_eapi_tenant_by_erpid(@erpid)
sleep 1