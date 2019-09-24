require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/network_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
##############################################################################
############TEST CASE: Edit profile network settings##########################
##############################################################################
describe "**************TEST CASE: Edit profile network settings**************" do

  profile_name = "Network Settings Test Profile - " + UTIL.ickey_shuffle(5)

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "update profile network settings", profile_name

end