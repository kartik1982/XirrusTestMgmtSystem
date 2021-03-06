require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../local_lib/msp_lib.rb"
##################################################################################################
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type VOUCHER#####################
##################################################################################################
describe "************TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type VOUCHER******************" do

	portal_type = "voucher"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	tenant_name = "Deploy PORTALS to this domain 2"

		include_examples "create portal from header menu", portal_name, portal_description, portal_type
		#include_examples "access services guests/users/vouchers tab", portal_name, portal_type
		include_examples "deploy portal to a domain from inside portal - verify the deploy modal", portal_name, tenant_name
		include_examples "go to commandcenter"
		include_examples "manage specific domain", tenant_name
		include_examples "verify landing page deployed element", "Portals", portal_name
		include_examples "go to commandcenter"

end