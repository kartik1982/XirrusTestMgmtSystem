require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/users_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "./local_lib/xmslight_lib.rb"

############################################################################################################################
#################TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit#######################
############################################################################################################################

describe "********** TEST CASE: XMS-LIGHT TENANT - ONBOARDING Portal - Import and verify max users limit **********" do


 	portal_type = "onboarding"
  portal_name = "#{portal_type.upcase} - XMS Light Tenant"
  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_name, portal_name, portal_type
	include_examples "import users", portal_name, "100_users_import", false, 100
	include_examples "add user for onboarding", portal_name, "TEST", "test@test.org", "TEST", "TEST", nil, 100, false, ""

end