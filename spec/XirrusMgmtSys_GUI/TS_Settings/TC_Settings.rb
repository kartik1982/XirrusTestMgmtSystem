require_relative "./local_lib/settings_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
######################################################################################################################
#####################TEST CASE: Test the SETTINGS area - USERS TAB - MY ACCOUNT, PROVIDER and ADD-ON SOLUTIONS tabs####
######################################################################################################################
describe "********** TEST CASE: Test the SETTINGS area - USERS TAB - MY ACCOUNT, PROVIDER and ADD-ON SOLUTIONS tabs **********" do
 

  profile_name = UTIL.random_title.downcase
  decription_prefix = "profile description for "

  include_examples "test my account basic settings"
  include_examples "test my account notification settings"
   include_examples "create profile from header menu", profile_name, decription_prefix + profile_name, false
  include_examples "add profile ssid", profile_name, "ssid"
  include_examples "test add-on solutions settings", "https://www.airwatchmdm.org", "Test1234567890!@#~kkj", "User QA Test", "Admini$trator1"
  include_examples "configure ssid for airwatch", profile_name
  include_examples "test add-on solutions settings", "", "", "", ""
  include_examples "confirm ssid is not airwatch", profile_name
  include_examples "delete profile ssids", profile_name


end