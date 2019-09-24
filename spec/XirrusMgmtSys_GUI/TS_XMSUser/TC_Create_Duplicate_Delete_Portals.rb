require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
#####################################################################################################################
##############TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - XMS USER####################
#####################################################################################################################
describe "********** TEST CASE: Test the PORTALS area - Create, default, duplicate and delete - XMS USER **********" do

  include_examples "verify portal list view tile view toggle"

  portal_types = ["onboarding","self_reg","google","ambassador","onetouch","personal","voucher"]

  portal_types.each { |portal_type|
    portal_name = "ACCESS SERVICE for testing XMS GUEST - " + portal_type.downcase

    include_examples "create portal from header menu", portal_name, "DESCRIPTION " + portal_name, portal_type
	}

  portal_name = "ACCESS SERVICE - XMS Guests - OTHER TESTS"

  include_examples "create portal from header menu", portal_name, "DESCRIPTION " + portal_name, "self_reg"
  include_examples "duplicate portal from tile", portal_name, "DESCRIPTION " + portal_name, "self_reg"
   include_examples "search for portal", portal_name
  include_examples "delete portal from portal menu", "Copy of " + portal_name
  include_examples "duplicate portal from portal menu", portal_name, "DESCRIPTION " + portal_name, "self_reg"
  include_examples "delete portal from tile", "Copy of " + portal_name
  include_examples "delete portal from portal menu", portal_name

end