require_relative "local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
#########################################################################################################
##############TEST CASE: Test the Profiles area - CRATE READONLY PROFILES FROM ALL POSSIBLE LOCATIONS####
#########################################################################################################
describe "********** TEST CASE: Test the Profiles area - CRATE READONLY PROFILES FROM ALL POSSIBLE LOCATIONS **********" do
  profile_name_tile = "REQADONLY - Profile from TILE - " + UTIL.ickey_shuffle(5)
  profile_name_header = "REQADONLY - Profile from HEADER BUTTON - " + UTIL.ickey_shuffle(5)
  profile_name_landing_page = "REQADONLY - Profile from LANDING PAGE BUTTON - " + UTIL.ickey_shuffle(5)
  decription = "Profile description"

  include_examples "verify profile list view tile view toggle"
  include_examples "delete all profiles from the grid"
  include_examples "create profile from tile", profile_name_tile, decription, true
  include_examples "create read-only profile from header menu", profile_name_header, decription, true
  (1..5).each do |i|
    include_examples "create profile from new profile button", profile_name_landing_page + " #{i}", decription, true
  end
  include_examples "create profile from new profile button", "REQADONLY - TEST", decription, true
  include_examples "create read-only profile from tile", "REQADONLY - Profile 1", decription, true
  include_examples "create read-only profile from new profile button", "REQADONLY - Profile 2", decription, true
  include_examples "search for profile", "REQADONLY - TEST"
  include_examples "delete all profiles from the grid"
end