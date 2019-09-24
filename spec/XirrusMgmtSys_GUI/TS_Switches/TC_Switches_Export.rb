require_relative "./local_lib/switches_lib.rb"
#############################################################################################################
##############TEST CASE: Swtich Export - Test switch export into csv file###################################
#############################################################################################################
describe "********** TEST CASE: Swtich Export - Test switch export into csv file **********" do
  verify_columns=["Hostname", "Serial Number", "Model", "Location", "Profile", "Alerts","Status", "Online","Ip Address","Gateway","Netmask", "Power Budget","Power Consumption","Last Activation"]
  verify_switches=["BBBBCCDD00B1","BBBBCCDD00B2","BBBBCCDD00B3","BBBBCCDD00B4","BBBBCCDD00B5","BBBBCCDD00B6","BBBBCCDD00B7","BBBBCCDD00B8","BBBBCCDD00B9","BBBBCCDD00BA","BBBBCCDD00BB","BBBBCCDD00BC", "BBBBCCDD00BD","BBBBCCDD00BE","BBBBCCDD00B0"]
  
  include_examples "Export Switches from Switch tab", verify_columns, verify_switches
  
end