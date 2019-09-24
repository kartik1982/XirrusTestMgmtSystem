require_relative "../local_lib/analytics_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/groups_lib.rb"
require_relative "../local_lib/reports_lib.rb"
#############################################################################################################
##############TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES##############################################
#############################################################################################################
describe "********** TEST CASE: REPORTS - ANALYTICS - GENERAL FEATURES **********" do # Created on: 05/04/2017

  #Generate Analytic Report for - "Number of Visitors"
	vname = "Number of Visitors"
	type_of_data = "Number of Visitors"
	group = "All Access Points"
	date_from = "5/14/2017"
	date_to = "5/18/2017" 
	expected_data = Hash["Visitors" => "0", "Visits" => "0", "Median Visit" => nil]

	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, false
	include_examples "verify widget", vname, type_of_data, group, date_from, date_to, expected_data
	include_examples "verify analytics landing page", false, 1

  #Generate Analytic Report for - "Avg. Dwell Time"
	vname = "Avg. Dwell Time"
	type_of_data = "Avg. Dwell Time"
	group = "All Access Points"
  date_from = "4/14/2017"
  date_to = "4/18/2017" 
	expected_data = Hash["Visitors" => nil, "Visits" => nil, "Median Visit" => "0 seconds"]
	
	include_examples "add a visualization widget", vname, type_of_data, group, date_from, date_to, true, false
  include_examples "verify widget", vname, type_of_data, group, date_from, date_to, expected_data
  include_examples "verify analytics landing page", false, 2
  
  #send email Analytic report
  report_name = "analytics"
  description = " - Xirrus Management System Dear Customer, Please find the report Report - Email - Non-Recurring - Email Verification attached to this email. This is a report email from Xirrus Management System (XMS)."
  user_email = "analytic_report@testqa.org"
  subject = "Attached is your requested report:"
  
  include_examples "go to analytics area"
  include_examples "send email analytic report", user_email

  #verify Analytic report email received 
  include_examples "launch new browser window and verify report email received", user_email, subject, report_name, description, "Emailed Report"

end