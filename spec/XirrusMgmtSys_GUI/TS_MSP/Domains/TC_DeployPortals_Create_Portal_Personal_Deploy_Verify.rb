require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
require_relative "../local_lib/msp_lib.rb"
##################################################################################################
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type PERSONAL Wi-Fi###############
##################################################################################################
describe "************TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type PERSONAL Wi-Fi*************" do

	portal_type = "personal"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	tenant_name = "Deploy PORTALS to this domain 1"

		include_examples "create portal from header menu", portal_name, portal_description, portal_type
		#include_examples "access services guests/users/vouchers tab", portal_name, portal_type
		include_examples "deploy portal to a domain from portals landing page - verify the deploy modal", portal_name, tenant_name
		include_examples "go to commandcenter"
		include_examples "manage specific domain", tenant_name
		include_examples "verify landing page deployed element", "Portals", portal_name
		include_examples "go to commandcenter"

end