require_relative "../local_lib/analytics_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES############################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES **********" do # Created on: 05/04/2017

  #Go to Report Analytic area
  include_examples "go to analytics area"
  #Make sure user can select date range for 1 years
  vname = "Number of Visitors"
  type_of_data = "Number of Visitors"
  group = "All Access Points"
  date_from = "1/1/2017" 
  date_to = "12/31/2017" 
  expected_data = Hash["Visitors" => "0", "Visits" => "0", "Median Visit" => nil]
  #Make sure user can add 20 Widgets
  20.times do |i|
      include_examples "add a visualization widget", vname+"_"+i.to_s, type_of_data, group, date_from, date_to, true, false
      include_examples "verify widget", vname, type_of_data, group, date_from, date_to, expected_data
  end
  #Make sure no more than 20 widget can added	
  include_examples "go to analytics area"
	include_examples "verify 20 Widget added and no more new widget can add"
end