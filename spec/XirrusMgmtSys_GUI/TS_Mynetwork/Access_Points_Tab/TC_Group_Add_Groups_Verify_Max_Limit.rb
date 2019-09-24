require_relative "../local_lib/groups_lib.rb"
require_relative "../../environment_variables_library.rb"
########################################################################################################################
##################TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD GROUPS THEN VERIFY SEARCH#############################
#######################################################################################################################
describe "********** TEST CASE: MY NETWORK AREA - GROUPS TAB - ADD GROUPS THEN VERIFY SEARCH **********" do 

    include_examples "go to groups tab"
    include_examples "delete all groups from the grid"

  group_name = "Random Group name "
  group_description = "TEST Description " + UTIL.ickey_shuffle(9)

  8.times do |i|
    if i == 2
      ap = "Copy All"
    elsif i > 6
      ap = "Auto-XR320-3"
    else
      ap = ""
    end
    include_examples "add a group", group_name + UTIL.ickey_shuffle(9), group_description, ap
  end

  include_examples "change the view type", "Tile"
  include_examples "verify add button properly disbled"
  include_examples "change the view type", "Grid"
  include_examples "verify add button properly disbled"

  include_examples "delete all groups from the grid"

end