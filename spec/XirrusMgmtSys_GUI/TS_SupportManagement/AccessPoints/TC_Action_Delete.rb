require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - DELETE##########
#######################################################################################################
tenant_name = "Adrian-Automation"

describe "NG API CLIENT" do

  before :all do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
    @current_ng_tenant =  @ng.current_tenant.body
    @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
    puts "Needed tenant ID: #{@get_tenant_by_name.to_s[18..53]}"
    @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
  end

  it "Add Array" do

    log(@array.serial)
    ar = @array.ng_format
    puts ar
    add_res = @ng.add_arrays_to_tenant(@needed_tenent_id, ar)
    puts add_res
    log(add_res.body)
    expect([200,201]).to include(add_res.code)

  end
end

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - DELETE **********" do

	include_examples "go to support management"
    include_examples "search for an ap and perform an action", "AUTODELETEAP01", "Delete"
end