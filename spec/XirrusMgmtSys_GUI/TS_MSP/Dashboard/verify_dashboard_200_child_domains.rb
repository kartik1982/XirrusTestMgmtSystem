require_relative "../msp_examples.rb"

describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do

	include_examples "scope to tenant", "Delete_THOMAS_Test_Parent_200"

	domain_name = "Delete_THOMAS_Test_Child_1481832312780_0"
	include_examples "verify dashboard search", true, domain_name, false
	include_examples "verify loading not present"
	include_examples "verify dashboard search", false, "DDD", true
	include_examples "verify loading not present"

	domain_name = "Delete_THOMAS_Test_Child_1481832427533_95"
	include_examples "verify dashboard search", false, domain_name, false
	include_examples "verify loading not present"

	include_examples "scope to tenant", "Adrian-Automation-Chrome"

end


