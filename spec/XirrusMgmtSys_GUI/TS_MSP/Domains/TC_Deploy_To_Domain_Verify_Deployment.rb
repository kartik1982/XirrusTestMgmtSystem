require_relative "../local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/policies_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
##################################################################################################
############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB###########################
##################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do
	profile_name = "Profile to be deployed - From One Domain to Another"
	include_examples "go to commandcenter"
	include_examples "manage specific domain", "Deploy profiles to this domain 3"
	include_examples "verify that a certain profile is set as default", profile_name
	include_examples "verify deployed profile has the proper configurations", profile_name
	include_examples "go to commandcenter"
	include_examples "deploy profile to a domain from profiles landing page - verify deploy duplicate error message", profile_name, "Deploy profiles to this domain 2"
	include_examples "go to commandcenter"
	include_examples "delete Domain", "Deploy profiles to this domain 1"
	include_examples "delete Domain", "Deploy profiles to this domain 2"
	include_examples "delete Domain", "Deploy profiles to this domain 3"
	include_examples "delete profile from tile", profile_name
end