require_relative "../local_lib/msp_lib.rb"
require_relative "../../environment_variables_library.rb"
#########################################################################################################################################################
#####################TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD#########################
#########################################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do
	domain_name = "CRITICAL Domain - Dashboard Testing"

	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	include_examples "create Domain", domain_name
	include_examples "verify domain on dashboard", true, domain_name, "good", "", ""
	include_examples "verify dashboard domain detailed view", "CommandCenter", domain_name, "OK", "dash_arrays", "0 APs"
	include_examples "delete Domain", domain_name

end