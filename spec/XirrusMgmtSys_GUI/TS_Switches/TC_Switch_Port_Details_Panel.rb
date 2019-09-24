require_relative "./local_lib/switches_lib.rb"
#############################################################################################################
##############TEST CASE: MY NETWORK area - Test SWITCH Details and Port details panel#######################
#############################################################################################################
describe "********** TEST CASE: MY NETWORK area - Test SWITCH Details and Port details panel **********" do
  switches=[{switch_model: "XS-6012P", switch_serial: "BBBBCCDD00B1", switch_hostname: "Auto-Switch-XS-6012P-2"},{switch_model: "XS-6024MP", switch_serial: "BBBBCCDD00B7", switch_hostname: "Auto-Switch-XS-6024MP-3"},{switch_model: "XS-6048MP", switch_serial: "BBBBCCDD00BA", switch_hostname: "Auto-Switch-XS-6048MP-1"}]
  switches.each do |switch|    
    include_examples "General switch and port panel verification", switch[:switch_model], switch[:switch_serial], switch[:switch_hostname] 
  end   
end