require_relative "./local_lib/ap_lib.rb"
require_relative "./local_lib/profile_lib.rb"
require_relative "./local_lib/ssids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
#########################################################################################
##############TEST CASE: Test Profile Access Points####################################
#########################################################################################
describe "*****************TEST CASE: Test Profile Access Points************" do

  profile_name = UTIL.random_profile_name + " - Access Points tab test"

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, "Profile description: " + profile_name, false
  include_examples "add profile ssid", profile_name, "Adrian D ap.rb TEST"
  include_examples "add all access points to profile", profile_name
  include_examples "test profile access point list", profile_name, 'Auto-XR520-1', 11, false
  include_examples "unasign access points from profile", profile_name

end