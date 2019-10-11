require_relative "local_lib/entitlement_lib.rb"
############################################################################################################
######@@#####TEST CASE: VERIFY SUSPICIOUS ENTITLEMENT UPDATE ACTIVITY######################################
############################################################################################################
describe "********** TEST CASE: VERIFY SUSPICIOUS ENTITLEMENT UPDATE ACTIVITY **********" do
  tenant_name = "suspicious-entitlement-update-automation-xms-admin"
  user_email = tenant_name.gsub("-", "+")+"@xirrus.com"
  time = Time.now + 12.months
  old_expirationDate = time.to_i*1000
  new_expirationDate = nil
  transaction_id = nil
  tenant_load = get_tenant_load.update({name: tenant_name, erpId: tenant_name, expirationDate: old_expirationDate, 
                                        tenantProperties: {easypassPortalExpiration: old_expirationDate, apCountLimit: 4, 
                                        allowEasypass: true, allowAosAppcon: true}})
  user_load = get_user_load.update({email: user_email, firstName: tenant_name})
  tenant_id = nil
  arrays=["NAUTO0000000006", "NAUTO0000000007", "NAUTO0000000008", "NAUTO0000000009"]
  to_email_address = "xmsc.sync.alerts@cambiumnetworks.com"
  
  before :all do
  #create tenant and User
    @tenant = JSON.parse(@api.post_add_tenant(tenant_load).body)
    @user = JSON.parse(@api.post_add_user_to_tenant(@tenant['id'], user_load).body)
    @fog = VMD::FogSession.new({username: user_email, password: @password, env: @env, aosVersion: "8.4.9-7335"})
    @eapi = entitlement_api
    @gmail = API::GmailApi.new(args={})
    @logstash= API::LogstashApi.new({env: @env})
  end
  after :all do
  #Delete Tenant and User
    @api.delete_tenant_by_name(tenant_name)
  end
  
  it "add one array with expiration date in next 12 months" do    
      @fog.add_array_with_serial_expiration(arrays.first, old_expirationDate)
  end
  it "add one more slot with 60 month expiration term" do
      transaction_id= "kar#{Time.now.to_i}"
      response = @eapi.post_eapi_add_tenant(tenant_load={erpId: tenant_name,
                 transactionId: transaction_id,
                 contactEmail: [user_email],
                 product: "XMS", 
                 term: 60, 
                 count: 1, 
                 appControl: true, 
                 easyPass: true})
       expect(response.code).to eq(200)
  end
  it "verify suspicous entitlement email for longer duration" do 
    sleep 10
    new_expiration = (Time.now + 60.months + 1.days).to_i * 1000      
    email = @gmail.get_latest_emails_from_xirrus_for_user(to_email_address).last
    expect(email.size).to be > 0
    expect(email.subject).to include(to_email_address)
    expect(email.subject).to include("Suspicious Entitlement")
    email_content = Nokogiri::HTML(email.body.to_s,'UTF-8')
    expect(email_content.css("h1").first.text).to eq("Suspicious Entitlement")
    expect(email_content.css("p")[0].text).to eq("Reason: New expiration is >50% of term and <75% of slots are used")
    expect(email_content.css("p")[1].text).to eq("ERP: #{tenant_name}")
    expect(email_content.css("p")[2].text).to include(DateTime.strptime((old_expirationDate * 0.001).to_s, '%s').strftime("%y-%m-%d"))
    expect(email_content.css("p")[3].text).to eq("Filled AP Count: 1")
    expect(email_content.css("p")[4].text).to eq("Requested AP Slot Count: 1")
    expect(email_content.css("p")[5].text).to eq("Previous Slot Count: 4")
    expect(email_content.css("p")[6].text).to eq("Requested Term: 60")
    expect(email_content.css("p")[7].text).to include(DateTime.strptime((new_expiration * 0.001).to_s, '%s').strftime("%y-%m-%d"))
  end
  it "verify suspicious entitlement server log for longer duration" do
    sleep 10
    log = @logstash.search(["suspicious", "warn", transaction_id], 10)[0]
    log_contain=log["_source"]["message"]
    expect(log_contain[1]).to include("New expiration is >50% of term and <75% of slots are used")
    expect(log_contain[1]).to include("erp=#{tenant_name}")
    expect(log_contain[1]).to include("requestedTerm=60")
    expect(log_contain[1]).to include("usedSlots=1")
    expect(log_contain[1]).to include("requestedSlotCount=1")
    expect(log_contain[1]).to include("previousSlotCount=4")
  end
  it "Recreate setup by deleting and creating tenant for adding slot with sorter duration" do
     time = Time.now + 60.months
     old_expirationDate = time.to_i*1000
     @api.delete_tenant_by_name(tenant_name)
     tenant_load = get_tenant_load.update({name: tenant_name, erpId: tenant_name, expirationDate: old_expirationDate, 
                                        tenantProperties: {easypassPortalExpiration: old_expirationDate, apCountLimit: 4, 
                                        allowEasypass: true, allowAosAppcon: true}})
     @tenant = JSON.parse(@api.post_add_tenant(tenant_load).body)
     @user = JSON.parse(@api.post_add_user_to_tenant(@tenant['id'], user_load).body)
   end
  it "add arrays with expiration date in next 60 months" do    
    arrays.each do|ap_sn|
      @fog.add_array_with_serial_expiration(ap_sn, time.to_i*1000)
    end
  end
  it "add one more slot with 12 month expiration term" do
      transaction_id= "kar#{Time.now.to_i}"
      response = @eapi.post_eapi_add_tenant(tenant_load={erpId: tenant_name,
                 transactionId: transaction_id,
                 contactEmail: [user_email],
                 product: "XMS", 
                 term: 12, 
                 count: 1, 
                 appControl: true, 
                 easyPass: true})
       expect(response.code).to eq(200)
  end
  it "verify suspicous entitlement email for shorter duration" do
    sleep 10
    new_expiration = (Time.now + 12.months + 1.days).to_i * 1000      
    email = @gmail.get_latest_emails_from_xirrus_for_user(to_email_address).last
    expect(email.size).to be > 0
    expect(email.subject).to include(to_email_address)
    expect(email.subject).to include("Suspicious Entitlement")
    email_content = Nokogiri::HTML(email.body.to_s,'UTF-8')
    expect(email_content.css("h1").first.text).to eq("Suspicious Entitlement")
    expect(email_content.css("p")[0].text).to eq("Reason: New term terminates >12 months before the current Tenant expiration")
    expect(email_content.css("p")[1].text).to eq("ERP: #{tenant_name}")
    expect(email_content.css("p")[2].text).to include(DateTime.strptime((old_expirationDate * 0.001).to_s, '%s').strftime("%y-%m-%d"))
    expect(email_content.css("p")[3].text).to eq("Filled AP Count: 4")
    expect(email_content.css("p")[4].text).to eq("Requested AP Slot Count: 1")
    expect(email_content.css("p")[5].text).to eq("Previous Slot Count: 4")
    expect(email_content.css("p")[6].text).to eq("Requested Term: 12")
    expect(email_content.css("p")[7].text).to include(DateTime.strptime((new_expiration * 0.001).to_s, '%s').strftime("%y-%m-%d"))    
  end
  it "verify suspicious entitlement server log for shorter duration" do
    sleep 10
    log = @logstash.search(["suspicious", "warn", transaction_id], 10)[0]
    log_contain=log["_source"]["message"]
    expect(log_contain[1]).to include("New term terminates >12 months before the current Tenant expiration")
    expect(log_contain[1]).to include("erp=#{tenant_name}")
    expect(log_contain[1]).to include("requestedTerm=12")
    expect(log_contain[1]).to include("usedSlots=4")
    expect(log_contain[1]).to include("requestedSlotCount=1")
    expect(log_contain[1]).to include("previousSlotCount=4")
  end
  it "logout testuser" do
   @ui.logout
 end
end