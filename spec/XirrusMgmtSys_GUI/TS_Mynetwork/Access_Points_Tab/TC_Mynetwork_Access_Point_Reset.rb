require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
######################################################################################################################
#################TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - RESET AN ACCES POINT########
######################################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test the ACCESS POINTS tab - ACCESS POINT - RESET AN ACCES POINT **********" do
	access_points_hash = Hash["BBBBCCDD0040" => "Auto-XR320-1", "BBBBCCDD0041" => "Auto-XR320-2", "BBBBCCDD0042" => "Auto-XR320-3", "BBBBCCDD0043" => "Auto-XR320-4", "BBBBCCDD0044" => "Auto-XR320-5", "BBBBCCDD0045" => "Auto-X2-120-1", "BBBBCCDD0046" => "Auto-X2-120-2", "BBBBCCDD0047" => "Auto-X2-120-3", "BBBBCCDD0048" => "Auto-X2-120-4", "BBBBCCDD0049" => "Auto-X2-120-4", "BBBBCCDD004A" => "Auto-X2-120-5", "BBBBCCDD004B" => "Auto-XR620-1", "BBBBCCDD004C" => "Auto-XR620-2", "BBBBCCDD004D" => "Auto-XR520-1", "BBBBCCDD004E" => "Auto-XR520-2", "BBBBCCDD004F" => "Auto-XR520-3"]
  ["Yes", "No"].each do |connectivity|
    profile_name = "RESET an AP"

    include_examples "delete all profiles from the grid"
    include_examples "create profile from tile", profile_name, "TEST PROFILE - Created to verify the RESET of an AP", false
    include_examples "go to mynetwork access points tab"
    include_examples "assign first access point to profile", profile_name
    include_examples "reset an ap", connectivity, profile_name
    include_examples "delete profile from tile", profile_name
  end
  include_examples "go to mynetwork access points tab"
  access_points_hash.each do |key, value|
    include_examples "change the hostname value", key, value
  end

end