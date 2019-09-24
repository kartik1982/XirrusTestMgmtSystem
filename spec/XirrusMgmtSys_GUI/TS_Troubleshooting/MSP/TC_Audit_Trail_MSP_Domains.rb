require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
##################################################################################################################################
###########TEST CASE: TROUBLESHOOTING AREA - COMMAND CENTER - ADD, EDIT AND DELETE DOMAINS IN UI - VERIFY AUDIT TRAIL LOG#########
##################################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - COMMAND CENTER - ADD, EDIT AND DELETE DOMAINS IN UI - VERIFY AUDIT TRAIL LOG **********" do

	domain_name = "Automation Domains - TROUBLESHOOTING " + UTIL.ickey_shuffle(5)

	include_examples "go to commandcenter"
	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"
	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["Tenant: " + domain_name], 1

	new_domain_name = domain_name + " (edited)"
	include_examples "go to commandcenter"
	include_examples "edit a specific domain in the grid", domain_name, new_domain_name, nil
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Tenant: " + new_domain_name], 1

	include_examples "go to commandcenter"
	include_examples "delete Domain", new_domain_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Tenant: " + new_domain_name], 1

end


