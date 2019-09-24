require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/guests_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the AMBASSADOR PORTAL - GUESTS TAB - ADD SEVERAL GUESTS####################
##############################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the AMBASSADOR PORTAL - GUESTS TAB - ADD SEVERAL GUESTS **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "AMBASSADOR_PORTAL"
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "ambassador"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type
  include_examples "add several guests", 5 ,portal_name, true
  include_examples "add several guests", 5 ,portal_name, false

end