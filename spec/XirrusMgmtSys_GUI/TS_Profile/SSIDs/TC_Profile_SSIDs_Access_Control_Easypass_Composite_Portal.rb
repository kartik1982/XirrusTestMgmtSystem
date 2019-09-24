require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
######################################################################################################################
######################TEST CASE: PROFILE - SSIDs TAB - USE COMPOSITE PORTAL##########################################
######################################################################################################################
describe "********** TEST CASE: PROFILE - SSIDs TAB - USE COMPOSITE PORTAL **********" do

	profile_name = "Profile for Composite Portal SSID - " + UTIL.ickey_shuffle(5)
	portal_types = ["self_reg","ambassador","onetouch","voucher","google","azure"]
	portal_name = "COMPOSITE - General - " + UTIL.ickey_shuffle(5)
	description = "Portal description for: "
	portal_type = "mega"

	include_examples "verify portal list view tile view toggle"

	portal_names_array = Array[]
	2.times do |i|
	  portal_type_sample = portal_types.sample
	  portal_names_array.push("#{portal_type_sample.upcase} portal #{i}")
	  include_examples "create portal from header menu", "#{portal_type_sample.upcase} portal #{i}", "DESCRIPTION TEXT", portal_type_sample
	end

	include_examples "create portal from header menu", portal_name, description + portal_name, portal_type

	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "add profile ssid", profile_name, 'ssid'

	include_examples "go to profile", profile_name

	include_examples "edit an ssid and change access control to captive portal gap", profile_name, portal_name , portal_type

end