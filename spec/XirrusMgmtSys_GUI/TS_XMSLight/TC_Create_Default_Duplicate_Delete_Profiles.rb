require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "./local_lib/xmslight_lib.rb"

############################################################################################################################
##############TEST CASE: Test the PROFILES area - Create, default, duplicate and delete - XMS LIGHT#########################
############################################################################################################################

describe "********** TEST CASE: Test the PROFILES area - Create, default, duplicate and delete - XMS LIGHT **********" do

  profile_name = "Profile for duplication - " + UTIL.ickey_shuffle(5)
  profile_name_read_only = "Read-Only profile for duplication - " + UTIL.ickey_shuffle(5)

  decription = "Profile description for " + profile_name

  include_examples "verify profile list view tile view toggle"
  include_examples "delete all profiles from the grid"
  include_examples "create profile from tile", profile_name, decription, false
  include_examples "set default profile from profile menu", profile_name
  include_examples "unset default profile from profile menu", profile_name
  include_examples "duplicate profile from profile menu", profile_name, decription
  include_examples "verify max number of profiles reached"
  include_examples "delete all profiles from the grid"
  include_examples "create read-only profile from header menu", profile_name_read_only, decription, true
  include_examples "set default from profile tile", profile_name_read_only
  include_examples "unset default from profile tile", profile_name_read_only
  include_examples "duplicate read-only profile tile", profile_name_read_only, decription
  include_examples "verify max number of profiles reached"
  include_examples "delete profile tile", profile_name_read_only
  include_examples "delete profile tile", "Copy of " + profile_name_read_only

end