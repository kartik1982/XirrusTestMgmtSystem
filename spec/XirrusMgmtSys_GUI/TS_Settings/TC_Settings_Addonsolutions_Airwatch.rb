require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
######################################################################################################################
#####################TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - AIRWATCH############################
######################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - ADD-ON SOLUTIONS TAB - AIRWATCH **********" do

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", "profile", "Profile description", false
  #include_examples "create profile direct", "profile"
  include_examples "add profile ssid", "profile", "ssid"

  include_examples "test add-on solutions settings", 'www.airwatchmdm.gov', "3356744821", "test_user", "password"
  include_examples "configure ssid for airwatch", "profile"
  include_examples "test add-on solutions settings", "", "", "", ""
  include_examples "confirm ssid is not airwatch", "profile"

  include_examples "delete profile ssids", "profile"

end