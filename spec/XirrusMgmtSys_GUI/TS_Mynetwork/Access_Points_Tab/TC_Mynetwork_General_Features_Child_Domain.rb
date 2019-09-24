require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
####################################################################################################
###############TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES###########
####################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - GENERAL FEATURES **********" do
	test_name = "Default view on AP grid"

	include_examples "go to commandcenter"
	include_examples "create Domain", "Default view on AP grid"
	include_examples "manage specific domain", test_name
	include_examples "verify my network all access points tab general features on new domain"
	include_examples "create profile from tile", test_name, "TEST PROFILE - Created to verify the default view on the AP grid", false
	include_examples "verify my network all access points tab general features on new profile", test_name, false
	include_examples "go to commandcenter"
	include_examples "delete Domain", test_name

end