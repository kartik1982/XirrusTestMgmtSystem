require_relative "../local_lib/dashboard_tiles_lib.rb"
#######################################################################################################################
##############TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP CLIENTS - BLOCK FROM DASHBOARD############
#######################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - DASHBOARD - TILES - TOP CLIENTS - BLOCK FROM DASHBOARD **********" do

	include_examples "create new tile", "US XMSC-1641"
	include_examples "add a widget", "Top Clients (by Usage)", false
	include_examples "edit widget change view type", "Top Clients (by Usage)", "bar"
	include_examples "edit widget change period", "Top Clients (by Usage)", "Last 30 Days"
	include_examples "get certain client 'trobuleshooting' 'view Details' and 'application drill'", "Top Clients (by Usage)"
	include_examples "delete a certain tile", "US XMSC-1641"
end