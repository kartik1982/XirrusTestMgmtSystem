require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/users_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL GUESTS#####################
##############################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL GUESTS **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "ONBOARDING_PORTAL"
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "onboarding"

  include_examples "scope to tenant", domain_name
  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type

  username = "Name - "
  email = nil
  user_id = "22"
  note = UTIL.chars_255
  group = "Test Group 1"

  include_examples "add several users", portal_name, 5, username, email, user_id, note, group

  username = "Other Name - "
  email = "test@test.org"
  user_id = "33"
  note = UTIL.chars_255
  group = "Test Group 2"

  include_examples "add several users", portal_name, 6, username, email, user_id, note, group

end