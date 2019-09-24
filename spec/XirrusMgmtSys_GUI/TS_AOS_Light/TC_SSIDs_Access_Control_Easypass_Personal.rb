require_relative "../TS_Portal/local_lib/portal_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
require_relative "../TS_Profile/local_lib/ap_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
###########################################################################################################################################
##############TEST CASE: AOS LIGHT - PROFILE - SSIDs TAB - ACCESS CONTROL - Use EASYPASS PORTALS - PERSONAL Wi-Fi##########################
###########################################################################################################################################
describe "********** TEST CASE: AOS LIGHT - PROFILE - SSIDs TAB - ACCESS CONTROL - Use EASYPASS PORTALS - PERSONAL Wi-Fi **********" do

  profile_name = UTIL.random_profile_name
  decription = UTIL.chars_255.upcase
  portal_from_header_name = "PORTAL FOR EASY PASS PROFILE WITH AOS LIGHT" + " - header menu"
  decription_prefix = "portal description for "

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, decription, false
  include_examples "add profile ssid", profile_name, 'SSID test of AOS Light Profile'

  include_examples "edit an ssid and change access control to captive portal personal wifi for aos light profile", profile_name, portal_from_header_name + " personal", "personal"
  include_examples "add access point to profile certain model" , profile_name, "X2-120", "XR320", true
  include_examples "verify ssid on aos light profile has captive portal personal wifi", profile_name, portal_from_header_name + " personal", decription_prefix + portal_from_header_name

  include_examples "edit an ssid and change access control to none", profile_name
  include_examples "delete profile ssids", profile_name

end