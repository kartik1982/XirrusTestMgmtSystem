require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###############################################################################################################
##################TEST CASE: PORTAL - SSIDs TAB - USE 'ONBOARDING' PORTAL TYPE - ASSIGN TO PROFILE SSID########
###############################################################################################################
describe "********** TEST CASE: PORTAL - SSIDs TAB - USE 'ONBOARDING' PORTAL TYPE - ASSIGN TO PROFILE SSID **********" do

  profile_name = "Profile for testing SSIDs of Portals " + UTIL.ickey_shuffle(4)
  profile_description_prefix = "profile description for "
  description_prefix = "portal description for "
  portal_type = "onboarding"
  ssid_name = "Test SSID"
  domain_name = "testcompany.edu"

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu" , profile_name, profile_description_prefix + profile_name, false
  include_examples "add profile ssid", profile_name, ssid_name


      portal_name = "Portal ('#{portal_type}') for testing SSIDs " + UTIL.ickey_shuffle(4)
      include_examples "create portal from header menu", portal_name, description_prefix + portal_name, portal_type

      include_examples "update portal ssids settings", portal_name, portal_type, profile_name, ssid_name, false

          include_examples "check for encryption/auth update to SSID for onboarding", profile_name, portal_name


  include_examples "delete profile ssids", profile_name

end