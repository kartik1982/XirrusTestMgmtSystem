require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/users_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
###############################################################################
##################TEST CASE: Edit portal users#################################
###############################################################################
describe "*************TEST CASE: Edit portal users**************************" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "ONBOARDING_PORTAL"
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "onboarding"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type
  include_examples "add, edit and delete user", portal_name

end