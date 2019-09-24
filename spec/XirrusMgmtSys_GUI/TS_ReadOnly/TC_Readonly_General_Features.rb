require_relative "./local_lib/readonly_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - READ-ONLY user account - GENERAL FEATURES#######################
################################################################################################################

describe "********** TEST CASE: Test the application - READ-ONLY user account - GENERAL FEATURES **********" do

	include_examples "scope to tenant", "Adrian-ReadOnly-Tenant"
	include_examples "main readonly warning bar", false

end