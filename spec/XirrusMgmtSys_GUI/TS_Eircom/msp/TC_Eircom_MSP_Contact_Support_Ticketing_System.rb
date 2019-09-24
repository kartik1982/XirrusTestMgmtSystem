require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
require_relative "../../TS_General/local_lib/feedback_lib.rb"
require_relative "../../TS_Reports/local_lib/reports_lib.rb"

describe "********** TEST CASE: Test the COMMANDCENTER area - Settings - Command Center Support Email - AVAYA TENANT**********"  do

	domain_name = "EIRCOM Automation - MSP Contact Support Ticketing System Domain " + UTIL.ickey_shuffle(9)

	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name
	include_examples "go to settings then to tab", "Command Center"
	include_examples "verify support email features"
	include_examples "support email input", "testemail@domain.net", false, "Write"
	include_examples "support email input", "anothertest@test.org", false, "Write"
	include_examples "support email input", "", false, "Write"

	include_examples "go to settings then to tab", "My Account"
	include_examples "test support request to riverbed"
  include_examples "test feedback"

	include_examples "go to settings then to tab", "Command Center"
	include_examples "support email input", "mother@russia.ru", false, "Write"
	include_examples "go to settings then to tab", "My Account"
	include_examples "go to settings then to tab", "Command Center"
	include_examples "support email verify value", "mother@russia.ru"
	include_examples "support email input", "aaa", true, "Write"
	include_examples "support email input", "_*@test+test.com", true, "Write"
	include_examples "support email input", "testemail1testemail2testemail3testemail4testemail5@test.com", true, "Write"
	include_examples "support email input", "", false, "Copy"
	include_examples "support email input", "testemail@domain.co.uk", false, "Write"

	include_examples "go to commandcenter"
	include_examples "manage specific domain", domain_name
	include_examples "verify command center tab not present in settings"

	name = "Tester QA Name"
	phone = "+40730973335"
	text = "This is a test message to send to the SUPPORT AREA"
	include_examples "test support request", name, phone, text
  include_examples "test feedback"

  report_name = [domain_name, "Real Name: #{name}", "Telephone: #{phone}", "\n\n#{text}"]
  subject = "XMS-Cloud #{name} (#{domain_name})"
  user_email = "testemail@domain.co.uk"
  description = " - Customer #{domain_name} From adinte+automation+eircom+chrome@macadamian.com Real Name: #{name} Telephone: #{phone} URL: https://xcs"

	include_examples "launch new browser window and verify report email received", user_email, subject, report_name, description, "Support or Feedback"

	include_examples "go to commandcenter"
	include_examples "delete Domain", domain_name

	include_examples "go to settings then to tab", "Command Center"
	include_examples "support email input", "", false, "Copy"



end
