require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
########################################################
#################TEST CASE: Test Eircom Profiles########
########################################################
describe "TEST CASE: Test Eircom Profiles" do

  include_examples "verify profile list view tile view toggle"
  include_examples "delete all profiles from the grid"

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create profile from tile", profile_name + " from TILE", profile_description

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create profile from header menu", profile_name + " from HEADER", profile_description

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create profile from new profile button", profile_name + " from BUTTON", profile_description
  include_examples "delete profile from tile", profile_name + " from BUTTON"

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create read-only profile from header menu", profile_name + " from HEADER", profile_description, true
  include_examples "duplicate read-only profile tile", profile_name + " from HEADER", profile_description
  include_examples "delete profile from tile", profile_name + " from HEADER"
  include_examples "delete profile from tile", "Copy of " + profile_name + " from HEADER"

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create profile from header menu", profile_name + " from HEADER", profile_description
  include_examples "duplicate profile from profile menu", profile_name + " from HEADER", profile_description
  include_examples "set default profile from profile menu", profile_name + " from HEADER"
  include_examples "unset default profile from profile menu", profile_name + " from HEADER"
  include_examples "delete profile from tile", profile_name + " from HEADER"
  include_examples "delete profile from tile", "Copy of " + profile_name + " from HEADER"

  include_examples "delete all profiles from the grid"
  profile_name = UTIL.random_profile_name
  profile_description = UTIL.chars_255.upcase
  include_examples "create profile from tile", profile_name + " from TILE", profile_description
  include_examples "set default from profile tile", profile_name + " from TILE"
  include_examples "unset default from profile tile", profile_name + " from TILE"
  include_examples "search for profile", profile_name + " from TILE"
  include_examples "delete profile from profile menu", profile_name + " from TILE"

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create profile from header menu", profile_name + " from HEADER", profile_description
  include_examples "delete profile tile", profile_name + " from HEADER"

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create read-only profile from tile", profile_name + " from TILE", profile_description, true

  profile_name = UTIL.random_profile_name
    profile_description = UTIL.chars_255.upcase
  include_examples "create read-only profile from new profile button", profile_name + " from BUTTON", profile_description, true

end