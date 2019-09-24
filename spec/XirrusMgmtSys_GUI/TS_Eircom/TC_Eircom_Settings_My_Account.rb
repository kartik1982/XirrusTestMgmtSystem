require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/policies_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
###########################################################################################################################
#################TEST CASE: EIRCOM - Test the SETTINGS area - MY ACCOUNT TAB#############################################
###########################################################################################################################
describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - MY ACCOUNT TAB **********" do
	
	 include_examples "verify settings my account eircom"

end