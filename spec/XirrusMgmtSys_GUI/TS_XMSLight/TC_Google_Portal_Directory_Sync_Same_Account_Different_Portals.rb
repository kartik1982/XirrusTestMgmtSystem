require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
###########################################################################################################################################
################### TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit ##################################
###########################################################################################################################################
describe "********** TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit **********" do
  	portal_type = "google"
    portal_name = "#{portal_type.upcase} - XMS Light Tenant " + UTIL.ickey_shuffle(3)
    description = "Test portal for Google Directory Synchronization"

    include_examples "verify portal list view tile view toggle"

    include_examples "create portal from header menu", portal_name, description, portal_type
  	include_examples "go to portal", portal_name
  	include_examples "update login domains dont delete", portal_name, portal_type, "xirrus.org"
  	include_examples "update directory synchronization on", portal_name, portal_type, "mykhaylo@xirrus.org", "Xirrus!234"

    portal_name_new = "#{portal_type.upcase} - XMS Light Tenant " + UTIL.ickey_shuffle(3)

    include_examples "create portal from header menu", portal_name_new, description, portal_type
    include_examples "go to portal", portal_name_new
    include_examples "update login domains dont delete", portal_name_new, portal_type, "xirrus.org"
    include_examples "update directory synchronization on", portal_name_new, portal_type, "mykhaylo@xirrus.org", "Xirrus!234"

    include_examples "go to portal", portal_name
  	include_examples "verify directory synchronization logged in user", "mykhaylo@xirrus.org", ""

end