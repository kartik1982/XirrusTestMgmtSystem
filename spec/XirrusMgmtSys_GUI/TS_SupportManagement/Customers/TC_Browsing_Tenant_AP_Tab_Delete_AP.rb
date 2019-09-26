require_relative "../local_lib/support_management_lib.rb"

##########################################################################################################################
####################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB####################
##########################################################################################################################
tenant_name = "Adrian-Automation"
tenant_id =nil
tenant_body={}
array={}
api_serial = "AUTODELETEAP01"
describe "NG API CLIENT" do

  before :all do
    tenant_body = JSON.parse(@api.get_tenant_by_name(tenant_name).body)['data'].first
    tenant_id = tenant_body['id']
  end

  it "Add Array" do
    log(@array.serial)
    array = @array.ng_format
    response = @api.post_add_arrays_to_tenant(tenant_id, array)
    log(response.body)
    expect([200,201]).to include(response.code)
  end
end

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "verify acces points grid on customers dashboad view delete from grid", api_serial
end

describe "NG API CLIENT" do

  it "Add Array" do
    log(@array.serial)
    array = @array.ng_format
    response = @api.post_add_arrays_to_tenant(tenant_id, array)
    log(response.body)
    expect([200,201]).to include(response.code)
  end
end

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "verify acces points grid on customers dashboad view delete from button", api_serial
end