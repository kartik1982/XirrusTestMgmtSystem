require_relative "../local_lib/msp_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../environment_variables_library.rb"
#######################################################################################################################################
###############TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD############
#######################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do
	domain_name = "DASHBOARD Domains Sorting "

	first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "first ap")
	second_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "second ap")


	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	["AAA", "BBB", "CCC", "DDD", "EEE"].each do |letters|
		include_examples "create Domain", letters
	end
	include_examples "verify certain ap is not out of service", first_ap_sn
	include_examples "only assign array to domain", first_ap_sn, "DDD"
	include_examples "verify domain on dashboard", true, "DDD", "warning", "reason0", "Site Down"
	include_examples "verify dashboard domain position", true, "DDD", 1

	include_examples "verify certain ap is not out of service", second_ap_sn
	include_examples "only assign array to domain", second_ap_sn, "BBB"
	include_examples "verify domain on dashboard", true, "BBB", "warning", "reason0", "Site Down"
	include_examples "verify dashboard domain position", false, "BBB", 1
	include_examples "verify dashboard domain position", false, "DDD", 2

	["AAA", "CCC", "EEE"].each do |letter|
		include_examples "verify domain on dashboard", false, letter, "good", "", ""
	end
	include_examples "only unassign array to domain", first_ap_sn, "DDD"
	include_examples "only unassign array to domain", second_ap_sn, "BBB"
	["AAA", "BBB", "CCC", "DDD", "EEE"].each do |letters|
		include_examples "delete Domain", letters
	end

end


