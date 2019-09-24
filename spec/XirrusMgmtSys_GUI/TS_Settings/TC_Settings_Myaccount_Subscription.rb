require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "./local_lib/settings_lib.rb"
#############################################################################################
##############TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB#############################
#############################################################################################
describe "********** TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB **********" do

    include_examples "test my account specific subscription", "System Maintenance", "Email", "Uncheck"
    include_examples "test my account specific subscription", "Expiring XMS License on Access Point", "Email", "Uncheck"
    include_examples "test my account specific subscription", "Expiring EasyPass", "Email", "Uncheck"
    
    include_examples "test my account specific subscription", "System Maintenance", "Email", "Check"
    include_examples "test my account specific subscription", "Expiring XMS License on Access Point", "Email", "Check"
    include_examples "test my account specific subscription", "Expiring EasyPass", "Email", "Check"
    
end