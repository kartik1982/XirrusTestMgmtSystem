require_relative "../local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../environment_variables_library.rb"
#######################################################################################################################################
###############TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD#############
#######################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do
	domain_name = "DASHBOARD Domain 2"

	first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "first ap")

	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	include_examples "create Domain", domain_name
	include_examples "verify domain on dashboard", true, domain_name, "good", "", ""
	include_examples "only assign array to domain", first_ap_sn, domain_name
	include_examples "manage specific domain", domain_name

	include_examples "go to mynetwork access points tab"
	include_examples "reset grid to default view", "My Network - Access Points tab", ""
	include_examples "put in out of service first array in grid"

	include_examples "go to commandcenter"
	include_examples "verify domain on dashboard", true, domain_name, "good", "", ""
	include_examples "verify dashboard domain detailed view", "CommandCenter", domain_name, "OK", "dash_arrays", "1 AP"

	include_examples "only unassign array to domain", first_ap_sn, domain_name
	include_examples "delete Domain", domain_name

end


