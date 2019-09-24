require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
#################################################################################################################
############TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - COLUMNS SORTING############################
#################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - COLUMNS SORTING **********" do

	include_examples "go to mynetwork access points tab"
	include_examples "restore view to default", "Access Points"
	include_examples "verify sorting"

end