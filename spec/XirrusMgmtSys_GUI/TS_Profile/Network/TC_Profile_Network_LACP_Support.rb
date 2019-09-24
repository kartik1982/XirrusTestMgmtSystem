require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/network_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
#####################################################################################
#############TEST CASE: Edit profile LACP Support network settings##################
#####################################################################################
describe "********TEST CASE: Edit profile LACP Support network settings*****************" do

  profile_name = "Network Settings Test Profile - " + UTIL.ickey_shuffle(5)
  
  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Technology"

  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "update profile LACP Support network settings", profile_name

end