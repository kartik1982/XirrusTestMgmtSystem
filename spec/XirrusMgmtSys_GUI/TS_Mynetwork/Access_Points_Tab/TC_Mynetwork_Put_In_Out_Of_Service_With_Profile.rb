require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
#################################################################################################################################################
#################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN / OUT OF SERVICE - ASSIGNED TO A PROFILE########
#################################################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN / OUT OF SERVICE - ASSIGNED TO A PROFILE **********" do
	test_name = "Put IN / OUT of Service an AP"

	include_examples "delete all profiles from the grid"
	include_examples "create profile from tile", test_name, "TEST PROFILE - Created to verify the default view on the AP grid", false
	include_examples "go to mynetwork access points tab"
	include_examples "reset grid to default view", "My Network - Access Points tab", ""
	include_examples "assign first access point to profile", test_name
	include_examples "put in out of service first array in grid"
	include_examples "put in out of service first array in grid"

end