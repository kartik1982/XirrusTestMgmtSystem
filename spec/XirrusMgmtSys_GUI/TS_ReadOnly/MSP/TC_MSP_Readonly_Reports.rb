require_relative "../local_lib/readonly_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - REPORTS AREA#############
################################################################################################################
describe "********** TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - REPORTS AREA **********" do

	include_examples "scope to tenant", "Adrian-ReadOnly-Tenant"
	include_examples "verify readonly function does not allow the user to perform changes in the application reports"
	include_examples "scope to tenant", "Adrian-Automation-Chrome"

end