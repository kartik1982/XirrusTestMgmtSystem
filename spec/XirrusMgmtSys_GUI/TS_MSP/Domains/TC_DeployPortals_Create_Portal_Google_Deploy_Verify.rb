require_relative "../../TS_Portal/local_lib/general_lib.rb"
require_relative "../../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portal/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
require_relative "../local_lib/msp_lib.rb"
##################################################################################################
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type GOOGLE######################
##################################################################################################
describe "*******TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type GOOGLE************" do

	portal_type = "google"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	tenant_name = "Deploy PORTALS to this domain 2"
	login_domain = "test.org"
  
		include_examples "verify portal list view tile view toggle"
		include_examples "create portal from header menu", portal_name, portal_description, portal_type
		include_examples "update login domains dont delete", portal_name, portal_type, login_domain
		include_examples "update portal description", portal_name, portal_name, portal_type
		include_examples "deploy portal to a domain from inside portal - verify the deploy modal", portal_name, tenant_name
		include_examples "go to commandcenter"
		include_examples "manage specific domain", tenant_name
		include_examples "verify landing page deployed element", "Portals", portal_name
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "General", "Description", portal_name + " update"
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "General", "Login Domain", login_domain
		include_examples "deploy a portal to a domain and verify that the portal records are not copied", portal_name, true
		include_examples "go to commandcenter"

end