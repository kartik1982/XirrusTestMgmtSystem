require_relative "../local_lib/dashboard_tiles_lib.rb"
#############################################################################################################################################################
###############TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP CLIENTS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE###################
#############################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP CLIENTS BY USAGE - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "TOP CLIENTS BY USAGE"
	include_examples "add a widget", "Top Clients (by Usage)", false
	for string in ["clientsTable", "bar"] do 
		include_examples "edit widget change view type", "Top Clients (by Usage)", string
	end	
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Top Clients (by Usage)", string
	end
	include_examples "delete a certain widget", "Top Clients (by Usage)", false
	include_examples "delete a certain tile", "TOP CLIENTS BY USAGE"
end