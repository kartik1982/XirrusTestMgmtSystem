require_relative "../local_lib/portal_lib.rb"
require_relative "../local_lib/users_lib.rb"
require_relative "../../TS_Portals/local_lib/portals_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Profile/local_lib/policies_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/ssids_lib.rb"
require_relative "../../TS_Settings/local_lib/settings_lib.rb"
######################################################################################################################
#############TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL GUESTS###################
######################################################################################################################
describe  "********** TEST CASE: PORTALS area - Test the ONBOARDING PORTAL - USERS TAB - ADD SEVERAL GUESTS **********" do

  domain_name = "Child Domain for Portal Second tab"
  portal_name = "ONBOARDING_PORTAL"
  portal_description = "Description text for the portal named " + portal_name
  portal_type = "onboarding"


  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Mainline"

  include_examples "verify portal list view tile view toggle"
  include_examples "create portal from header menu", portal_name, portal_description, portal_type

  username = "Name - "
  email = nil
  user_id = "22"
  note = UTIL.chars_255
  group = "Test Group 101"

  include_examples "add several users", portal_name, 2, username, email, user_id, note, group
  include_examples "verify onboarding users grid and slideout componets", "Mainline"

  include_examples "go to settings then to tab", "Firmware Upgrades"
  include_examples "change default firmware for new domains", "Technology"

  username = "Other Name - "
  email = "test@test.org"
  user_id = "33"
  note = UTIL.chars_255
  group = "Test Group 607"

  include_examples "add several users", portal_name, 5, username, email, user_id, note, group
  include_examples "verify onboarding users grid and slideout componets", "Technology"

  profile_name = "Test profile for Policies tab USER GROUP POLICY"
  profile_descriptiion = "Profile description for : " + profile_name
  include_examples "delete all profiles from the grid"
  include_examples "create profile from header menu", profile_name, profile_descriptiion, false

  include_examples "add profile ssid", profile_name, 'ssid'

  rule_name = "Rule_number_" + UTIL.ickey_shuffle(6)
  protocol = port = "ANY"
  source = destination = "Any"
  include_examples "create a rule for any policy", "User Group Policy", ["Test Group 101", "Use Dropdown"], "", "", "firewall", rule_name, true, "block", "2", protocol, port, source, destination, true, "QoS", "", ""
  include_examples "search for rule and verify it", rule_name, "firewall", "block", "2", protocol, port, source, destination, true, false, false, ""

  rule_name = "Rule_number_" + UTIL.ickey_shuffle(7)
  include_examples "create a rule for any policy", "User Group Policy", ["Test Group 607", "Use Dropdown"], "", "", "application", rule_name, false, "allow", "", "", "", "", "", false, "", "Games", "All Games Apps", "", ""
  include_examples "search for rule and verify it", rule_name, "application", "allow", "7", "Games", "All Games Apps", "", "", false, false, false, ""

  rule_name = "Rule_number_" + UTIL.ickey_shuffle(8)
  include_examples "create a rule for any policy", "User Group Policy", "UG", "", "", "application", rule_name, false, "allow", "", "", "", "", "", false, "", "Games", "All Games Apps", "", ""
  include_examples "search for rule and verify it", rule_name, "application", "allow", "7", "Games", "All Games Apps", "", "", false, false, false, ""

  username = "Name - "
  email = nil
  user_id = "22"
  note = UTIL.chars_255
  group = ["Test Group 607", "Use Dropdown"]
  include_examples "add several users", portal_name, 1, username, email, user_id, note, group

  file_name = "users_import_with_new_groups"
  include_examples "create csv file", file_name
  include_examples "import users", portal_name, file_name, false, 9

  include_examples "go to profile", profile_name

  rule_name = "Rule_number_" + UTIL.ickey_shuffle(8)
  include_examples "create a rule for any policy", "User Group Policy", ["NEW GROUP FROM IMPORT", "Use Dropdown"], "", "", "application", rule_name, false, "allow", "", "", "", "", "", false, "", "Proxy", "Tor", "", ""
  include_examples "search for rule and verify it", rule_name, "application", "allow", "7", "Proxy", "Tor", "", "", false, false, false, ""

end