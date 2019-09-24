require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
#############################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - ACCESS CONTROL - Use LOGIN PAGE HOSTED ON AP##########
#############################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - ACCESS CONTROL - Use LOGIN PAGE HOSTED ON AP **********" do

  profile_name = UTIL.random_profile_name + "- Login Pages"
  profile_description = UTIL.chars_255.upcase

  include_examples "create profile from header menu", profile_name , profile_description, false
  include_examples "add profile ssid", profile_name, 'ssid'
  include_examples "edit an ssid and change access control to captive portal login page", profile_name
  include_examples "delete profile ssids", profile_name
  include_examples "delete profile from tile", profile_name

end