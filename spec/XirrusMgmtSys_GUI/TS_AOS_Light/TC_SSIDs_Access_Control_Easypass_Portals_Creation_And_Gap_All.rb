require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
require_relative "../TS_Profile/local_lib/ap_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
###########################################################################################################################################
##############TEST CASE: AOS LIGHT - PROFILE - SSIDs TAB - ACCESS CONTROL - CREATE EASYPASS PORTALS (ALL TYPES) assign GAP ALL#############
###########################################################################################################################################
describe "********** TEST CASE: AOS LIGHT - PROFILE - SSIDs TAB - ACCESS CONTROL - CREATE EASYPASS PORTALS (ALL TYPES) assign GAP ALL **********" do

  profile_name = UTIL.random_profile_name
  decription = UTIL.chars_255.upcase
  portal_from_header_name = "PORTAL FOR EASY PASS PROFILE WITH AOS LIGHT" + " - header menu"
  decription_prefix = "portal description for "

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, decription, false
  include_examples "add access point to profile certain model" , profile_name, "X2-120", "XR320", true
  include_examples "add profile ssid", profile_name, 'SSID test of AOS Light Profile'

  include_examples "verify portal list view tile view toggle"

  for portal_type  in ["personal","onboarding","self_reg","google","ambassador","onetouch","voucher","azure"] do
    include_examples "create portal from header menu", portal_from_header_name + " #{portal_type}", decription_prefix + portal_from_header_name, portal_type
  end

  for portal_type in ["self_reg","google","ambassador","onetouch","personal","voucher", "azure"] do
    include_examples "edit an ssid and change access control to captive portal gap", profile_name, portal_from_header_name + " #{portal_type}", portal_type
  end

end