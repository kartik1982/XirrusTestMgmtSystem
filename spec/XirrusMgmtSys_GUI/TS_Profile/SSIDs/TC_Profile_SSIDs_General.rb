require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###############################################################################################
#################TEST CASE: PROFILE - CONFIG - SSIDS TAB - GENERAL FEATURES####################
###############################################################################################
describe "********** TEST CASE: PROFILE - CONFIG - SSIDS TAB - GENERAL FEATURES **********" do

	profile_name = "Profile - General Features on SSIDS tab - " + UTIL.ickey_shuffle(5)

	include_examples "create profile from header menu", profile_name, "Profile description " + profile_name, false
	include_examples "ssids grid general configurations - verify tab contents", profile_name
	
end