require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - CREATE CERTAIN TENANT FOR READ-ONLY#####################
################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - CREATE CERTAIN TENANT FOR READ-ONLY **********" do

	profile_name = "Profile - Read Only user testing"
	portal_name = "Self-Registration ReadOnly Test Portal"

  include_examples "delete all profiles from the grid"
	include_examples "delete portal from tile", portal_name
	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "create portal from header menu", portal_name, "", "self_reg"

	include_examples "go to commandcenter"
	include_examples "create Domain", "Adrian-ReadOnly-Tenant"
	include_examples "assign and Unassign several arrays to a domain", "Adrian-ReadOnly-Tenant", "Assign"


end