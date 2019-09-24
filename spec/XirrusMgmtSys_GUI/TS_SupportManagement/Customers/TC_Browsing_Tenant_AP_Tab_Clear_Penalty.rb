require_relative "../local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB - CLEAR PENALTY#####################
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - ACCESS POINTS TAB - CLEAR PENALTY **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation-Chrome", 6
	include_examples "verify acces points grid on customers dashboad view clear penalty on ap", "AUTOXR520CHROME013FIRST"
	include_examples "verify acces points grid on customers dashboad view clear penalty several aps", "AUTOXR320CHROME002FIRST", "AUTOX2120CHROME007FIRST"
	include_examples "verify go back from browsing tenant view"
end