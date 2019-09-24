require_relative "../local_lib/dashboard_tiles_lib.rb"
####################################################################################################################
#####################TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - APPLICATIONS DRILLDOWN###############
####################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - APPLICATIONS DRILLDOWN **********" do

	include_examples "create new tile", "US 4017"
	include_examples "add a widget", "Top Applications (by Usage)", false
	include_examples "edit widget change view type", "Top Applications (by Usage)", "pie"
	include_examples "edit widget change period", "Top Applications (by Usage)", "Last 30 Days"
	include_examples "edit widget top applications and use drill down for all applications", "Top Applications (by Usage)"

	include_examples "edit widget change view type", "Top Applications (by Usage)", "bar"
	include_examples "edit widget top applications and use drill down for all applications", "Top Applications (by Usage)"
	include_examples "edit widget change view type", "Top Applications (by Usage)", "table"
	include_examples "edit widget top applications and use drill down for all applications", "Top Applications (by Usage)"

	include_examples "delete a certain tile", "US 4017"
end