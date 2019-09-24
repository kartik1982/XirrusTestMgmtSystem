require_relative "../local_lib/support_management_lib.rb"
######################################################################################################################################
################TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - GRID VERIFICATIONS - AP TAB###########################
######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - BROWSING TENANT - GRID VERIFICATIONS - AP TAB **********" do
	include_examples "go to support management"
	include_examples "open a customers dashboard view", "Adrian-Automation-Chrome", 6

	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Serial Number"
	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Status"
	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Online"
	include_examples "verify column does not support sorting", "Access Points - Browsing tenant", "First Activation"
	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Last Configured Time"
	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Licensed AOS"
	include_examples "verify descending ascending sorting firmware", "Access Points - Browsing tenant", "Reported AOS Version"
	include_examples "verify go back from browsing tenant view"
end