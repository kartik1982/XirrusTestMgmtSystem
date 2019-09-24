require_relative "../local_lib/support_management_lib.rb"

##########################################################################################################################
####################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB####################
##########################################################################################################################
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

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "verify acces points grid on customers dashboad view delete from grid", "AUTODELETEAP01"
end

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

describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation", 10
	include_examples "verify acces points grid on customers dashboad view delete from button", "AUTODELETEAP01"
end