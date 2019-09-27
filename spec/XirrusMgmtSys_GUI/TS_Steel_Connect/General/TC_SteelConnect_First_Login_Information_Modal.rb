require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../local_lib/steel_connect_lib.rb"
#####################################################################################################
###############TEST CASE: STEEL CONNECT - Create a new tenant######################################
#####################################################################################################
tenant_name = "Adrian-Automation-SteelConnect-Child-Domain-for-testing-the-first-login-information-modal"
tenant_id =nil
describe "********** TEST CASE: STEEL CONNECT - Create a new tenant **********" do

  include_examples "go to commandcenter"
  include_examples "create Domain", tenant_name

end

describe "********** TEST CASE: STEEL CONNECT - Modify the tenant to be a SteelConnect one **********" do

 it "For the tenant '#{tenant_name}' set the 'scLinked' flag to true" do

    tenant_body = JSON.parse(@api.get_tenant_by_name(tenant_name).body)['data'].first
    tenant_id = tenant_body['id']
    tenant_body.update({'tenantLinks' => [{"id"=> "", "tenantId"=> "#{tenant_id}", "link"=>"STEELCONNECT", "url"=> ""}]})
    response = @api.put_update_tenant_by_tenantid(tenant_id, tenant_body)
    expect(response.code).to eq(200)
  end

end

describe "********** TEST CASE: STEEL CONNECT - GENERAL FEATURES - Verify the new login SteelConnect message **********" do

  include_examples "manage specific domain", tenant_name
  include_examples "verify steelconnect info modal"
  include_examples "go to commandcenter"
  include_examples "delete Domain", tenant_name

end