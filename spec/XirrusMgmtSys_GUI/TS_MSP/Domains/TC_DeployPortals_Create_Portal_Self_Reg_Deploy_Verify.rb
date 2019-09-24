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
############TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type SELF-REGISTRATION############
##################################################################################################
describe "********TEST CASE: TEST THE DEPLOY PORTALS FEATURE - Portal type SELF-REGISTRATION*****************" do

	profile_name = "Profile for testing SSIDs on Deployed portals " + UTIL.ickey_shuffle(5)
	
  include_examples "delete all profiles from the grid"
  include_examples "verify portal list view tile view toggle"
	include_examples "create profile from header menu", profile_name, "Profile description", false
 	include_examples "add honeypot ssid", profile_name

	portal_type = "self_reg"
	portal_name = "Portal to be deployed - " + UTIL.ickey_shuffle(9) + " - #{portal_type}"
	portal_description = "Random description text: " + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9) + UTIL.ickey_shuffle(9)
	tenant_name = "Deploy PORTALS to this domain 1"

	landing_page = "https://www.google.co.uk"
	company_name = "The testing company LTD"
	ssid_name = "honeypot"
    
    
		include_examples "create portal from header menu", portal_name, portal_description, portal_type
		include_examples "update portal description", portal_name, portal_name, portal_type
		include_examples "update portal landing page", portal_name, portal_type, landing_page
		include_examples "go to portal look feel tab", portal_name
		include_examples "update portal look & feel company name", portal_name, portal_type, company_name
		include_examples "update portal look & feel powered by", portal_name, portal_type, "disabled"
		include_examples "update portal ssids settings", portal_name, portal_type, profile_name, ssid_name, false
		#include_examples "access services guests/users/vouchers tab", portal_name, portal_type
		include_examples "deploy portal to a domain from portals landing page - verify the deploy modal", portal_name, tenant_name
		include_examples "go to commandcenter"
		include_examples "manage specific domain", tenant_name
		include_examples "verify landing page deployed element", "Portals", portal_name
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "General", "Description", portal_name + " update"
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "General", "Landing Page", landing_page
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "Look & Feel", "Company Name", company_name
		include_examples "deploy a portal to a domain and verify that the portal configurations are copied", portal_name, portal_type, "Look & Feel", "Show Powered by Xirrus", false
		include_examples "deploy a portal to a domain and verify that the portal records are not copied", portal_name, true
		include_examples "go to commandcenter"

end