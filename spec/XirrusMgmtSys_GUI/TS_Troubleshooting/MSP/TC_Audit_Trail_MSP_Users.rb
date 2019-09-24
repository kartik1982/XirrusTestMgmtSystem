require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
##################################################################################################################################
###########TEST CASE: TROUBLESHOOTING AREA - COMMAND CENTER - ADD, EDIT AND DELETE USER IN UI - VERIFY AUDIT TRAIL LOG#############
##################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - COMMAND CENTER - ADD, EDIT AND DELETE USER IN UI - VERIFY AUDIT TRAIL LOG **********" do

	domain_name = "Automation Domains - TROUBLESHOOTING " + UTIL.ickey_shuffle(5)
	number = UTIL.ickey_shuffle(3)
	first_name = "Tester"
	last_name = "Administrator Troubleshooting " + number
	email = "troubleshooting" + number + "@tester.ro"

	include_examples "go to commandcenter"
	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"
	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name

	include_examples "create Administrator from administrator tab", first_name, last_name, email, domain_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["User: " + email], 1

	include_examples "go to commandcenter"
	include_examples "delete a certain Administrator", first_name + " " + last_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["User: " + email], 1

	include_examples "go to commandcenter"
	include_examples "delete Domain", domain_name
end


