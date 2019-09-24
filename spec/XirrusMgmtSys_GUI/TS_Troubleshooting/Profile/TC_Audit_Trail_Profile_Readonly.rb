require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
#######################################################################################################################
##############TEST CASE: Test the TROUBLESHOOTING area - PROFILE READ-ONLY - AUDIT TRAIL area######################
#######################################################################################################################
describe "********** TEST CASE: Test the TROUBLESHOOTING area - PROFILE READ-ONLY - AUDIT TRAIL area **********" do
	profile_name = "Troubleshooting_" + UTIL.ickey_shuffle(2)

  	include_examples "create read-only profile from header menu", profile_name, "", true
  	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["Profile: "+profile_name], 1

	include_examples "delete profile from tile", profile_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Profile: "+profile_name], 1
end