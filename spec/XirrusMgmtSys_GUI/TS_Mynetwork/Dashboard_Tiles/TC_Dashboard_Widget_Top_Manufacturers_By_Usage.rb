require_relative "../local_lib/dashboard_tiles_lib.rb"
##################################################################################################################################################################
###################TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP MANUFACTURERS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE################
##################################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP MANUFACTURERS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "TOP MANUFACTURERS BY USAGE"
	include_examples "add a widget", "Top Manufacturers (by Usage)", false
	for string in ["pie", "bar"] do 
		include_examples "edit widget change view type", "Top Manufacturers (by Usage)", string
	end	
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Top Manufacturers (by Usage)", string
	end
	include_examples "delete a certain widget", "Top Manufacturers (by Usage)", false
	include_examples "delete a certain tile", "TOP MANUFACTURERS BY USAGE"
end