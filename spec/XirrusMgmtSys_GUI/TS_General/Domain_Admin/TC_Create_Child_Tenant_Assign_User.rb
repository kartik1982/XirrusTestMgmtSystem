require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB#####################################################
##############################################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do

	original_tenant_name = "general-msp-automation-domain-admin"
	tenant_name = "Domain Admin Tenant To be deleted child"
	email = "general+automation+domain+admin@xirrus.com"
	action = "Add to Account"
	role = "Domain Admin"

	include_examples "go to commandcenter"
	include_examples "create Domain", tenant_name

	include_examples "go to specific tab", "Users"

	action = "Add to Account"
	include_examples "edit administrator from administrators tab", email, action, tenant_name, role

	action = "Delete"
	include_examples "edit administrator from administrators tab", email, action, original_tenant_name, ""

end