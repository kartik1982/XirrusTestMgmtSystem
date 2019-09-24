require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../environment_variables_library.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
##########################################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD#################
##########################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - DASHBOARD TAB - Create a new domain and verify it on the DASHBOARD **********"  do
	domain_name = "Troubleshooting Domain"
	first_ap_sn = return_proper_value_based_on_the_used_environment($the_environment_used, "troubleshooting/msp/arrays", "")

	include_examples "go to commandcenter"
	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"
	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name
	include_examples "verify domain on dashboard", true, domain_name, "good", "", ""
	include_examples "only assign array to domain", first_ap_sn, domain_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Tenant: " + domain_name, "Access Point: " + first_ap_sn], 1
	include_examples "go to commandcenter"
	include_examples "only unassign array to domain", first_ap_sn, domain_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Tenant: " + "Adrian-Automation-Chrome-Fourteenth", "Access Point: " + first_ap_sn], 1
	include_examples "go to commandcenter"
	include_examples "delete Domain", domain_name
end


