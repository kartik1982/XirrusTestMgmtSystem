require_relative "./local_lib/eircom_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
require_relative "../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/lookfeel_lib.rb"
require_relative "../TS_Portal/local_lib/general_lib.rb"
require_relative "../TS_Settings/local_lib/settings_lib.rb"
require_relative "../TS_XMSE/local_lib/xmse_lib.rb"
#######################################################################################################################
#################TEST CASE: EIRCOM - Test the SETTINGS area - USERS TAB - CREATE USERS###############################
#######################################################################################################################

describe "********** TEST CASE: EIRCOM - Test the SETTINGS area - USERS TAB - CREATE USERS **********" do

	include_examples "change settings user accounts tab eircom create users", 1, "User", "None"
  include_examples "change settings user accounts tab eircom create users", 1, "Admin", "None"
  include_examples "change settings user accounts tab eircom create users", 1, "Read Only", "None"

  include_examples "change settings user accounts tab eircom create users", 1, "User", "Admin"
  include_examples "change settings user accounts tab eircom create users", 1, "Admin", "Admin"
  include_examples "change settings user accounts tab eircom create users", 1, "Read Only", "Admin"

  include_examples "delete all user accounts expect for those that include a certain string", "Dinte"

end