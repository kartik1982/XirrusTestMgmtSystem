require_relative "../local_lib/msp_lib.rb"
require_relative "../../environment_variables_library.rb"
#########################################################################################################################################################
#####################TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD#########################
#########################################################################################################################################################

describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do

	include_examples "go to commandcenter"
	include_examples "ceanup on environment", return_proper_value_based_on_the_used_environment($the_environment_used, "msp/dashboard/", "delete tenants array"), "Dinte"
	["A", "B", "C", "D"].each do |letter|
		include_examples "create Domain", letter
	end
	include_examples "verify dashboard sort", true, Hash[1 => "A", 2 => "B", 3 => "C", 4 => "D"]

	["A", "B", "C", "D"].each do |letter|
		include_examples "verify domain on dashboard", false, letter, "good", "", ""
	end
	["A", "B", "C", "D"].each do |letter|
		include_examples "delete Domain", letter
	end
end