require_relative "local_lib/xmse_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#####################################################################################################################
##############Test Case: Test the XMS - Enterprise functionality - Create Portal, Add Guests, Delete Portal##########
#####################################################################################################################
describe "Test Case: Test the XMS - Enterprise functionality - Create Portal, Add Guests, Delete Portal" do

  portal_types = ["self_reg","ambassador","onetouch","onboarding","voucher","personal","google"]
  portal_types.each { |portal_type|
  portal_from_tile_name = UTIL.random_title.downcase + " - tile - " + portal_type
  decription_prefix = "portal description for "
  portal_name = "PORTAL"

  include_examples "create portal from new portal button", portal_from_tile_name, decription_prefix + portal_from_tile_name, portal_type
  include_examples "add, count & delete guests", portal_from_tile_name, portal_type, 2
  include_examples "delete portal from tile", portal_from_tile_name
  }
end