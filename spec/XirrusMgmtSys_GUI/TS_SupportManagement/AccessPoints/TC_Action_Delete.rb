require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - DELETE##########
#######################################################################################################
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

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - DELETE **********" do

	include_examples "go to support management"
    include_examples "search for an ap and perform an action", api_serial, "Delete"
end