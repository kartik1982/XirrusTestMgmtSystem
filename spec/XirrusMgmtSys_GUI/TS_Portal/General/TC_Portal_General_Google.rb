require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
#######################################################################################
#################TEST CASE: PORTAL - GOOGLE LOGIN - GENERAL TAB FEATURES#############
#######################################################################################
describe "********** TEST CASE: PORTAL - GOOGLE LOGIN - GENERAL TAB FEATURES **********" do

  portal_name = "GOOGLE LOGIN - General - " + UTIL.ickey_shuffle(5)
  decription_prefix = "Portal description for: "
  portal_type = "google"
  landing_page = "https://www.google.so"
  sponsor = "test@test.com"
  login_domain = "test.com"
  max_devices = ["1", "2", "3", "4"]
  whitelist_element = "*.test.co.uk"
  sponsor_type = nil

  include_examples "create portal from header menu", portal_name, decription_prefix + portal_name, portal_type
  include_examples "portal general configurations", portal_name, decription_prefix, portal_type, landing_page, sponsor, sponsor_type, login_domain, max_devices, whitelist_element

  max_devices = ["1000"]
  include_examples "update portal maximum device registration", portal_name, portal_type, max_devices

end