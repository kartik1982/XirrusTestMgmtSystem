require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/lookfeel_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
####################################################################################################################################
###################TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - SELF REGISTRATION PORTAL - ALL LANGUAGES SUPPORTED##########
####################################################################################################################################
describe "********** TEST CASE: PORTALS area - Test the LOOK & FEEL TAB - SELF REGISTRATION PORTAL - ALL LANGUAGES SUPPORTED **********" do

  portal_type = "self_reg"
  portal_name = "PORTAL " + portal_type.upcase + " - " + UTIL.ickey_shuffle(6)
  description = "Portal description"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, description, portal_type
  for language in ["简体中文", "繁體中文", "Nederlands", "English", "Français", "Deutsch", "Ελληνικά", "Bahasa Indonesia", "Italiano", "日本語", "Bahasa Malaysia", "Norsk", "Português (Brasil)", "Pусский", "Español", "Español (América Latina)", "Svenska", "Filipino", "Українська"] do
    include_examples "update general language settings and verify portal look & feel tab pages", portal_type, language
  end

end