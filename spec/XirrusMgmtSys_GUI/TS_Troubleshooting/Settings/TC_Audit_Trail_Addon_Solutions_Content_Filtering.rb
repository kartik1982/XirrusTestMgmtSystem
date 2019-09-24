require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
##############################################################################################################################
################TEST CASE: TROUBLESHOOTING AREA - ADD-ON SOLUTIONS TAB - VERIFY AUDIT TRAIL LOG##############################
##############################################################################################################################
describe "********** TEST CASE: TROUBLESHOOTING AREA - ADD-ON SOLUTIONS TAB - VERIFY AUDIT TRAIL LOG **********" do

  type_of_testing = "POSITIVE"

  include_examples "test content filtering settings","", "", type_of_testing
  include_examples "test content filtering settings", "2.2.2.2", "3.4.5.6", type_of_testing
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1

  include_examples "test content filtering settings", "", "", type_of_testing
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Add-ons: Third Party Configuration"], 1


end