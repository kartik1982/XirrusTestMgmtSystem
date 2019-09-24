require_relative "../local_lib/msp_lib.rb"
require_relative "../../environment_variables_library.rb"
#########################################################################################################################################################
#####################TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD########################
#########################################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do
	domain_name = "DASHBOARD Domains Sorting "

	first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "first ap")
	second_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "second ap")

	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	["A", "B"].each do |letter|
		include_examples "create Domain", letter
	end
	include_examples "only assign array to domain", first_ap_sn, "A"
	include_examples "verify dashboard tab notification", "1"
	include_examples "only assign array to domain", second_ap_sn, "B"
	include_examples "verify dashboard tab notification", "2"
	include_examples "only unassign array to domain", first_ap_sn, "A"
	include_examples "only unassign array to domain", second_ap_sn, "B"
	["A", "B"].each do |letter|
		include_examples "delete Domain", letter
	end

end


