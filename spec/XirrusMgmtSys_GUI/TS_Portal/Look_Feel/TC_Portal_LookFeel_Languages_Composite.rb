require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
##############################################################################################################################
###################TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - COMPOSITE PORTAL - ALL LANGUAGES SUPPORTED############
##############################################################################################################################
describe "********** TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - COMPOSITE PORTAL - ALL LANGUAGES SUPPORTED **********" do

  portal_type = "mega"
  portal_name = "PORTAL " + portal_type.upcase + " - " + UTIL.ickey_shuffle(6)
  description = "Portal description"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, description, portal_type
  for language in ["English", "Français", "Deutsch","Español"] do
    include_examples "update general language settings and verify portal look & feel tab pages", portal_type, language
  end

end