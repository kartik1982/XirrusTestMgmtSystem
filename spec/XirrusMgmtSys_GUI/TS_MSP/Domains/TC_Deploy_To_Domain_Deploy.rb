require_relative "../local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/policies_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
##################################################################################################
############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB############################
##################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do
	profile_name = "Profile to be deployed - From One Domain to Another"
	include_examples "go to commandcenter"
	include_examples "create Domain", "Deploy profiles to this domain 3"
	include_examples "deploy profile to a domain from profiles landing page - using as default", profile_name, "Deploy profiles to this domain 3"
end