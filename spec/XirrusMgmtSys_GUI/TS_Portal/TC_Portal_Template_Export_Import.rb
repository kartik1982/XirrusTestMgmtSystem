require_relative "./local_lib/portal_lib.rb"
require_relative "./local_lib/guests_lib.rb"
require_relative "./local_lib/template_export_import_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_General/local_lib/localized_time_display_lib.rb"
#################################################################################################################################
#############TEST CASE: PORTALS area - Test the USERS or GUESTS TAB - ALL TYPES OF PORTAL - EXPORT of the TEMPLATE###############
#################################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the USERS or GUESTS TAB - ALL TYPES OF PORTAL - EXPORT of the TEMPLATE **********" do

  include_examples "set timezone area to local"
  
  domain_name = "Child Domain for Portal Second tab"
  include_examples "verify portal list view tile view toggle"

  portal_types = ["azure","onboarding","voucher","google"] 
    portal_types.each do |portal_type|
      portal_name = portal_type.upcase + " PORTAL - " + UTIL.ickey_shuffle(6)
      portal_description = "Description text for the portal named " + portal_name

      include_examples "create portal from header menu", portal_name, portal_description, portal_type
      include_examples "export template", portal_name, portal_type

    end
end