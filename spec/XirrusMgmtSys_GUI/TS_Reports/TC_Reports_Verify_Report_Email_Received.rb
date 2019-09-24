require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS##############################################################
################################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS **********" do

  	report_name = "Report - Email - Non-Recurring - Email Verification"
  	subject = "Attached is your requested report:"
  	user_email = "report_non_recurring@testqa.com"
  	description = " - Xirrus Management System Dear Customer, Please find the report Report - Email - Non-Recurring - Email Verification attached to this email. This is a report email from Xirrus Management System (XMS)."

	include_examples "launch new browser window and verify report email received", user_email, subject, report_name, description, "Emailed Report"

end

