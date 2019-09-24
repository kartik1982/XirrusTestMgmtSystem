require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
############################################################################################################
################TEST CASE: SSIDs Encryptions and Authentication test #######################################
############################################################################################################
describe "******************TEST CASE: SSIDs Encryptions and Authentication test****************" do

  profile_name = UTIL.random_profile_name
  decription_prefix = "profile description for "

  include_examples "create profile from header menu", profile_name, decription_prefix + profile_name, false
  include_examples "update active directory controls", ["Boss", "Admini$trator1", "dc01.xirrus.test.com", "GAMMA", "TEST"]
  include_examples "add profile ssid", profile_name, 'ssid'
  include_examples "edit profile ssid", profile_name
  include_examples "edit profile ssid encryption/auth - WEP/Open", profile_name
  include_examples "edit profile ssid encryption/auth - WPA2/802.1x PSK", profile_name
  include_examples "edit profile ssid encryption/auth - WPA2/802.1x EAP", profile_name
  include_examples "edit profile ssid encryption/auth - WPA & WPA2/802.1x TKIP PSK", profile_name
  include_examples "edit profile ssid encryption/auth - WPA/802.1x AES & TKIP AD", profile_name
  include_examples "edit profile ssid encryption/auth - None/RADIUS MAC", profile_name

end