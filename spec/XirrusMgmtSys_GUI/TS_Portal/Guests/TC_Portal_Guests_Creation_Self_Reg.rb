require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/guests_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the SELF REGISTRATION PORTAL - GUESTS TAB - ADD SEVERAL GUESTS##############
##############################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the SELF REGISTRATION PORTAL - GUESTS TAB - ADD SEVERAL GUESTS **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "DO NOT DELETE - SELF_REGISTRATION_PORTAL - 100 Guests"
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "self_reg"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type
  include_examples "add several guests", 50 ,portal_name, true
  include_examples "add several guests", 49 ,portal_name, false


end