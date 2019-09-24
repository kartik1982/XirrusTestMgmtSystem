require_relative "./local_lib/portal_lib.rb"
require_relative "./local_lib/vouchers_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
########################################################################################
#############TEST CASE: PORTAL - VOUCHER - VOUCHERS TAB##################################
########################################################################################
describe "********** TEST CASE: PORTAL - VOUCHER - VOUCHERS TAB **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "VOUCHER_PORTAL-" + UTIL.ickey_shuffle(5)
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "voucher"

  include_examples "scope to tenant", domain_name
  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type
  include_examples "add, edit and delete vouchers", portal_name
  include_examples "verify vouchers table"

end