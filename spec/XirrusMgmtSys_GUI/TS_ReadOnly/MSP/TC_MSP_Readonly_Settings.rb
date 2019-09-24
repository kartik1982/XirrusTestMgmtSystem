require_relative "../local_lib/readonly_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - SETTINGS FEATURES########
################################################################################################################
describe "********** TEST CASE: Test the application - COMMANDCENTER READ-ONLY user account - SETTINGS FEATURES **********" do

	include_examples "scope to tenant", "Adrian-Automation-Chrome"
	include_examples "verify the settings area for readonly accounts"
	include_examples "test my account basic settings"
  	include_examples "test my account notification settings"

end