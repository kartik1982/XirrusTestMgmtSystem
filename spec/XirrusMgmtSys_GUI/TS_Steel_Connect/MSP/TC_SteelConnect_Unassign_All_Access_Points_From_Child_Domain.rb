require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../environment_variables_library.rb"
##################################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - ONLY UNASSIGN ALL APs TO A CHILD DOMAIN################
##################################################################################################################################
  

describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB - ONLY UNASSIGN ALL APs TO A CHILD DOMAIN **********"  do
  tenant_name = return_proper_value_based_on_the_used_account($the_user_used, "msp/assign_all & unassign_all", nil)
  include_examples "go to commandcenter"
  include_examples "assign and Unassign several arrays to a domain", tenant_name, "Unassign"

end
