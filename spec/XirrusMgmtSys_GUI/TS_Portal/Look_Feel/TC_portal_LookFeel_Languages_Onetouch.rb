require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - ONETOUCH PORTAL - ALL LANGUAGES SUPPORTED#############
##############################################################################################################################
describe "********** TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - ONETOUCH PORTAL - ALL LANGUAGES SUPPORTED **********" do

  portal_type = "onetouch"
  portal_name = "PORTAL " + portal_type.upcase + " - " + UTIL.ickey_shuffle(6)
  description = "Portal description"
  company_name = "TEST"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, description, portal_type
  for language in ["English", "Français", "Deutsch", "Español"] do
    include_examples "update general language settings and verify on portal look & feel onetouch", portal_name, language, false, false
  end
  include_examples "update portal look & feel require email address", portal_name, portal_type, "enabled", true
  include_examples "update portal look & feel data disclosure",  portal_name, portal_type, "enabled"
  include_examples "update portal look & feel terms of use", portal_name, portal_type, "enabled"
  for language in ["English", "Français", "Deutsch", "Español"] do
    include_examples "update general language settings and verify on portal look & feel onetouch", portal_name, language, true, true
  end

end