require_relative "local_lib/helplinks_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
#############################################################################################
##############TEST CASE: Test the HELP LINKS - PROFILE CONFIGURATIONS AREA - PAGES###########
#############################################################################################
describe "********** TEST CASE: Test the HELP LINKS - PROFILE CONFIGURATIONS AREA - PAGES **********" do
	profile_name = UTIL.random_title.downcase + " - Help Links test profile"
	decription_prefix = "profile description for " + profile_name
	include_examples "create profile from header menu", profile_name, decription_prefix + profile_name, false
  	include_examples "test profiles tab links", profile_name
end