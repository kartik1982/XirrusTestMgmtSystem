require_relative "../local_lib/dashboard_tiles_lib.rb"
###############################################################################################################################################################
################TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - DATA THROUGHPUT FOR CLIENTS - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE###############
###############################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - DATA THROUGHPUT FOR CLIENTS - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "Data Throughput (for Clients)"
	include_examples "add a widget", "Data Throughput (for Clients)", false
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Data Throughput (for Clients)", string
	end
	include_examples "delete a certain widget", "Data Throughput (for Clients)", false
	include_examples "delete a certain tile", "Data Throughput (for Clients)"
end