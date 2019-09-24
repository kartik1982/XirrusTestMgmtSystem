require_relative "../local_lib/groups_lib.rb"
require_relative "../../environment_variables_library.rb"
########################################################################################################################
##################TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD GROUPS THEN VERIFY SEARCH###########################
########################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD GROUPS THEN VERIFY SEARCH **********" do # Created on : 26/04/2017

    include_examples "go to groups tab"
    include_examples "delete all groups from the grid"

  group_names = ["No APs copied", "Copy only one AP", "No APs copied 2", "ALL COPIED", "No APs copied 3", "No APs copied 4", "No APs copied 5"]
  group_descriptions = ["TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: Copy only one AP", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied 2", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: ALL COPIED", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied 3", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied 4", "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: No APs copied 5"]
  group_access_points = Hash[0 => "", 1 => "Auto-XR320-3", 2 => "", 3 => "Copy All", 4 => "", 5 => "", 6 => ""]

    group_names.each_with_index do |group_name, i|
      include_examples "add a group", group_name, group_descriptions[i], group_access_points[i]
    end

  tile_elements = Hash["Status" => ["good", "warning", "good", "warning", "good", "good", "good"], "Reason" => [nil, "reason0", nil, "reason0", nil, nil, nil], "Warning Message" => [nil, "Site Down", nil, "Site Down", nil, nil, nil,]]
  tile_elements_detailed_view = Hash["Status" => ["OK", "Critical", "OK", "Critical", "OK", "OK", "OK"], "Icon" => ["dash_arrays", "AP_warning_grey", "dash_arrays", "AP_warning_grey", "dash_arrays", "dash_arrays", "dash_arrays"], "APs" => ["0 APs", "Site Down", "0 APs", "Site Down", "0 APs", "0 APs", "0 APs"]]

  group_names.each_with_index do |group_name, i|
    include_examples "verify group tile elements", group_name, tile_elements["Status"][i], tile_elements["Reason"][i], tile_elements["Warning Message"][i]
    include_examples "verify dashboard domain detailed view", "AP Groups", group_name, tile_elements_detailed_view["Status"][i], tile_elements_detailed_view["Icon"][i], tile_elements_detailed_view["APs"][i]
  end

  change_view_type = [true, false]
  what_view_type = ["Tile", "Grid"]
  search_hash = Hash["Search criteria" => ["Copy only one AP", "No APs copied", "ALL COPIED", "NOT FOUND"], "Search count" => [1,5,1,0]]

  what_view_type.each do |view|
    search_hash["Search criteria"].each_with_index do |value, i|
      include_examples "change the view type", view
      include_examples "verify groups search", view, value, search_hash["Search count"][i], change_view_type.sample
    end
  end

end