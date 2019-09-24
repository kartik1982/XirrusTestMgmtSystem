require_relative '../../api_client/context.rb'
require_relative '../../api_client/examples.rb'

tenant_name = "Adrian-Automation-Avaya-Chrome-SELF-OWNED"
circle_id = "00000000-0000-0000-0000-000000000000"
base_tenant_object = {name: nil, erpId: nil, products: ["XMS"], circleId: circle_id, shardId: "XMS_SHARD_1"}
parent_name = "Adrian-Automation-Avaya-Chrome"
parent_id = "7d133c71-228b-11e6-9973-06f40aa1df45"
tenant_ownership = "SELF"
brand = "AVAYA"
products = ["XMS"]
shard_id = "XMS_SHARD_1"

describe "ADD TENANT USING API" do
  before :all do
    @ng = XMS::NG::ApiClient.new(token: @token)
  end

  it "Add Tenant" do
    @ng.delete_tenant_if_name_or_erp_exists(tenant_name)
    tenant_to_make = base_tenant_object.merge({name: tenant_name, erpId: tenant_name, brand: brand, parentName: parent_name, parentId: parent_id, tenantOwnership: tenant_ownership})
    make_tenant = @ng.new_tenant(tenant_to_make)
    expect(make_tenant.code).to eql(200)
  end
end

require_relative '../../arrays/context.rb'
require_relative '../../arrays/examples.rb'

describe "NG API CLIENT" do

  include_context "arrays"

  before :all do
    @ng = XMS::NG::ApiClient.new(token: @token)
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

  #it "Add Array" do
  #
  #  @array.serial = serial_two

  #  log(@array.serial)
  #  ar = @array.ng_format
  #  add_res = @ng.add_arrays_to_tenant(@needed_tenent_id, ar)
  #  log(add_res.body)
  #  expect([200,201]).to include(add_res.code)

  #end
end

require_relative "msp_examples.rb"
require_relative "../settings/settings_examples.rb"
require_relative "../mynetwork/access_points_tab/ap_examples.rb"

describe "********** TEST CASE: Test the COMMANDCENTER area - NON-MSP OWNED EQUIPMENT **********"  do

  include_examples "change to tenant", tenant_name, 1

  include_examples "go to settings then to tab", "User Accounts"
  include_examples "verify domain and managed by strings", tenant_name, parent_name

  include_examples "change to tenant", parent_name, 2

  include_examples "verify non msp owned equipment access points tab", tenant_name

  include_examples "change to tenant", tenant_name, 1

end

describe "DELETE ARRAYS USING API" do

  include_context "arrays"

  before :all do
    @ng = XMS::NG::ApiClient.new(token: @token)
  end

#  serial = 'AUTOFAKEAPAD001'

  it "Delete Array" do
    puts @array.serial
    array_res = @ng.global_by_serial(@array.serial)
    log(array_res)
    id = array_res.body["xirrusArrayDto"]["id"]
    puts "ID : #{id}"
    #del_res = @ng.delete_array({arrayId: id})
    del_res = @ng.delete_array_global({arrayId: id})
    puts del_res
    expect(del_res.code).to eql(200)
    expect(del_res.body).to eql("\"Array deleted\"")
  end

#  serial = 'AUTOWAP9132AVAYASELF02'
#
#  it "Delete Array" do
#    array_res = @ng.array_by_serial(@array.serial)
#    log(array_res)
#    id = array_res.body["id"]
#    puts "ID : #{id}"
#    del_res = @ng.delete_array(id)
#    expect(del_res.code).to eql(200)
#    expect(del_res.body).to eql("\"Array deleted\"")
#  end

end
