require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/optimize_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
#####################################################################################
############TEST CASE: PROFILE - OPTIMIZATIONS TAB - OPTIMIZATIONS areas############
#####################################################################################
describe "********** TEST CASE: PROFILE - OPTIMIZATIONS TAB - OPTIMIZATIONS areas **********" do

  profile_name = "Profile for OPTIMIZATIONS testing " + UTIL.ickey_shuffle(3)

  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "update profile optimize settings", profile_name

end

describe "********** TEST CASE: PROFILE - OPTIMIZATIONS TAB - MULTICAST OPTIMIZATIONS area (US4821) **********" do

  profile_name = "Profile for OPTIMIZATIONS testing " + UTIL.ickey_shuffle(3)

  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "optimizations multicast isolation", profile_name

end