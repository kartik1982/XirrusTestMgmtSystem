require_relative "local_lib/entitlement_lib.rb"
############################################################################################################
######@@#####TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE######################################
############################################################################################################
describe "********** TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE **********" do
  tenant_name = "tenant-renew-automation-xms-admin"
  user_email = tenant_name.gsub("-", "+")+"@xirrus.com"
  time = Time.now + 10.days
  tenant_load = get_tenant_load.update({name: tenant_name, erpId: tenant_name, expirationDate: time.to_i*1000, 
                                        tenantProperties: {easypassPortalExpiration: time.to_i*1000, apCountLimit: 4, 
                                        allowEasypass: true, allowAosAppcon: true}})
  user_load = get_user_load.update({email: user_email, firstName: tenant_name})
  tenant_id = nil
  arrays=["NAUTO0000000002", "NAUTO0000000003", "NAUTO0000000004", "NAUTO0000000005"]
  before :all do
  #create tenant and User
    @tenant = JSON.parse(@api.post_add_tenant(tenant_load).body)
    @user = JSON.parse(@api.post_add_user_to_tenant(@tenant['id'], user_load).body)
    @fog = VMD::FogSession.new({username: user_email, password: @password, env: @env, aosVersion: "8.4.9-7335"})
    @eapi = entitlement_api
  end
  after :all do
  #Delete Tenant and User
    @api.delete_tenant_by_name(tenant_name)
  end
  it "add arrays with expiration date in next 10 days" do    
    arrays.each do|ap_sn|
      @fog.add_array_with_serial_expiration(ap_sn, time.to_i*1000)
    end
  end
  it "logout and login as testuser" do
    @ui.logout
    @ui.login(@login_url, user_email, @password)
    @ui.close_all_toast_windows
    sleep 1
    @ui.css("#header_mynetwork_link").click
  end
  it "renew all access points in tenant for 12 months using entilement api" do
      response = @eapi.post_eapi_renew_tenant(tenant_load={erpId: tenant_name,
                 transactionId: "kar#{Time.now.to_i}",
                 product: "XMS", 
                 term: 12, 
                 count: 4, 
                 appControl: true, 
                 easyPass: true})
       expect(response.code).to eq(200)
  end
  it "verify all access points in tenant renewed for 12 months" do
      arrays.each do|ap_sn|
        array = JSON.parse(@api.get_global_by_serial(ap_sn).body)["xirrusArrayDto"]
        expect(array["expirationDate"]).to eq((time + 12.months).to_i * 1000)
      end 
  end
 it "logout testuser" do
   @ui.logout
 end
end