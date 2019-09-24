require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
##########################################################################################################################################
################TEST CASE: PROFILE - SSIDs TAB - ENCRYPTION / AUTHENTICATION - WPA2/802.1x - TKIP - ALL AUTHENTICATION MODES##############
##########################################################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - ENCRYPTION / AUTHENTICATION - WPA2/802.1x - TKIP - ALL AUTHENTICATION MODES **********" do

  profile_name = "WPA2/802.1x + " + UTIL.ickey_shuffle(4)
  decription_prefix = "profile description for "

  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "update active directory controls", ["Boss", "Admini$trator1", "dc01.xirrus.test.com", "GAMMA", "TEST"]
  include_examples "add profile ssid", profile_name, 'Active Directory'
  include_examples "add profile ssid", profile_name, 'PSK'
  include_examples "add profile ssid", profile_name, 'EAP'

            include_examples "edit profile ssid encryption/auth general method", profile_name, 'Active Directory', "WPA2/802.1x", "TKIP", "Active Directory"
            include_examples "edit profile ssid encryption/auth general method", profile_name, 'PSK', "WPA2/802.1x", "TKIP", "PSK"
            include_examples "edit profile ssid encryption/auth general method", profile_name, 'EAP', "WPA2/802.1x", "TKIP", "EAP"
end