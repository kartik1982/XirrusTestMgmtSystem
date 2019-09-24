require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Portal/local_lib/guests_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "./local_lib/xmslight_lib.rb"

############################################################################################################################
#################TEST CASE: XMS-LIGHT TENANT - SELF REGISTRATION Portal - Import and verify max users limit#################
############################################################################################################################

describe "********** TEST CASE: XMS-LIGHT TENANT - SELF REGISTRATION Portal - Import and verify max users limit **********" do

  	portal_type = "self_reg"
    portal_name = "#{portal_type.upcase} - XMS Light Tenant " + UTIL.ickey_shuffle(9)

    include_examples "verify portal list view tile view toggle"
    include_examples "create portal from header menu", portal_name, portal_name, portal_type
	include_examples "add several guests", 100, portal_name, false
	include_examples "verify add guest button disabled", portal_name


end