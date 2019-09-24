require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Portal/local_lib/general_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portal/local_lib/guests_lib.rb"
require_relative "../../TS_Portal/local_lib/users_lib.rb"
require_relative "../../TS_Portal/local_lib/vouchers_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
##############################################################################################################################################
#############TEST CASE: TROUBLESHOOTING AREA - PORTAL - SELF REGISTRATION - ADD AND DELETE GUESTS IN UI - VERIFY AUDIT TRAIL LOG##############
##############################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - PORTAL - SELF REGISTRATION - ADD AND DELETE GUESTS IN UI - VERIFY AUDIT TRAIL LOG **********" do

  portal_name = "SELF REGISTRATION - " + UTIL.ickey_shuffle(6)
  description_prefix = "Portal description for: "
  portal_type = 'self_reg'
  guest_name = "Test Guest Name"
  guest_name_new = ""
  guest_email = "test@guest.org"
  receive_via_sms = false
  country = ""
  mobile_number = ""
  mobile_carrier = ""
  guest_company = "Test Company Ltd"
  note = "Random note " + UTIL.ickey_shuffle(9)

  domain_name = "Child Domain for Portal Second tab"
  include_examples "scope to tenant", domain_name

  include_examples "set timezone area to local"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_name, description_prefix + portal_name, portal_type

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "add guest", portal_name, guest_name, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, false
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "Guest: "+guest_name], 1

  edit_option = "Reset & Send Password"

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "edit guest", portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, false
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 2
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "Guest: "+guest_name], 3

  edit_option = "Remove Access"

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "edit guest", portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, false
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 1
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 3
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "Guest: "+guest_name], 4

  edit_option = "Enable Access"

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "edit guest", portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, false
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 1
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 2
  include_examples "perform action verify audit trail", "UPDATE", Array["Guest: "+guest_name], 4
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "Guest: "+guest_name], 5

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "delete guest", portal_name, guest_email
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["Guest: "+guest_name], 1

  include_examples "delete portal from tile", portal_name
end