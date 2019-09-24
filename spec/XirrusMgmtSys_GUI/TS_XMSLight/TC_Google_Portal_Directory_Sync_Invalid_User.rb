require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
###########################################################################################################################################
###################TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit#####################################
###########################################################################################################################################

describe "********** TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit **********" do

  	portal_type = "google"
    portal_name = "#{portal_type.upcase} - XMS Light Tenant " + UTIL.ickey_shuffle(3)
    description = "Test portal for Google Directory Synchronization"

    include_examples "verify portal list view tile view toggle"

  	include_examples "create portal from header menu", portal_name, description, portal_type
  	include_examples "go to portal", portal_name
  	include_examples "update login domains dont delete", portal_name, portal_type, "testdomain.org"
  	include_examples "update directory synchronization verify invalid account error", "xirrusms@gmail.com", "Xirrus!234"

end