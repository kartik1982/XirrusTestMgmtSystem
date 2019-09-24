require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
#############################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - ACCESS CONTROL - Use an internal image################
#############################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - ACCESS CONTROL - Use an internal image **********" do
  
  profile_name = UTIL.random_profile_name + "- internal image"
  profile_description = UTIL.chars_255.upcase
  
  include_examples "create profile from header menu", profile_name, profile_description, false
  include_examples "add profile ssid", profile_name, 'ssid'
  include_examples "edit an ssid and add an internal image on the splash page", profile_name
  include_examples "delete profile ssids", profile_name
  include_examples "delete profile from tile", profile_name

end