require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../local_lib/floorplans_lib.rb"
require_relative "../../environment_variables_library.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
############################################################################################################################
###############TEST CASE: Test the MY NETWORK area - FLOOR PLANS - VERIFY APs on FLOORPLAN##################################
############################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - FLOOR PLANS - VERIFY APs on FLOORPLAN **********" do

	ap_name = "Auto-X2-120-2"
	profile_name = "Auto-X2-120-2"
	building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
	floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)
	image_name = "/xirrus.png"
	environments = ["Apartment Building", "Convention Center", "Office (Cubicles)", "Hospital", "Hotel", "Outdoors", "School", "Office (Walled)", "Warehouse"]
	environment = environments.sample
	scale_amout = "5"
	scale_units = ["ft", "m"]
	scale_unit = scale_units.sample
	address_search = "FDR Dr, Manhattan, New York, New York 10075, United States"
	address_verify = ["CVS Pharmacy, 1569 1st Ave, New York, New York 10028, United States", "Main St, Manhattan, New York, New York 10044, United States", "37 River Rd, Manhattan, New York, New York 10044, United States", "East River Esplanade, Manhattan, New York, New York, United States", "Manhattan, New York, New York 10009, United States"]
	ap_status = "/img/floorArrayOffline.png"
	location = "NEW LOCATION"
	tags = ["Tag_#{UTIL.ickey_shuffle(9)}", "Tag_#{UTIL.ickey_shuffle(9)}", "Tag_#{UTIL.ickey_shuffle(9)}"]

	ap_name_new = "AutomationX2-120-NEW"

	include_examples "delete all profiles from the grid"
	include_examples "create profile from header menu", profile_name, "TEST PROFILE - Created to verify the default view on the AP grid", false
	include_examples "create building", building_name, floor_name, image_name, false, true
	include_examples "edit building", building_name, environment, scale_amout, scale_unit, address_search, address_verify
	include_examples "edit building set ap", building_name, ap_name, ap_status
	include_examples "edit building edit ap details", building_name, ap_name, "X2-120", false, profile_name, "", "", "", ""
	include_examples "edit building edit ap details", building_name, ap_name, "X2-120", false,"", ap_name_new, location, "", ""
	include_examples "edit building edit ap details", building_name, ap_name_new, "X2-120", true, profile_name, ap_name_new, location, "", ""
	include_examples "edit building edit ap details", building_name, ap_name_new, "X2-120", false, "", ap_name, " ", "", ""
	include_examples "edit building edit ap details", building_name, ap_name, "X2-120", true, profile_name, ap_name, "", "", ""
	include_examples "delete building from tile", building_name

end