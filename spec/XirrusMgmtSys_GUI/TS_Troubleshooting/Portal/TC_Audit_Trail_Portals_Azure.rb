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
#############TEST CASE: TROUBLESHOOTING AREA - PORTAL - MICROSOFT AZURE - ADD, EDIT AND DELETE PORTALS IN UI - VERIFY AUDIT TRAIL LOG#########
##############################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - PORTAL - MICROSOFT AZURE - ADD, EDIT AND DELETE PORTALS IN UI - VERIFY AUDIT TRAIL LOG **********" do

  portal_from_tile_name = "AZURE - " + UTIL.ickey_shuffle(6) + " - CREATED FROM EMPTY GRID TILE"
  decription_prefix = "Portal description for: "
  portal_type = 'azure'
  login_domain = "test.com"

  domain_name = "Child Domain for Portal Second tab"
  include_examples "scope to tenant", domain_name

  include_examples "set timezone area to local"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_from_tile_name, decription_prefix + portal_from_tile_name, portal_type
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "CREATE", Array["EasyPass Portal: "+portal_from_tile_name], 1

  include_examples "go to portal", portal_from_tile_name
  #include_examples "update login domains dont delete", portal_from_tile_name, portal_type, login_domain
  include_examples "update azure authorization on", portal_from_tile_name, portal_type, $azure_user, $azure_password
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["EasyPass Portal: "+portal_from_tile_name], 1

  include_examples "delete portal from tile", portal_from_tile_name
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "DELETE", Array["EasyPass Portal: "+portal_from_tile_name], 1
end