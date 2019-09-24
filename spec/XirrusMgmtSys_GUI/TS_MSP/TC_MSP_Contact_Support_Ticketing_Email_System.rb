require_relative "./local_lib/msp_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_General/local_lib/feedback_lib.rb"
require_relative "../TS_Reports/local_lib/reports_lib.rb"
#########################################################################################################################
############TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email############################
#########################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email **********"  do

  domain_name = "Automation - MSP Contact Support Ticketing System Domain " + UTIL.ickey_shuffle(9)
  include_examples "go to commandcenter"
  include_examples "create Domain", domain_name  
  include_examples "go to settings then to tab", "Command Center"
  include_examples "verify support email features"
  # Verify that MSP try to access Contact support redirect to Riverbed support when command center support email is NOT SET
  include_examples "support email input", "testemail@domain.net", false, "Write"
  include_examples "support email input", "", false, "Write"
  include_examples "test support request to riverbed"
  include_examples "test feedback"
  # Verify that MSP try to access Contact support redirect to Riverbed support when command center support email is SET
  include_examples "support email input", "testemail@domain.net", false, "Write"
  include_examples "test support request to riverbed"
  include_examples "test feedback"
  # Verify that Child tenant user access Contact support redirect to Riverbed support when Command Center support email is NOT SET
  include_examples "go to settings then to tab", "Command Center"
  include_examples "support email input", "", false, "Write"
  include_examples "go to commandcenter"
  include_examples "manage specific domain", domain_name
  include_examples "test support request to riverbed"
  include_examples "test feedback"
  # Verify that child tenant user access contact support send email to MSP Conatct Support email when Command center support email is SET
  include_examples "go to commandcenter"
  include_examples "go to settings then to tab", "Command Center"
  include_examples "support email input", "testemail@domain.net", false, "Write"
  include_examples "go to commandcenter"
  include_examples "manage specific domain", domain_name
  name = "Tester QA Name"
  phone = "+40730973335"
  text = "This is a test message to send to the SUPPORT AREA"
  include_examples "test support request", name, phone, text
  include_examples "test feedback"
  # Delete Domain created for testing
  include_examples "go to commandcenter"
  include_examples "delete Domain", domain_name  
end
