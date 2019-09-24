require_relative "../local_lib/groups_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
################################################################################################################################
#############TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EXPORT then DELETE GROUPS##########################################
################################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD, EXPORT then DELETE GROUPS **********" do # Created on : 26/04/2017
    include_examples "set timezone area to local"
    include_examples "go to groups tab"
    include_examples "delete all groups from the grid"

  group_names = ["No APs copied", "Copy only one AP", "Copy 3 APs"]
  group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy 3 APs"]
  group_access_points = Hash[0 => "", 1 => "Auto-XR320-3", 2 => ["Auto-XR320-1", "Auto-X2-120-1", "Auto-XR520-1"]]


    group_names.each_with_index do |group_name, i|
      include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
    end

    verified_parameters = Hash["Lines" => ["Group Name,Online APs,Offline APs,Out-of-Service APs,Total APs", "\"No APs copied\",\"0\",\"0\",\"0\",\"0\"", "\"Copy only one AP\",\"0\",\"1\",\"0\",\"1\"", "\"Copy 3 APs\",\"0\",\"3\",\"0\",\"3\""]]

    group_names.each_with_index do |group_name, i|
      group_verify = [Hash["Access Point Count" => "0", "Description" => group_descriptions[i], "Status" => "OK"], Hash["Access Point Count" => "1", "Description" => group_descriptions[i], "Status" => "Critical: 1 access point down"], Hash["Access Point Count" => "3", "Description" => group_descriptions[i], "Status" => "Critical: 3 access points down"]]
      include_examples "verify group", group_name, group_verify[i]
    end

    include_examples "export msp domains groups", verified_parameters

    include_examples "delete all groups from the grid"

end