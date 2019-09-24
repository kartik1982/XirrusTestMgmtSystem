require_relative "../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "./local_lib/guidedtour_lib.rb"
##########################################################################
##############TEST CASE: Test the GUIDED TOUR area########################
##########################################################################
describe "********** TEST CASE: Test the GUIDED TOUR area **********" do

	tenant_name = "Tenant for Guided Tour " + UTIL.ickey_shuffle(9)
  profile_name = "Profile for Guiedd Tour " + UTIL.ickey_shuffle(9)

  include_examples "go to commandcenter"
  include_examples "create Domain", tenant_name
  include_examples "manage specific domain", tenant_name
  include_examples "run guided tour", profile_name, profile_name
  include_examples "go to commandcenter"
  include_examples "delete Domain", tenant_name
end



