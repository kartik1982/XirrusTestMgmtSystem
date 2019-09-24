require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##########################################################################################################
#################TEST CASE: PORTAL - VOUCHER - LOOK & FEEL TAB CONFIGURATIONS############################
##########################################################################################################
describe "********** TEST CASE: PORTAL - VOUCHER - LOOK & FEEL TAB CONFIGURATIONS **********" do

  portal_name =  "VOUCHER - " + UTIL.ickey_shuffle(5)
  portal_description = "Portal description for: "
  portal_type = "voucher"
  company_name = "TEST COMPANY"

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type

  include_examples "go to portal look feel tab", portal_name
  include_examples "update portal look & feel company name", portal_name, portal_type, company_name
  include_examples "update portal look & feel logo external", portal_name, portal_type, 'https://i.imgur.com/4VOBizw.jpg', '4VOBizw'
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(0, 67, 86)"
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(35, 141, 118)"
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(188, 214, 95)"
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(253, 222, 85)"
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(252, 117, 48)"
  include_examples "update portal look & feel color", portal_name, portal_type, "rgb(220, 58, 51)"
  include_examples "update portal look & feel powered by", portal_name, portal_type, "disabled"
  include_examples "update portal look & feel powered by", portal_name, portal_type, "enabled"
  include_examples "update portal look & feel background external", portal_name, portal_type, 'https://i.imgur.com/4VOBizw.jpg', '4VOBizw'
  include_examples "update portal look & feel background fill screen", portal_name, portal_type, "enabled"
  include_examples "update portal look & feel background fill screen", portal_name, portal_type, "disabled"

  
  include_examples "verify page name, description and position", "Manage Devices", 2, "This page appears for users who exceed their quota for devices."

end