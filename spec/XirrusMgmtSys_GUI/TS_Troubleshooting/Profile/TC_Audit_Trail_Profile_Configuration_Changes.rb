require_relative "../local_lib/troubleshooting_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profile/local_lib/policies_lib.rb"
require_relative "../../TS_Profile/local_lib/general_lib.rb"
require_relative "../../TS_Profile/local_lib/admin_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Profile/local_lib/ap_lib.rb"
require_relative "../../TS_General/local_lib/localized_time_display_lib.rb"
#############################################################################################################
################TEST CASE: Test the TROUBLESHOOTING area - AUDIT TRAIL area#################################
#############################################################################################################
describe "********** TEST CASE: Test the TROUBLESHOOTING area - AUDIT TRAIL area **********" do
	profile_name = "Troubleshooting_" + UTIL.ickey_shuffle(2)

  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, "Profile description", false
  include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["Profile: "+profile_name], 1

  	rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
	include_examples "go to profile", profile_name
	include_examples "create a rule for any policy", "Device Policy", "Car", "Car", "All Car Types", "application", rule_name, true, "block", "7", "ICMP", "IRC", "Any", "Any", true, "", "Games", "All Games Apps"
	include_examples "search for rule and verify it", rule_name, "application", "block", "7", "Games", "All Games Apps", "", "", true, false, false, ""
  include_examples "go to the troubleshooting area"
  include_examples "perform action verify audit trail", "UPDATE", Array["Admin: ","Profile: "+profile_name], 1
	include_examples "perform action verify audit trail", "UPDATE", Array["Profile: "+profile_name], 2

	include_examples "delete profile from tile", profile_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Profile: "+profile_name], 1
end