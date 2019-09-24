require_relative "../local_lib/dashboard_tiles_lib.rb"
############################################################################################################################################################
################TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - CLIENTS OVER TIME - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE######################
############################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - CLIENTS OVER TIME - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "Clients (over Time)"
	include_examples "add a widget", "Clients (over Time)", false
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Clients (over Time)", string
	end
	include_examples "delete a certain widget", "Clients (over Time)", false
	include_examples "delete a certain tile", "Clients (over Time)"
end