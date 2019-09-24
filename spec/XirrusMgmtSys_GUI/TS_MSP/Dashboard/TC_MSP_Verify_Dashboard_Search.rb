require_relative "../local_lib/msp_lib.rb"
require_relative "../../environment_variables_library.rb"
#########################################################################################################################################################
#####################TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD########################
#########################################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do

	first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "first ap")

	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	["A - Domain", "B - Domain", "C - Domain"].each do |domain_name|
		include_examples "create Domain", domain_name
	end
	include_examples "only assign array to domain", first_ap_sn, "B - Domain"

	include_examples "verify dashboard search", true, "B - Domain", false
	include_examples "verify dashboard search", false, "DDD", true
	include_examples "verify dashboard search", false, "A - Domain", false


	include_examples "only unassign array to domain", first_ap_sn, "B - Domain"

	["A - Domain", "B - Domain", "C - Domain"].each do |domain_name|
		include_examples "delete Domain", domain_name
	end

end


