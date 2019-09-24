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
#############TEST CASE: TROUBLESHOOTING AREA - PORTAL - AMBASSADORONBOARDING - ADD AND DELETE GUESTS IN UI - VERIFY AUDIT TRAIL LOG##########
##############################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - PORTAL - AMBASSADORONBOARDING - ADD AND DELETE GUESTS IN UI - VERIFY AUDIT TRAIL LOG **********" do

  portal_name = "ONBOARDING - " + UTIL.ickey_shuffle(6)
  description_prefix = "Portal description for: "
  portal_type = 'onboarding'
  user_name = "Test User Name"
  user_id = UTIL.ickey_shuffle(6)

  domain_name = "Child Domain for Portal Second tab"
  include_examples "scope to tenant", domain_name

  include_examples "set timezone area to local"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_name, description_prefix + portal_name, portal_type

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "add a user", portal_name, user_name, user_id
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "PSK: "+user_name], 2

  new_user_name = "NEW " + user_name

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "edit a user", portal_name, user_name, new_user_name, user_id
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["PSK: "+new_user_name], 1
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "PSK: "+user_name], 2

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "regenerate user PSK", portal_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["PSK: "+new_user_name], 1
  include_examples "perform action verify audit trail", "UPDATE", Array["PSK: "+new_user_name], 2
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name, "PSK: "+user_name], 3

  include_examples "navigate to the portal second page", portal_name, false
  include_examples "delete user", portal_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["PSK: "+new_user_name], 1

  include_examples "delete portal from tile", portal_name
end