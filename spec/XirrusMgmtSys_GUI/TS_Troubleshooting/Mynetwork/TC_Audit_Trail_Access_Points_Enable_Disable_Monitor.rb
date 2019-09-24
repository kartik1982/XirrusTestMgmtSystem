require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
################################################################################################################################################
##############TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - ASSIGN and then UNASSIGN and AP to and from a PROFILE#################
################################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - ASSIGN and then UNASSIGN and AP to and from a PROFILE **********"  do

	ap_name = "Romania-X620-Auto"
	  if $the_environment_used == "test03"
          ap_sn = "X306519043B60"
    elsif $the_environment_used == "test01"
          ap_sn = "X20641902ADDC"
    end

	include_examples "set timezone area to local"
	include_examples "ap monitor configurations", ap_sn, "off"

	monitor_state = "on (timeshare)"
	include_examples "ap monitor configurations", ap_sn, monitor_state

	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Access Point: "+ap_sn], 1

	monitor_state = "off"
	include_examples "ap monitor configurations", ap_sn, monitor_state

	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Access Point: "+ap_sn], 1

end
