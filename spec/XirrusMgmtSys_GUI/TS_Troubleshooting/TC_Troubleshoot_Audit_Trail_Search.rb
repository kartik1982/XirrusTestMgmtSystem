require_relative "./local_lib/troubleshooting_lib.rb"
#########################################################################################################
####################TEST CASE: TROUBLESHOOTING AREA - AUDIT TRAIL TAB - SEARCH BOX######################
#########################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - AUDIT TRAIL TAB - SEARCH BOX **********" do

	include_examples "go to the troubleshooting area"

	audit_details = ["Alert Notification: for DHCP Failure", "Profile: A", "Report: A", "Portal: A", "NO RESULT SHOULD BE DISPLAYED"]
	audit_details.each do |audit_detail|
		empty_search = false
		case audit_detail
			when "Alert Notification: for DHCP Failure"
				min_value = 1
				max_value = 1
			when "Profile: A", "Report: A", "Portal: A"
				min_value = 1
				max_value = 60
			when "NO RESULT SHOULD BE DISPLAYED"
				empty_search = true
		end
		include_examples "search for certain audit trail detail", audit_detail, "100", "50", min_value, max_value, empty_search
	end
end