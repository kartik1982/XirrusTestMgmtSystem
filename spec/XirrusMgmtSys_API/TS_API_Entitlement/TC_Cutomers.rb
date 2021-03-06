require_relative "local_lib/entitlement_api_lib.rb"
describe "*********TESTCASE: ENTITLEMENT API FOR CUSTOMER***********" do
  erp_id = "entitlement-erpid-automation-api"
  tenant_name ="entitlement-tenant-automation-api"
  email_address = "entitlement.user01@contact.com"
  expirationDate=nil
  count= 20
  tenant_load={erpId: erp_id,
               transactionId: "kar#{Time.now.to_i}",
               name: tenant_name, 
               contactEmail: [ email_address, "entitlement.user02@contact.com" ],  
               product: "XMS", 
               term: 12, 
               count: count, 
               appControl: false, 
               easyPass: true, 
               parentErpId: nil}
  before :all do
    @eapi = entitlement_api  
    @fog = VMD::FogSession.new({env: @env})  
  end
  after :all do
    @api.delete_tenant_by_name(tenant_name)
  end
  it "verify entitlement API to add tenant with erpid" do            
    response = @eapi.post_eapi_add_tenant(tenant_load)
    expect(response.code).to eq(200)
    expirationDate = JSON.parse(response.body)['expirationDate']
  end
  it "verify entitlement API for get cusomter using erpid" do    
    response = @eapi.get_eapi_tenant_by_erpid(erp_id)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)
    expect(tenant['erpId']).to eq(erp_id)
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(false)
    expect(tenant['maxCount']).to eq(count)    
  end
  it "verify entitlement API to add order tenant with erpid" do    
    tenant_load.update({count: 30, transactionId: "kar#{Time.now.to_i}"})       
    response = @eapi.post_eapi_add_tenant(tenant_load)
    expect(response.code).to eq(200)
    expect(JSON.parse(response.body)["expirationDate"]).to eq(expirationDate)
  end
  it "verify that user received email for new account creation" do
    gm = API::GmailApi.new(args={})
    email = gm.get_latest_emails_from_riverbed_for_user(email_address).first
    expect(email.size).to be > 0
    expect(email.subject).to include(email_address)
    expect(email.subject).to include(tenant_name)
  end
  it "login xms cloud using new user created by entitlement" do
    user = @api.get_global_user_by_email(email_address)    
    user = JSON.parse(user.body)
    expect(user["forceResetPassword"]).to eq(true)
    # #set user password to known
    response = @api.put_update_user_password_by_userid(user['id'], "Xirrus!23")
    @ui.logout()
    sleep 1
    @ui.login_without_url(email_address, "Xirrus!23")
    sleep 1
    if @browser.url.include?("/eula")
      @ui.css(".button.submitBtn").click
      sleep 1
    end
    @browser.element(name: "j_currentpassword").send_keys "Xirrus!23"
    @browser.element(name: "j_newpassword").send_keys @password
    @browser.element(name: "j_newpassword_confirm").send_keys @password
    @ui.css(".button.submitBtn").click
    @ui.close_all_toast_windows
    expect(@ui.css("div.header .title").text).to eq("Welcome")
    @ui.css(".guidedTour").click
    @ui.css("#tour_exit").click
    sleep 1
    @ui.css("#_jq_dlg_btn_1").click
    sleep 1
    @ui.css("#header_mynetwork_link").click
  end
  it "Provision Access Point to tenant and activate Access Point" do    
    @fog.add_Provision_array_by_serial_with_erpid(erp_id, "NAUTO0000000001")
    sleep 2
  end
  it "verify entitlement API to renew existing customer Entitlement" do 
    tenant_load.update({transactionId: "kar#{Time.now.to_i}"})
    response = @eapi.post_eapi_renew_tenant(tenant_load.except(:name, :contactEmail, :parentErpId))
    expect(response.code).to eq(200)
    old_expiration = DateTime.strptime(((expirationDate * 0.001) + 12.months).to_s, '%s').strftime("%m-%d-%y")
    new_expiration = DateTime.strptime((JSON.parse(response.body)['expirationDate'] * 0.001).to_s, '%s').strftime("%m-%d-%y")
    expect(old_expiration).to eq(new_expiration)
  end  
  it "verify entitlement API for Upgrade customer using erpid" do
    tenant_load.update({appControl: true, transactionId: "kar#{Time.now.to_i}"})
    response = @eapi.put_eapi_upgrade_tenant(tenant_load.except(:name, :contactEmail, :parentErpId, :product, :term, :count))
    expect(response.code).to eq(200)
  end
  it "verify entitlement API for get customer using email address" do
    response = @eapi.get_eapi_tenant_by_email(email_address)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body).first
    expect(tenant['erpId']).to eq(erp_id)
    expect(tenant['name']).to eq(tenant_name)
    expect(tenant['appControl']).to eq(true)
    expect(tenant['maxCount']).to eq(50)
  end  
end