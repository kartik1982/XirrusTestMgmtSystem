require_relative "local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
#########################################################################################################
##############TEST CASE: Test the Profiles area - DUPLICATE EXISTING PROFILES############################
#########################################################################################################
describe "********** TEST CASE: Test the Profiles area - DUPLICATE EXISTING PROFILES **********" do
  profile_name = "Profile for duplication - " + UTIL.ickey_shuffle(5)
  profile_name_read_only = "Read-Only profile for duplication - " + UTIL.ickey_shuffle(5)
  decription = "Profile description for " + profile_name

  include_examples "create profile from header menu", profile_name, decription
  include_examples "duplicate profile from profile menu", profile_name, decription
  include_examples "create read-only profile from header menu", profile_name_read_only, decription, true
  include_examples "duplicate read-only profile tile", profile_name_read_only, decription
  include_examples "delete profile tile", profile_name_read_only
  include_examples "delete profile tile", "Copy of " + profile_name_read_only
end