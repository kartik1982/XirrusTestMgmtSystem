require_relative "../../TS_Mynetwork/local_lib/clients_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../environment_variables_library.rb"
#######################################################################################################################
##############TEST CASE: Test the MY NETWORK area - CLIENTS TAB - BLOCK and UNBLOCK clients############################
#######################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - BLOCK and UNBLOCK clients **********"  do

	tenant_name = "1-Macadamian Child XR-620-Auto"
	if $the_environment_used == "test03"
          client_hostname = "HUAWEI_nova"
    elsif $the_environment_used == "test01"
          client_hostname = "Adrians-iPhone"
    end
	include_examples "change to tenant", tenant_name, 1
  
  action = "Blocked"
	include_examples "block unblock a certain client", client_hostname, action
	action = "Allowed"
	include_examples "block unblock a certain client", client_hostname, action
	action = "Blocked"
	include_examples "block unblock a certain client", client_hostname, action
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Client: "+client_hostname], 1
	action = "Allowed"
	include_examples "block unblock a certain client", client_hostname, action
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Client: "+client_hostname], 1
	include_examples "perform action verify audit trail", "UPDATE", Array["Client: "+client_hostname], 2
end


