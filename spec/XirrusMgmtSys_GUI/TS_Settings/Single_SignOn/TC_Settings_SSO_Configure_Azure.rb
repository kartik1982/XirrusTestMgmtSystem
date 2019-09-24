require_relative "../local_lib/settings_lib.rb"
require_relative "../local_lib/single_signon_lib.rb"
#######################################################################################################
############TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES########################################
#######################################################################################################

describe "********** TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES **********" do
  before :all do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
   end
  it "Find the Single Sign-On domains available in the application" do
    @@sso_domains = @ng.get_ssodomain_all_tenants.body
  end
  it "Find the appropriate IDs" do
    @@ids_array = []
    @@sso_domains.each do |sso_entry|
      @@ids_array.push(sso_entry["id"])
    end
  end
  it "Delete the Single Sign-On domains using the appropriate IDs" do
    @@ids_array.each do |id|
      @deleted_domain = @ng.delete_ssodomain(id).body
      sleep 2
      expect(@deleted_domain).to eq("\"Sso Domain deleted\"")
    end
  end
  it "Verify no domain entries are still available" do
    @sso_domains = @ng.get_ssodomain_all_tenants.body
    expect(@sso_domains).to eq([])
  end
end


describe "********** TEST CASE: SETTINGS - SINGLE SIGN-ON - AZURE **********" do # Created on : 28/08/2017
  include_examples "go to settings then to tab", "User Accounts"
  include_examples "go to sso tab"
  include_examples "verify general features of sso tab"
  include_examples "enable disable sso", "Enable", "Azure"
  include_examples "enable microsoft azure", $azure_user, $azure_password
  include_examples "enable disable sso", "Disable"

end

describe "********** TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES **********" do
  before :all do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
   end
  it "Find the Single Sign-On domain  available in the application" do
    @@sso_domains = @ng.get_ssodomain_all_tenants.body
  end
  it "Find the appropriate IDs" do
    @@ids_array = []
    @@sso_domains.each do |sso_entry|
      @@ids_array.push(sso_entry["id"])
    end
  end
  it "Delete the Single Sign-On domains using the appropriate IDs" do
    @@ids_array.each do |id|
      @deleted_domain = @ng.delete_ssodomain(id).body
      sleep 2
      expect(@deleted_domain).to eq("\"Sso Domain deleted\"")
    end
  end
  it "Verify no domain entries are still available" do
    @sso_domains = @ng.get_ssodomain_all_tenants.body
    expect(@sso_domains).to eq([])
  end
end
