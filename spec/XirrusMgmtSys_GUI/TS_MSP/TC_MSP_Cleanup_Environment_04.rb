require_relative "./local_lib/msp_lib.rb"
##################################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - CLEANUP on the environment#################################################
##################################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - CLEANUP on the environment **********"  do
	include_examples "go to commandcenter"
	include_examples "ceanup on environment", Array["Adrian-Automation-Chrome","Adrian-Automation-Chrome-SELF-OWNED-DOMAIN","Adrian-Automation-Firefox","Adrian-Automation-Edge","Adrian-Automation-InternetExplorer", "general-msp-automation-domain-admin", "general-automation-domain-admin"], "Dinte"
end