require_relative "./local_lib/readonly_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
################################################################################################################
##############TEST CASE: Test the application - READ-ONLY user account - PORTALS AREA###########################
################################################################################################################

describe "********** TEST CASE: Test the application - READ-ONLY user account - PORTALS AREA **********" do

	portal_name = "Self-Registration ReadOnly Test Portal"

	include_examples "scope to tenant", "Adrian-ReadOnly-Tenant"
	include_examples "verify readonly function does not allow the user to perform changes in the application portals", portal_name

end