require_relative 'api/sfdc_api/sfdc_api.rb'
require_relative 'api/api_client/api_client.rb'

ranN = Time.now.to_i
@env = "test03"
@accName = "xmsc_automation_#{ranN}"
@apsn = "X0187167203E5"
@@ezpExpTime = (DateTime.now - (2160/24.0)).strftime("%Y-%m-%d")

api= API::ApiClient.new({host: "https://login-#{@env}.cloud.xirrus.com", username: "kartik.aiyar@riverbed.com", password: "Kartik@123"})
  
sfdc = API::SfdcApi.new
#Add Account and Delete Account
res = sfdc.post_add_account({ accountName: @accName,
                              cloudEnvironment: @env,
                              accountType: "Current Customer",
                              owner: "Automation Tester",
                              contactEmail: "#{@accName}@gmail.com",
                              allowEasypass: false,  
                              easypassPortalExpiration: "#@@ezpExpTime"            # This will take away 2160 hours or 90 days from current date
                            })
puts res.code
puts res.body
sleep 5
#Add Access Point to account 
AP = {
    accountName: @accName,
    serialNumber: @apsn,
    licenseKey: " 0UCF9-6E77T-F2Q6M-VCNR9",
    productNumber: "XD2-230",
    model: "XD2-230",
    managementType: "XMS-C",
    ethMacAddress: "48:c0:93:72:03:e5",
    macAddress: "48:c0:93:72:10:f0",
    swVersion: "8.5",
    shippedDate: "6/23/2017",
    swSupportExpiration: "09/16/2021",
    hwWarrantyExpiration: "09/16/2021",
    hwSupportExpiration: "09/16/2021"
    }
puts "Adding Array to SFDC..."
res = sfdc.post_add_array_into_account(AP)

puts res.body
puts res.code
#wait for items to be created
sleep 5
# Sync SFDC
response = api.get_cutomer_data_sync
puts response.body
puts response.code
#wait for XMSC to sycn with sfdc
sleep 20
# Delete Acccess Point
res = sfdc.delete_array_by_serial(@apsn)
  
puts res.body
puts res.code

#Delete Account

 res = sfdc.delete_account_with_account_name(@accName)
 puts res.body
 puts res.code

api.delete_tenant_by_name(@accName)