require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "../TS_General/local_lib/guidedtour_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
############################################################################################
#############TEST CASE: Test the GUIDED TOUR area - EIRCOM#################################
############################################################################################
describe "********** TEST CASE: Test the GUIDED TOUR area - EIRCOM **********" do

  profile_name = UTIL.random_title + " - (guided tour)"
  decription_prefix = "Profile description for "
  domain_name = "Eircom Guided Tour Domain " + UTIL.ickey_shuffle(6)

  include_examples "go to commandcenter"
  include_examples "create Domain", domain_name
  include_examples "change to tenant", domain_name, 1
  include_examples "run guided tour", profile_name, decription_prefix + profile_name
  include_examples "create portal from header menu", "Self Registration Access Service", "DESCRIPTION", "self_reg"
  include_examples "verify mobile isn't present", "Self Registration Access Service"
  include_examples "go to commandcenter"
  include_examples "delete Domain", domain_name

end