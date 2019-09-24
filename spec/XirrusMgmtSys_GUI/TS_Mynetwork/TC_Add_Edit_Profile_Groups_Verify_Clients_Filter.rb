require_relative "./local_lib/clients_lib.rb"
require_relative "./local_lib/groups_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_Profile/local_lib/profile_lib.rb"
###########################################################################################################
############TEST CASE: Test the MY NETWORK area - CLIENTS TAB - 'PROFILE/GROUP' FILTER#####################
###########################################################################################################
describe "********** TEST CASE: Test the MY NETWORK area - CLIENTS TAB - 'PROFILE/GROUP' FILTER **********" do

  include_examples "go to groups tab"
  include_examples "delete all groups from the grid"

  group_name = "Group: #{UTIL.ickey_shuffle(9)}"
  group_description = "TEST Description " + UTIL.ickey_shuffle(9) + " for the Group named: #{group_name}"

  include_examples "add a group", group_name, group_description, ""

  include_examples "delete all profiles from the grid"

  profile_name = "Profile: #{UTIL.ickey_shuffle(9)}"
  group_description = "TEST Description " + UTIL.ickey_shuffle(9) + " for the Profile named: #{profile_name}"

  include_examples "create profile from header menu", profile_name, group_description, false

  profile_groups_entries = [profile_name, group_name]

  include_examples "go to mynetwork clients tab"
  include_examples "verify profile group dropdown entries", profile_groups_entries

  include_examples "go to groups tab"

  group_name_new = group_name + " Edited"

  edit_values_hash = Hash["Group Name" => group_name_new, "Group Description" => group_description , "Group AP(s)" => nil]

  include_examples "edit group", "Grid view", group_name, edit_values_hash

  profile_name_new = profile_name + " Edited"
  include_examples "rename a profile", profile_name, profile_name_new

  profile_groups_entries = [profile_name_new, group_name_new]

  include_examples "go to mynetwork clients tab"
  include_examples "verify profile group dropdown entries", profile_groups_entries
end
