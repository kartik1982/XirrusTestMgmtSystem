require_relative "msp_lib.rb"
require_relative "../profiles/profiles_lib.rb"
require_relative "../profile/profile_lib.rb"
require_relative "../profile/config/ssids_lib.rb"
require_relative "../profile/config/policies_lib.rb"
require_relative "../profile/profile_lib.rb"


describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do
	profile_name = "Profile to be deployed - " + UTIL.ickey_shuffle(3)
	include_examples "delete all profiles from the grid"
	include_examples "go to commandcenter"
	include_examples "create Domain", "Deploy profiles to this domain 1" 
	include_examples "create Domain", "Deploy profiles to this domain 2" 
	include_examples "create profile from header menu", profile_name, "Description text for profile to be deployed", false
	include_examples "deploy profile to a domain from profiles landing page - verify the deploy modal", profile_name, "Deploy profiles to this domain 1" 
	include_examples "deploy profile to a domain from inside profile - verify the deploy modal", profile_name, "Deploy profiles to this domain 2" 
	include_examples "perform changes on all tabs of a profile in order to verify the deploy to child domain", profile_name
	include_examples "go to commandcenter"
	include_examples "create Domain", "Deploy profiles to this domain 3" 
	include_examples "deploy profile to a domain from profiles landing page - using as default", profile_name, "Deploy profiles to this domain 3" 
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