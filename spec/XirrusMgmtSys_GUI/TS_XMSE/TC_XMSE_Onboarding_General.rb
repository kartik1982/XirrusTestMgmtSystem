require_relative "local_lib/xmse_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
#####################################################################################################################
##############TEST CASE: XMS ENTERPRISE - PORTAL - ONBOARDING - GENERAL TAB FEATURES#################################
#####################################################################################################################
describe "********** TEST CASE: XMS ENTERPRISE - PORTAL - ONBOARDING - GENERAL TAB FEATURES **********" do

  portal_name = "ONBOARDING - General - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "onboarding"
  landing_page = "https://www.google.co.uk"
  sponsor = "test@test.com"
  login_domain = ""
  max_devices = ["6"]
  whitelist_element = "*.test.com"
  sponsor_type = nil
  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "portal general configurations", portal_name, decription_prefix, portal_type, landing_page, sponsor, sponsor_type, login_domain, max_devices, whitelist_element

end