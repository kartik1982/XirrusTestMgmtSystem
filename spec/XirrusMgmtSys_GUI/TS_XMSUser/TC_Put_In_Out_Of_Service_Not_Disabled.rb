require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"

######################################################################################################################################################
##############TEST CASE: Test the MY Network and Profile areas - XMS USER - Verify that the 'Put In / Out of service' function is disabled############
######################################################################################################################################################
describe "********** TEST CASE: Test the MY Network and Profile areas - XMS USER - Verify that the 'Put In / Out of service' function is disabled **********" do

  test_name = "Put IN / OUT of Service an AP"

  include_examples "delete all profiles from the grid"
  include_examples "create profile from tile", test_name, "TEST PROFILE - Created to verify the Put IN/OUT of service an AP", false
  include_examples "go to mynetwork access points tab"
  include_examples "verify put in out of service disbaled false", "My Network - Access Points tab", ""
  include_examples "assign first access point to profile", test_name
  include_examples "reset grid to default view", "Profile - Access Points tab", test_name
  include_examples "verify put in out of service disbaled false", "Profile - Access Points tab", test_name
end