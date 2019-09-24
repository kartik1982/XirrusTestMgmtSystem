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
#############TEST CASE: TROUBLESHOOTING AREA - PORTAL - ONE CLICK ACCESS - ADD, EDIT AND DELETE PORTALS IN UI - VERIFY AUDIT TRAIL LOG########
##############################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - PORTAL - ONE CLICK ACCESS - ADD, EDIT AND DELETE PORTALS IN UI - VERIFY AUDIT TRAIL LOG **********" do

  portal_name = "ONE CLICK - " + UTIL.ickey_shuffle(6) + " - CREATED FROM EMPTY GRID TILE"
  description_prefix = "Portal description for: "
  portal_type = 'onetouch'
  login_domain = "test.com"

  domain_name = "Child Domain for Portal Second tab"
  include_examples "scope to tenant", domain_name

  include_examples "set timezone area to local"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_name, description_prefix + portal_name, portal_type
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_name], 1

  portal_description_new = description_prefix + " NEW"
  include_examples "go to portal", portal_name
  include_examples "update portal description", portal_name, portal_description_new, portal_type
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["EasyPass Portal: "+portal_name], 1

  include_examples "delete portal from tile", portal_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["EasyPass Portal: "+portal_name], 1
end