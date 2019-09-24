require_relative "../../environment_variables_library.rb"
require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################################################
##################TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - ASSIGN TO CUSTOMER AND BACK###################
#######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - ASSIGN TO CUSTOMER AND BACK **********" do
	ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "supportManagement/access_points/", "")
	include_examples "go to support management"
    include_examples "search for an ap and assign it to customer", ap_sn, "Adrian-Automation-Edge"
    include_examples "search for an ap and assign it to customer", ap_sn, "Adrian-Automation-Chrome"
end