require_relative "../local_lib/dashboard_tiles_lib.rb"
####################################################################################################################################################################
#############TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP APPLICATIONS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE########################
####################################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP APPLICATIONS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "TOP APPLICATIONS BY USAGE"
	include_examples "add a widget", "Top Applications (by Usage)", false
	for string in ["table", "bar", "pie"] do 
		include_examples "edit widget change view type", "Top Applications (by Usage)", string
	end	
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Top Applications (by Usage)", string
	end
	include_examples "delete a certain widget", "Top Applications (by Usage)", false
	include_examples "delete a certain tile", "TOP APPLICATIONS BY USAGE"
end