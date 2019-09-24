require_relative "../local_lib/profile_lib.rb"
require_relative "../local_lib/ssids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_XMSE/local_lib/xmse_lib.rb"
####################################################################################
##############TEST CASE: Easy pass portals Add, Edit and Delete SSIDs################
####################################################################################
describe "**************TEST CASE: Easy pass portals Add, Edit and Delete SSIDs***************" do

	profile_name = UTIL.random_title.downcase
	decription_prefix = "profile description for "
	portal_from_header_name = UTIL.random_title.downcase + " - header menu"
	decription_prefix = "portal description for "
	
  include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, "Profile description", false
	include_examples "add profile ssid", profile_name, 'ssid'

	include_examples "verify portal list view tile view toggle" 
	include_examples "edit an ssid and add a new captive portal gap", profile_name, 'ambassador'

	for portal_type  in ["onboarding","self_reg","google","ambassador","onetouch","personal","voucher"] do
		include_examples "create portal from header menu", portal_from_header_name + " #{portal_type}", decription_prefix + portal_from_header_name, portal_type
	end

	for portal_type in ["self_reg","google","ambassador","onetouch","personal","voucher"] do
		include_examples "edit an ssid and change access control to captive portal gap", profile_name, portal_from_header_name + " #{portal_type}", portal_type
	end

	include_examples "edit an ssid and change access control to captive portal gap onboarding", profile_name, portal_from_header_name + " onboarding"
	include_examples "edit an ssid with onboarding and remove UPSK encryption", profile_name
	include_examples "edit an ssid and change access control to captive portal gap onboarding", profile_name, portal_from_header_name + " onboarding"
	include_examples "edit an ssid with onboarding and change portal to self registration", profile_name, portal_from_header_name + " self_reg"

	include_examples "edit an ssid and change access control to none", profile_name
	include_examples "delete profile ssids", profile_name

end