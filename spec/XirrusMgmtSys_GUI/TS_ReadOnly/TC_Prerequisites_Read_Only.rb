require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
################################################################################################################
##############TEST CASE: Test the application using a READ-ONLY user account####################################
################################################################################################################
describe "TEST CASE: Test the application using a READ-ONLY user account" do
	
	profile_name = "Profile - Read Only user testing"
	portal_name = "Self-Registration ReadOnly Test Portal"

	include_examples "scope to tenant", "Adrian-ReadOnly-Tenant"
	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "create portal from header menu", portal_name, "", "self_reg"

end