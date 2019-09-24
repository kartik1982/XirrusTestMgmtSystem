require_relative "../local_lib/floorplans_lib.rb"
###########################################################################################################
###############TEST CASE: Test the MY NETWORK area - FLOOR PLANS - CREATE, DELETE#########################
###########################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - FLOOR PLANS - CREATE, DELETE **********" do

		include_examples "delete all floorplans from the grid"

	building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
	floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)
	image_name = "/xirrus.png"
		include_examples "create building", building_name, floor_name, image_name, 7, true

		8.downto(3) do |i|
			method_array = [i, "descending", i-1]
			include_examples "delete first last floorplans", building_name, method_array[0], method_array[1], method_array[2]
		end

	building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
	floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)
		include_examples "create building", building_name, floor_name, image_name, 12, true

	building_name = "BUILDING - " + UTIL.ickey_shuffle(3)
	floor_name = "FLOOR - " + UTIL.ickey_shuffle(1)

		include_examples "create building", building_name, floor_name, image_name, 3, true

	method_array = [4, "descending", 3]
		include_examples "delete first last floorplans", building_name, method_array[0], method_array[1], method_array[2]

	method_array = [3, "ascending", 2]
		include_examples "delete first last floorplans", building_name, method_array[0], method_array[1], method_array[2]
		include_examples "delete all floorplans from the grid"
end