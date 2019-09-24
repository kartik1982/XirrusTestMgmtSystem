require_relative "../../environment_variables_library.rb"
require_relative "../local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################################################
##################TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - COMMAND LINE INTERFACE########################
#######################################################################################################################################
describe "********** TEST CASE: Test the SUPPORT MANAGEMENT area - ACCESS POINTS - ACTION - COMMAND LINE INTERFACE **********" do
	  if $the_environment_used == "test03"
          ap_sn = "X306519043B60"
    elsif $the_environment_used == "test01"
          ap_sn = "X20641902ADDC"
    end
	include_examples "go to support management"
	include_examples "search for an ap and perform an action", ap_sn, "Command Line Interface"
end