require_relative "local_lib/entitlement_lib.rb"
############################################################################################################
######@@#####TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE######################################
############################################################################################################
describe "********** TEST CASE: VERIFY TENANT WILL EXPIRE AND EXPIRED MESSAGE **********" do
  tenant_name = "tenant-upgrade-automation-xms-admin"
  user_email = tenant_name.gsub("-", "+")+"@xirrus.com"
  time = Time.now + 12.months
  expirationDate = time.to_i*1000
  tenant_load = get_tenant_load.update({name: tenant_name, erpId: tenant_name, expirationDate: expirationDate, 
                                        tenantProperties: {easypassPortalExpiration: expirationDate, apCountLimit:2, 
                                        allowEasypass: false, allowAosAppcon: false}})
  user_load = get_user_load.update({email: user_email, firstName: tenant_name})
  tenant_id = nil
  arrays=["NAUTO00000000010", "NAUTO00000000011"]
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
      @fog.add_array_with_serial_expiration(ap_sn, expirationDate)
    end
  end
  it "verify tenant application control and Easypass turn off using Entitlement API" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(false)
    expect(tenant['easyPass']).to eq(false)
    expect(tenant['maxCount']).to eq(2)    
    expect(tenant['expirationDate']).to eq(expirationDate)
  end
  it "Upgrade tenant application control to ON and easypass to OFF" do
    response = @eapi.put_eapi_upgrade_tenant(tenant_load={erpId: tenant_name,
               transactionId: "kar#{Time.now.to_i}",
               appControl: true, 
               easyPass: false})
     expect(response.code).to eq(200)
  end
  it "verify tenant application control ON and Easypass OFF using Entitlement API" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['easyPass']).to eq(false)
    expect(tenant['maxCount']).to eq(2)    
    expect(tenant['expirationDate']).to eq(expirationDate)
  end
  it "Upgrade tenant application control to ON and easypass to ON" do
    response = @eapi.put_eapi_upgrade_tenant(tenant_load={erpId: tenant_name,
               transactionId: "kar#{Time.now.to_i}",
               appControl: true, 
               easyPass: true})
     expect(response.code).to eq(200)
  end
  it "verify tenant application control ON and Easypass ON using Entitlement API" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['easyPass']).to eq(true)
    expect(tenant['maxCount']).to eq(2)    
    expect(tenant['expirationDate']).to eq(expirationDate)
  end
  it "Upgrade tenant application control KEEP ON and set easypass to OFF" do
    response = @eapi.put_eapi_upgrade_tenant(tenant_load={erpId: tenant_name,
               transactionId: "kar#{Time.now.to_i}",
               appControl: true, 
               easyPass: false})
     expect(response.code).to eq(200)
  end
  it "verify tenant application control remain ON and Easypass ON using Entitlement API" do    
    response = @eapi.get_eapi_tenant_by_erpid(tenant_name)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)    
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['easyPass']).to eq(true)
    expect(tenant['maxCount']).to eq(2)    
    expect(tenant['expirationDate']).to eq(expirationDate)
  end
end