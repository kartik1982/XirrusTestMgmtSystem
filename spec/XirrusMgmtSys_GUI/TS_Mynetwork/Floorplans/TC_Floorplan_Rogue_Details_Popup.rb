require_relative "../local_lib/floorplans_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
############################################################################################################################
###############TEST CASE: Test MY NETWORK area - FLOOR PLANS - VERIFY Rogue details pop-up panel on FLOORPLAN###############
############################################################################################################################
describe "********** TEST CASE: Test MY NETWORK area - FLOOR PLANS - VERIFY Rogue details pop-up panel on FLOORPLAN **********" do
  
if $the_environment_used == "test01"
  building_name="Romania 3 APs (AOS)"
elsif $the_environment_used == "test03"
   building_name="3 APs Buildinggggg"
end
  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Mainline"
  include_examples "Verify Rogue deatils pop-up on floor plan", building_name
end