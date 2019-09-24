require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##########################################################################################################
#################TEST CASE: PORTAL - ONE CLICK ACCESS - LOOK & FEEL TAB CONFIGURATIONS###################
##########################################################################################################
describe "********** TEST CASE: PORTAL - ONE CLICK ACCESS - LOOK & FEEL TAB CONFIGURATIONS **********" do

  portal_name =  "ONE CLICK ACCESS - " + UTIL.ickey_shuffle(5) 
  portal_description = "Portal description for: "
  portal_type = "onetouch"
  company_name = "TEST COMPANY"

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type

  include_examples "go to portal look feel tab", portal_name
  include_examples "update portal look & feel", portal_name, portal_type, company_name

end