require_relative "local_lib/entitlement_lib.rb"
############################################################################################################
######@@#####TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE######################################
############################################################################################################
describe "********** TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE **********" do
  tenant_name = "tenant-extend-automation-xms-admin"
  user_email = tenant_name.gsub("-", "+")+"@xirrus.com"
  time = Time.now + 24.months
  expirationDate = time.to_i*1000
  new_expirationDate, new_date = nil
  tenant_load = get_tenant_load.update({name: tenant_name, erpId: tenant_name, expirationDate: expirationDate, 
                                        tenantProperties: {easypassPortalExpiration: expirationDate, apCountLimit:2, 
                                        allowEasypass: true, allowAosAppcon: true}})
  user_load = get_user_load.update({email: user_email, firstName: tenant_name})
  tenant_id = nil
  arrays=["NAUTO00000000012", "NAUTO00000000013","NAUTO00000000014", "NAUTO00000000015"]
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
  it "add access points to tenant with NO expiration dates" do    
      @fog.add_Provision_array_by_serial_with_erpid(tenant_name, arrays[0])
      @fog.add_Provision_array_by_serial_with_erpid(tenant_name, arrays[1])
      sleep 10
  end
  it "verify tenant expiration dates are 24 months" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['easyPass']).to eq(true)
    expect(tenant['maxCount']).to eq(2)    
    expect(tenant['expirationDate']).to eq(expirationDate)
  end
  it "verify access points expiration dates are 24 months" do    
      array = JSON.parse(@api.get_global_by_serial(arrays[0]).body)["xirrusArrayDto"]
      expect(array["expirationDate"]).to eq(expirationDate)
      array = JSON.parse(@api.get_global_by_serial(arrays[1]).body)["xirrusArrayDto"]
      expect(array["expirationDate"]).to eq(expirationDate)
  end
  it "Extends tenants expiration 48 months and add two extra slot" do
    new_expirationDate = (Time.now + 48.months + 1.days).to_i*1000
    new_date = DateTime.strptime((new_expirationDate * 0.001).to_s, '%s').strftime("%y-%m-%d")
    transaction_id= "kar#{Time.now.to_i}"
    response = @eapi.post_eapi_add_tenant(tenant_load={erpId: tenant_name,
               transactionId: transaction_id,
               contactEmail: [user_email],
               product: "XMS", 
               term: 48, 
               count: 2, 
               appControl: true, 
               easyPass: true})
     expect(response.code).to eq(200)
     act_date = DateTime.strptime((JSON.parse(response.body)['expirationDate'] * 0.001).to_s, '%s').strftime("%y-%m-%d")
     expect(act_date).to eq(new_date)
  end
  it "add access points to tenant with NO expiration date" do    
      @fog.add_Provision_array_by_serial_with_erpid(tenant_name, arrays[2])
      @fog.add_Provision_array_by_serial_with_erpid(tenant_name, arrays[3])
      sleep 10
  end
  it "verify tenant expiration dates 48 months" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['easyPass']).to eq(true)
    expect(tenant['maxCount']).to eq(4)    
    act_date = DateTime.strptime((tenant['expirationDate'] * 0.001).to_s, '%s').strftime("%y-%m-%d")
    expect(act_date).to eq(new_date)
  end
  it "verify arrays expiration dates are two access points 24 months and two access points 48 months" do    
      array = JSON.parse(@api.get_global_by_serial(arrays[0]).body)["xirrusArrayDto"]
      expect(array["expirationDate"]).to eq(expirationDate)
      array = JSON.parse(@api.get_global_by_serial(arrays[1]).body)["xirrusArrayDto"]
      expect(array["expirationDate"]).to eq(expirationDate)
      array = JSON.parse(@api.get_global_by_serial(arrays[2]).body)["xirrusArrayDto"]
      act_date = DateTime.strptime((array["expirationDate"] * 0.001).to_s, '%s').strftime("%y-%m-%d")
      expect(act_date).to eq(new_date)
      array = JSON.parse(@api.get_global_by_serial(arrays[3]).body)["xirrusArrayDto"]
      act_date = DateTime.strptime((array["expirationDate"] * 0.001).to_s, '%s').strftime("%y-%m-%d")
      expect(act_date).to eq(new_date)
  end
end