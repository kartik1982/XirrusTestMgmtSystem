require_relative "../../TS_Portal/local_lib/general_lib.rb"
require_relative "../../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portal/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
require_relative "../local_lib/msp_lib.rb"
#####################################################################################################################################
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type SELF-REGISTRATION - VERIFY DUPLICATE DEPLOY#####################
#####################################################################################################################################
describe "*************TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type SELF-REGISTRATION - VERIFY DUPLICATE DEPLOY******************" do

	portal_type = "self_reg"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	tenant_name = "Deploy PORTALS to this domain 1"


		include_examples "create portal from header menu", portal_name, portal_description, portal_type
		include_examples "deploy portal to a domain from portals landing page - verify the deploy modal", portal_name, tenant_name
		include_examples "deploy portal to a domain from portals landing page - verify the duplicate error message", portal_name, tenant_name

end