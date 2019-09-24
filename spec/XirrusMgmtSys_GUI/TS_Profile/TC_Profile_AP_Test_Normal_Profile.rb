require_relative "./local_lib/ap_lib.rb"
require_relative "./local_lib/profile_lib.rb"
require_relative "./local_lib/ssids_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
#########################################################################################
##############TEST CASE: Profile Access Point Normal Profile Test########################
#########################################################################################
describe "************TEST CASE: Profile Access Point Normal Profile Test**************" do

  profile_name = UTIL.random_profile_name + " - Access Points tab test"

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, "Profile description: " + profile_name, false
  include_examples "add profile ssid", profile_name, "Adrian D ap.rb TEST"
  include_examples "add access point to profile", profile_name, "Auto-XR620-1"

  include_examples "test profile access point general tab", profile_name, "Auto-XR620-1", "BBBBCCDD002B"
  include_examples "unasign access points from profile", profile_name

  include_examples "add access point to profile", profile_name, "Auto-XR320-1"
  include_examples "verify xr320 warnings", profile_name, "Auto-XR320-1"
  include_examples "configure xr320 profile config", profile_name
  include_examples "unasign access points from profile", profile_name

end