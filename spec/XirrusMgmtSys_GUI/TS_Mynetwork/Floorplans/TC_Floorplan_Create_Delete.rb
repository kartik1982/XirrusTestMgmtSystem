require_relative "../local_lib/floorplans_lib.rb"
##################################################################################################################
###############TEST CASE: Test the MY NETWORK area - FLOOR PLANS - CREATE, DELETE###############################
##################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - FLOOR PLANS - CREATE, DELETE **********" do
	include_examples "verify floorplan list view tile view toggle"
	include_examples "delete all floorplans from the grid"
	(1..4).each do |i|
		building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
		floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)
		image_name = "/xirrus.png"
		if i != 3
			include_examples "create building", building_name, floor_name, image_name, false, true
		else
			include_examples "create building", "BUILDING - TEST", floor_name, image_name, false, false
		end
	end
	include_examples "delete all floorplans from the grid"
end