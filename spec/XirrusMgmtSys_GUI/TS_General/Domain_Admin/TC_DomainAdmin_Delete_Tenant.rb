require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB######################################################
##############################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do

	original_tenant_name = "general-msp-automation-domain-admin"
	tenant_name = "Domain Admin Tenant To be deleted child"

	include_examples "go to commandcenter"

	include_examples "go to specific tab", "Users"

	email = "general+automation+domain+admin@xirrus.com"
	action = "Add to Account"
	role = "Domain Admin"
	include_examples "edit administrator from administrators tab", email, action, original_tenant_name, role

	include_examples "delete Domain", tenant_name

end