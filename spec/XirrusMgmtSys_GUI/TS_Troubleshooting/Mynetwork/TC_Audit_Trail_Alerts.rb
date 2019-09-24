require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/alerts_lib.rb"
require_relative "../../environment_variables_library.rb"
#########################################################################################################################################
############TEST CASE: Test the MY NETWORK area - ALERTS TAB - ACKNOWLEDGE and UNACKNOWLEDGE#############################################
#########################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ALERTS TAB - ACKNOWLEDGE and UNACKNOWLEDGE **********"  do
    if $the_environment_used == "test03"
          ap_sn = "X306519043B60"
    elsif $the_environment_used == "test01"
          ap_sn = "X20641902ADDC"
    end
	tenant_name_and_count = return_proper_value_based_on_the_used_environment($the_environment_used, "troubleshooting/my_network/audit_trail_alerts.rb", "")

	include_examples "change to tenant", tenant_name_and_count[0], tenant_name_and_count[1]

  include_examples "acknowledge & unacknowledge alerts", tenant_name_and_count[2]

  include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Access Point: "+ap_sn], 1
	include_examples "perform action verify audit trail", "UPDATE", Array["Access Point: "+ap_sn], 2

end
