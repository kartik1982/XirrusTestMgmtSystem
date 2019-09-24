require_relative "../local_lib/dashboard_tiles_lib.rb"
#################################################################################################################################################################
############TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - DATA THROUGHPUT FOR ACCESS POINTS - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE################
#################################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - DATA THROUGHPUT FOR ACCESS POINTS - CREATE, CHANGE VIEW TYPE, PERIOD, DELETE **********" do
	include_examples "create new tile", "DATA THROUGHPUT FOR ACCESS POINTS"
	include_examples "add a widget", "Data Throughput (for Access Points)", false
	for string in ["Last 30 Days", "Last Hour", "Last 7 Days", "Last 24 Hours"] do 
		include_examples "edit widget change period", "Data Throughput (for Access Points)", string
	end
	include_examples "delete a certain widget", "Data Throughput (for Access Points)", false
	include_examples "delete a certain tile", "DATA THROUGHPUT FOR ACCESS POINTS"
end