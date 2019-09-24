require_relative "../local_lib/ap_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
####################################################################################################################################
#################TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - EXPORTS#################################################
####################################################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - ACCESS POINTS TAB - EXPORTS **********" do

  tenant_name = "1-Macadamian Child XR-620-Auto"
  tenant_count = 1
  include_examples "set timezone area to local"
  
  include_examples "change to tenant", tenant_name , tenant_count
  include_examples "test exports", "Romania", "Incoherent string"

end