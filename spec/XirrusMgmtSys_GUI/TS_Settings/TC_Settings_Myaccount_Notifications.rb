require_relative "../TS_MSP/local_lib/msp_lib.rb"
require_relative "./local_lib/settings_lib.rb"
#############################################################################################
##############TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB#############################
#############################################################################################
describe "********** TEST CASE: SETTINGS AREA - PROVIDER MANAGEMENT TAB **********" do

	include_examples "go to commandcenter"
  include_examples "ceanup on environment", Array["Adrian-Automation-Chrome","Adrian-Automation-Chrome-Fourth"], "Dinte"
	include_examples "create Domain", "Access Points lost connectivity"
	include_examples "create Domain", "Profile Access Points lost connectivity"
	include_examples "create Domain", "Station Count"
	include_examples "create Domain", "DHCP Failure"

	include_examples "scope to tenant", "Access Points lost connectivity"
	include_examples "use notifications default settings", "No"
	include_examples "test my account specific notification", "No", "Access Point lost connectivity", "Email", "Check"
  	include_examples "test my account specific notification", "No", "Access Point lost connectivity", "SMS", "Check"

  	include_examples "scope to tenant", "Profile Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Access Points lost connectivity"
  	include_examples "test my account specific notification", "No", "Profile Access Point lost connectivity", "Email", "Check"
  	include_examples "test my account specific notification", "No", "Profile Access Point lost connectivity", "SMS", "Check"

  	include_examples "scope to tenant", "Station Count"
  	include_examples "verify notifications default settings domains", "Yes", "Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Profile Access Points lost connectivity"
  	include_examples "test my account specific notification", "No", "Station Count", "Email", "Check"
  	include_examples "test my account specific notification", "No", "Station Count", "SMS", "Check"

  	include_examples "scope to tenant", "DHCP Failure"
  	include_examples "verify notifications default settings domains", "Yes", "Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Profile Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Station Count"
  	include_examples "test my account specific notification", "Yes", "DHCP Failure", "Email", "Check"

  	include_examples "scope to tenant", "Access Points lost connectivity"
  	include_examples "use notifications default settings", "Yes"
  	include_examples "verify notifications default settings domains", "No", "Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Profile Access Points lost connectivity"
  	include_examples "verify notifications default settings domains", "Yes", "Station Count"
  	include_examples "verify notifications default settings domains", "Yes", "DHCP Failure"

  	include_examples "go to commandcenter"
  	include_examples "delete Domain", "Access Points lost connectivity"
  	include_examples "delete Domain", "Profile Access Points lost connectivity"
  	include_examples "delete Domain", "Station Count"
  	include_examples "delete Domain", "DHCP Failure"

end