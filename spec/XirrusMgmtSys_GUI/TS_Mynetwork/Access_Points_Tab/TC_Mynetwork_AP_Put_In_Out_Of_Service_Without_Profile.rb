require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
###########################################################################################################################################################
#################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN / OUT OF SERVICE - NOT ASSIGNED TO A PROFILE##############
###########################################################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - PUT IN / OUT OF SERVICE - NOT ASSIGNED TO A PROFILE **********" do

	include_examples "delete all profiles from the grid"
	include_examples "go to mynetwork access points tab"
	include_examples "reset grid to default view", "My Network - Access Points tab", ""
	include_examples "put in out of service first array in grid"
	include_examples "put in out of service first array in grid"

end