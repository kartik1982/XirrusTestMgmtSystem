require_relative "../local_lib/dashboard_tiles_lib.rb"
##############################################################################################################################################
#############TEST CASE: Application Description for Widget Top Application - Top Application Category - Top Client Drill-down#################
##############################################################################################################################################
describe "********** TEST CASE: Application Description for Widget Top Application - Top Application Category - Top Client Drill-down **********" do
  #create widget
  include_examples "create new tile", "US XMSC-222-1"
  include_examples "add a widget", "Top Clients (by Usage)", false
  include_examples "edit widget change period", "Top Clients (by Usage)", "Last 30 Days"
  include_examples "edit widget change view type", "Top Clients (by Usage)", "bar"
  include_examples "Verify Application description for Top Application", "Top Clients (by Usage)"
  include_examples "create new tile", "US XMSC-222-2"
  include_examples "add a widget", "Top Applications (by Usage)", false
  include_examples "add a widget", "Top Application Categories (by Usage)", false
  include_examples "edit widget change period", "Top Applications (by Usage)", "Last 30 Days"
  include_examples "edit widget change period", "Top Application Categories (by Usage)", "Last 30 Days"
  include_examples "Verify Application description for Top Application", "Top Applications (by Usage)"
  include_examples "Verify Application description for Top Application", "Top Application Categories (by Usage)"  
  #Delete Widget
  include_examples "delete a certain tile", "US XMSC-222-1"
  include_examples "delete a certain tile", "US XMSC-222-2"
end