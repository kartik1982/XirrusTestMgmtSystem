require_relative "./local_lib/portals_lib.rb"
##############################################################################################################
##############TEST CASE: PORTAL - ONBOARDING - ADD, DUPLICATE AND DELETE PORTALS IN UI########################
##############################################################################################################
describe "********** TEST CASE: PORTAL - ONBOARDING - ADD, DUPLICATE AND DELETE PORTALS IN UI  **********" do
  portal_from_tile_name = UTIL.random_title.downcase + " - tile"
  portal_from_btn_name = UTIL.random_title.downcase + " - button"
  portal_from_header_name = UTIL.random_title.downcase + " - header menu"
  decription_prefix = "portal description for "
  portal_type = 'onboarding'

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from tile", portal_from_tile_name, decription_prefix + portal_from_tile_name, portal_type
  include_examples "create portal from header menu", portal_from_header_name, decription_prefix + portal_from_header_name, portal_type
  include_examples "create portal from new portal button", portal_from_btn_name, decription_prefix + portal_from_btn_name, portal_type
  include_examples "duplicate portal from tile", portal_from_tile_name, decription_prefix + portal_from_tile_name, portal_type
  include_examples "duplicate portal from portal menu", portal_from_btn_name, decription_prefix + portal_from_btn_name, portal_type
  include_examples "search for portal", portal_from_tile_name
  include_examples "delete portal from portal menu", portal_from_btn_name
  include_examples "delete portal from tile", portal_from_tile_name

end