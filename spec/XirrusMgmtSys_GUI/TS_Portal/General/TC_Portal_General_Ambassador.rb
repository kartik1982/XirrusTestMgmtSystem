require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
#######################################################################################
#################TEST CASE: PORTAL - AMBASSADOR - GENERAL TAB FEATURES###############
#######################################################################################
describe "********** TEST CASE: PORTAL - AMBASSADOR - GENERAL TAB FEATURES **********" do

  portal_name = "AMBASSADOR - General - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "ambassador"
  landing_page = "https://www.google.co.uk"
  sponsor = "test@test.com"
  login_domain = ""
  max_devices = ""
  whitelist_element = "*.test.com"
  sponsor_type = nil

  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "portal general configurations", portal_name, decription_prefix, portal_type, landing_page, sponsor, sponsor_type, login_domain, max_devices, whitelist_element

end