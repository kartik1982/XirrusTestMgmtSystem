require_relative "../local_lib/readonly_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - PROFILES AREA############
################################################################################################################
describe "********** TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - PROFILES AREA **********" do

	profile_name = "Profile - Read Only user testing"

	include_examples "scope to tenant", "Adrian-Automation-Chrome"
	include_examples "verify readonly function does not allow the user to perform changes in the application msp profiles", profile_name

end