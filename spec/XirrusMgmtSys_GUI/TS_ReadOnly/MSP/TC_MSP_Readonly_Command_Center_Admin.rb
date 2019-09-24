require_relative "../local_lib/readonly_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - MY NETWORK AREA##########
################################################################################################################
describe "********** TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - MY NETWORK AREA **********" do

	profile_name = "Profile - Read Only user testing"
	include_examples "scope to tenant", "Adrian-Automation-Chrome"
	include_examples "verify command center admin area readonly", profile_name

end