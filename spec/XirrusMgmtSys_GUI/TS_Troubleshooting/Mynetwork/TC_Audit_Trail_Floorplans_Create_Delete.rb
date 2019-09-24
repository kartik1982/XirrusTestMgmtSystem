require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/floorplans_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
######################################################################################################################
#############TEST CASE: Test the MY NETWORK area - FLOORPLANS TAB - CREATE, EDIT and DELETE###########################
######################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - FLOORPLANS TAB - CREATE, EDIT and DELETE **********"  do

		building_name = "BUILDING - " +  UTIL.ickey_shuffle(3)
		floor_name = "Floor 1" #+ XMS.ickey_shuffle(1)
		image_name = "/xirrus.png"

		  include_examples "set timezone area to local"

	include_examples "create building", building_name, floor_name, image_name, false, false
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Building: "+building_name], 1
	include_examples "perform action verify audit trail", "CREATE", Array["Building: "+building_name, "Floor Plan: "+floor_name], 2

	include_examples "delete building from tile", building_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Building: "+building_name], 1

end
