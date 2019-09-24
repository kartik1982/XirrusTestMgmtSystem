require_relative "local_lib/xmse_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#####################################################################################################################
##############TEST CASE: XMS ENTERPRISE - PORTAL - ONBOARDING - LOOK & FEEL TAB FEATURES#############################
#####################################################################################################################
describe "********** TEST CASE: XMS ENTERPRISE - PORTAL - ONBOARDING - LOOK & FEEL TAB FEATURES  **********" do

  portal_name =  "ONBOARDING - " + UTIL.ickey_shuffle(5)
  portal_description = "Portal description for: "
  portal_type = "onboarding"
  company_name = "TEST COMPANY"

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type

  include_examples "go to portal look feel tab", portal_name
  include_examples "update portal look & feel", portal_name, portal_type, company_name

end