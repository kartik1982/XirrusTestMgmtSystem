require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##########################################################################################################
#################TEST CASE: PORTAL - SELF-REGISTRATION - LOOK & FEEL TAB CONFIGURATIONS##################
##########################################################################################################
describe "********** TEST CASE: PORTAL - SELF-REGISTRATION - LOOK & FEEL TAB CONFIGURATIONS **********" do

  portal_name =  "SELF-REGISTRATION - REQUIRE AUTHENTICATION - " + UTIL.ickey_shuffle(5) 
  portal_description = "Portal description for: "
  portal_type = "self_reg"
  company_name = "TEST COMPANY"

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type

  include_examples "update self reg authentication to connect", portal_name, portal_type

end