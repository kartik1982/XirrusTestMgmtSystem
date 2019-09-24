require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
#############################################################################################################
###################TEST CASE: PORTAL - GOOGLE - LOOK & FEEL TAB CONFIGURATIONS###############################
#############################################################################################################
describe "********** TEST CASE: PORTAL - GOOGLE - LOOK & FEEL TAB CONFIGURATIONS **********" do

  portal_name =  "GOOGLE - " + UTIL.ickey_shuffle(5)
  portal_description = "Portal description for: "
  portal_type = "google"
  company_name = "TEST COMPANY"
  domain_name = "testcompany.co.uk"

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type
  include_examples "update login domains dont delete", portal_name, portal_type, domain_name
  include_examples "go to portal look feel tab", portal_name
  include_examples "update portal look & feel", portal_name, portal_type, company_name

end