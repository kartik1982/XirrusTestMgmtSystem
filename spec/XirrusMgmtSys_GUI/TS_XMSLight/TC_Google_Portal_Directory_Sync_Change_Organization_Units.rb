require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"

############################################################################################################################
##############TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit##########################
############################################################################################################################
describe "********** TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit **********" do

  	portal_type = "google"
    portal_name = "#{portal_type.upcase} - XMS Light Tenant " + UTIL.ickey_shuffle(3)
    description = "Test portal for Google Directory Synchronization"

    include_examples "verify portal list view tile view toggle"

    include_examples "create portal from header menu", portal_name, description, portal_type
  	include_examples "go to portal", portal_name
  	include_examples "update login domains dont delete", portal_name, portal_type, "testdomain.org"
    include_examples "update directory synchronization on", portal_name, portal_type, $google_user, $google_password
    include_examples "update directory synchronization change organization unit", portal_name, "xirrus-auto", "Check", "1", false
    include_examples "update directory synchronization change organization unit", portal_name, ["students", "teachers"], "Check", "3", false
    include_examples "update directory synchronization change organization unit", portal_name, ["students", "teachers", "xirrus-auto"], "Uncheck", "0", true
    include_examples "update directory synchronization change organization unit", portal_name, ["xirrus-auto", "THIS_IS_A_DUPLICATE_ORGANIZATION_NAME", "one more"], "Check", "5", false
    include_examples "update directory synchronization change organization unit", portal_name, nil, nil, nil, true
    include_examples "update directory synchronization change organization unit", portal_name, "students", "Check", "1", false
  	include_examples "verify directory synchronization logged in user", $google_user, ""
    include_examples "update directory synchronization off", portal_name, "testdomain.org"

end