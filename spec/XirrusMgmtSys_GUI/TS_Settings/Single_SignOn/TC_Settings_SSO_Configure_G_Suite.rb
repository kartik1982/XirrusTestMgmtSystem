require_relative "../local_lib/settings_lib.rb"
require_relative "../local_lib/single_signon_lib.rb"
########################################################################################
###################TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES#################
########################################################################################
sso_domains={}
describe "********** TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES **********" do
  it "Delete the Single Sign-On domains using the appropriate IDs" do
    sso_domains = JSON.parse(@api.get_all_ssodomains_for_all_tenants.body)
    sso_domains.each do |domain|
      response = @api.delete_ssodomain_by_ssodomainid(domain['id'])
      sleep 2
      expect(JSON.parse(response.body)).to eq("Sso Domain deleted")
    end
  end
  it "Verify no domain entries are still available" do
    sso_domains = JSON.parse(@api.get_all_ssodomains_for_all_tenants.body)
    expect(sso_domains.size).to eq(0)
  end
end

describe "********** TEST CASE: SETTINGS - SINGLE SIGN-ON - G-SUITE **********" do # Created on : 23/08/2017
  include_examples "go to settings then to tab", "User Accounts"
  include_examples "go to sso tab"
  include_examples "verify general features of sso tab"
  include_examples "enable disable sso", "Enable", "G-Suite"
  include_examples "enable disable sso", "Enable", "Azure"
  include_examples "enable disable sso", "Enable", "G-Suite"
  include_examples "enable google directory synchronization", "mykhaylo@xirrus.org", "Xirrus!234"
  include_examples "enable disable sso", "Disable"

end

describe "********** TEST CASE: NG - SINGLE SIGN-ON - DELETE ALL ENTRIES **********" do
  it "Delete the Single Sign-On domains using the appropriate IDs" do
    sso_domains = JSON.parse(@api.get_all_ssodomains_for_all_tenants.body)
    sso_domains.each do |domain|
      response = @api.delete_ssodomain_by_ssodomainid(domain['id'])
      sleep 2
      expect(JSON.parse(response.body)).to eq("Sso Domain deleted")
    end
  end
  it "Verify no domain entries are still available" do
    sso_domains = JSON.parse(@api.get_all_ssodomains_for_all_tenants.body)
    expect(sso_domains.size).to eq(0)
  end
end