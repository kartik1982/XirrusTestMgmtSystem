require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/guests_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTAL - SELF REGISTRATION - GUESTS TAB CONFIGURATIONS########################################
##############################################################################################################################
describe "********** TEST CASE: PORTAL - SELF REGISTRATION - GUESTS TAB CONFIGURATIONS **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name =  "SELF_REGISTRATION_PORTAL - " + UTIL.ickey_shuffle(5)
  portal_description = "Portal description for: "
  portal_type = "self_reg"
  company_name = "TEST COMPANY"

  # include_examples "scope to tenant", domain_name

  include_examples "create portal from header menu", portal_name, portal_description + portal_name, portal_type
  include_examples "verify guests grid", portal_name
  include_examples "add guest", portal_name, "Robert DeNiro", "robert_deniro@personalmail.com", false, "", "", "", "The Company Ltd.", "Test account", false
  include_examples "add guest", portal_name, "Patrick Swayze", "patrick_swayze@personalmail.com", false, "", "", "", "The Company Ltd.", "Test account", false
  include_examples "delete guest", portal_name, "robert_deniro@personalmail.com"

  # include_examples "scope to parent tenant"
end