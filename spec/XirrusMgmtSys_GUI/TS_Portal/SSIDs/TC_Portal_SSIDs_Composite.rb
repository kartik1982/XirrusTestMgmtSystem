require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/general_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
###############################################################################################################
##################TEST CASE: PORTAL - SSIDs TAB - USE 'COMPOSITE' PORTAL TYPE - ASSIGN TO PROFILE SSID########
###############################################################################################################
describe "********** TEST CASE: PORTAL - SSIDs TAB - USE 'COMPOSITE' PORTAL TYPE - ASSIGN TO PROFILE SSID **********" do

  include_examples "verify portal list view tile view toggle"

  portal_types = ["self_reg","ambassador","onetouch","voucher","google","azure"]

  profile_name = "Profile for testing SSIDs of Portals " + UTIL.ickey_shuffle(4)
  profile_description_prefix = "profile description for "
  description_prefix = "portal description for "
  portal_type = "mega"
  ssid_name = "Test SSID"

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu" , profile_name, profile_description_prefix + profile_name, false
  include_examples "add profile ssid", profile_name, ssid_name

  portal_names_array = Array[]
  2.times do |i|
    portal_type_sample = portal_types.sample
    portal_names_array.push("#{portal_type_sample.upcase} portal #{i}")
    include_examples "create portal from header menu", "#{portal_type_sample.upcase} portal #{i}", "DESCRIPTION TEXT", portal_type_sample
  end

      portal_name = "Portal ('#{portal_type}') for testing SSIDs " + UTIL.ickey_shuffle(4)
      include_examples "create portal from header menu", portal_name, description_prefix + portal_name, portal_type

      include_examples "update composite portals", portal_name, portal_names_array[0], portal_names_array[1]

      include_examples "update portal ssids settings", portal_name, portal_type, profile_name, ssid_name, false


  include_examples "delete profile ssids", profile_name

end