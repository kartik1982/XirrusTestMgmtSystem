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
################TEST CASE: Test the TROUBLESHOOTING area - PROFILE READ-ONLY - AUDIT TRAIL area##############
#############################################################################################################
describe "********** TEST CASE: Test the TROUBLESHOOTING area - PROFILE READ-ONLY - AUDIT TRAIL area **********" do
	profile_name = "Troubleshooting " + UTIL.random_profile_name

	include_examples "set date time format to specific", "MM/DD/YYYY", "12 hour"

  include_examples "delete all profiles from the grid"
  include_examples "create read-only profile from header menu", profile_name, "", true
  include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "CREATE", Array["Profile: "+profile_name], 1

	include_examples "go to profile", profile_name
	include_examples "add access point to profile and verify name and sn", profile_name, "Auto-XR520-2","BBBBCCDD005E", true
	#include_examples "add access point to profile certain model" , profile_name, "XR320", "X2-120", true

	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "UPDATE", Array["Profile: "+profile_name,"Access Point: BBBBCCDD005E"], 1 #Array["Access Point: MACAUTO02", "Profile: "+profile_name]


	include_examples "delete profile from tile", profile_name
	include_examples "go to the troubleshooting area"
	include_examples "perform action verify audit trail", "DELETE", Array["Profile: "+profile_name], 1
end