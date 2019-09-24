require_relative "../local_lib/readonly_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - GENERAL FEATURES##########
################################################################################################################
describe "********** TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - GENERAL FEATURES **********" do

	include_examples "scope to tenant", "Adrian-Automation-Chrome"
	include_examples "main readonly warning bar", true

end