require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
#######################################################################################################################
##############TEST CASE: MSP - ENVIRONMENT PREPARATION - ENSURE NO AP IS 'OUT OF SERVICE'###########################
#######################################################################################################################
describe "********** TEST CASE: MSP - ENVIRONMENT PREPARATION - ENSURE NO AP IS 'OUT OF SERVICE' **********" do

  include_examples "go to commandcenter"
  if $the_environment_used == "test01"
    array_serial_numbers = ["AUTOXR320CHROME001FIRST", "AUTOXR320CHROME002FIRST", "AUTOXR320CHROME003FIRST", "AUTOXR320CHROME004FIRST", "AUTOXR320CHROME005FIRST", "AUTOX2120CHROME006FIRST", "AUTOX2120CHROME007FIRST", "AUTOX2120CHROME008FIRST", "AUTOX2120CHROME009FIRST", "AUTOX2120CHROME010FIRST", "AUTOXR620CHROME011FIRST", "AUTOXR620CHROME012FIRST", "AUTOXR520CHROME013FIRST"]
  elsif $the_environment_used == "test03"
    array_serial_numbers = ["AUTOXR320CHROME001FIRST", "AUTOXR320CHROME002FIRST", "AUTOXR320CHROME003FIRST", "AUTOXR320CHROME004FIRST", "AUTOXR320CHROME005FIRST", "AUTOX2120CHROME006FIRST", "AUTOX2120CHROME007FIRST", "AUTOX2120CHROME008FIRST", "AUTOX2120CHROME009FIRST", "AUTOX2120CHROME010FIRST", "AUTOXR620CHROME011FIRST", "AUTOXR620CHROME012FIRST", "AUTOXR520CHROME013FIRST"]
  end
  array_serial_numbers.each do |ap_sn|
    include_examples "verify certain ap is not out of service", ap_sn
  end

end