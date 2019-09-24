require_relative "../local_lib/groups_lib.rb"
require_relative "../local_lib/ap_lib.rb"
####################################################################################################
################TEST CASE: MY NETWORK AREA - GROUPS TAB - GENERAL FEATURES##########################
####################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - GENERAL FEATURES **********" do # Created on : 26/04/2017
	include_examples "go to groups tab"
	include_examples "delete all groups from the grid"
	include_examples "restore view to default", "Groups"
  include_examples "groups tab general features"
	include_examples "verify add new group edit group modal", "New Group", "", "", "", true
end