require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../local_lib/steel_connect_lib.rb"
#####################################################################################################
###############TEST CASE: STEEL CONNECT - Create a new tenant######################################
#####################################################################################################
tenant_name = "Adrian-Automation-SteelConnect-Child-Domain-for-testing-the-first-login-information-modal"

describe "********** TEST CASE: STEEL CONNECT - Create a new tenant **********" do

  include_examples "go to commandcenter"
  include_examples "create Domain", tenant_name

end

describe "********** TEST CASE: STEEL CONNECT - Modify the tenant to be a SteelConnect one **********" do

 it "For the tenant '#{tenant_name}' set the 'scLinked' flag to true" do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
    @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
    puts "Needed tenant ID: #{@get_tenant_by_name.to_s[18..53]}"
    @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
    @get_tenant_by_name["data"][0]['tenantLinks']=[{"id"=> "", "tenantId"=> "#{@needed_tenent_id}", "link"=>"STEELCONNECT", "url"=> ""}]
    @update_tenant = @ng.update_tenant2(@needed_tenent_id, @get_tenant_by_name["data"][0])
    expect(@update_tenant.code).to eq(200)
  end

end

describe "********** TEST CASE: STEEL CONNECT - GENERAL FEATURES - Verify the new login SteelConnect message **********" do

  include_examples "manage specific domain", tenant_name
  include_examples "verify steelconnect info modal"
  include_examples "go to commandcenter"
  include_examples "delete Domain", tenant_name

end