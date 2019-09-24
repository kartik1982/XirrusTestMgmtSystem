require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/network_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###########################################################################################
##############TEST CASE: DHCP Pool profile network settings###############################
###########################################################################################
describe "****TEST CASE: DHCP Pool profile network settings********************" do

  profile_name = "Network Settings Test Profile - " + UTIL.ickey_shuffle(5)
  ssid_name = "Test SSID"

  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "add profile ssid", profile_name, ssid_name
  include_examples "dhcp pool with single ssid", profile_name, ssid_name
end