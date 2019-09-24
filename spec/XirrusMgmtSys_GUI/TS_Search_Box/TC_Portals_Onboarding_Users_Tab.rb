require_relative "./local_lib/search_box_lib.rb"
require_relative "../TS_Portals/local_lib/portals_lib.rb"
require_relative "../TS_Portal/local_lib/users_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"
#########################################################################################################
##############TEST CASE: Test the SEARCH BOX - All tabs that it appears on#############################
#########################################################################################################
describe "********** TEST CASE: Test the SEARCH BOX - All tabs that it appears on **********" do
  context "********** VERIFY PORTALS - ONBOARDING - USERS TAB **********" do
    decription_prefix = "portal description for "
    portal_type = "onboarding"
    portal_from_tile_name = "PORTAL - " + UTIL.ickey_shuffle(4) + " - tile"
    original_length = 0

    include_examples "scope to tenant", "Child Domain for Portal Second tab"

    include_examples "verify portal list view tile view toggle"
    include_examples "create portal from tile", portal_from_tile_name, decription_prefix + portal_from_tile_name, portal_type
    include_examples "go to portal guests tab", portal_from_tile_name
    include_examples "verify search empty"

    users_hash = return_users_hash_function

    used_user_names = []

    5.times do
        user_name = users_hash["User Names"].sample
        while used_user_names.include?(user_name) do
            user_name = users_hash["User Names"].sample
        end
        used_user_names << user_name
    end

    @used_user_groups = []
    @used_user_notes = []
    @used_user_ids = []

    used_user_names.each do |user_name|
        needed_index = users_hash["User Names"].index(user_name)
        user_email = users_hash["User Emails"][needed_index]
        user_note = users_hash["User Notes"][needed_index]
        @used_user_notes << user_note
        user_id = users_hash["User IDs"][needed_index]
        @used_user_ids << user_id
        used_group = users_hash["User Groups"].sample
        if used_group != nil
            @used_user_groups << used_group
        end


        include_examples "add user for onboarding", portal_from_tile_name, user_name, user_email, user_id, user_note, used_group, original_length, false, nil
        original_length = original_length+=1
     end

    include_examples "verify search", "athletics", "Jkkdsaonre231", false, false
    include_examples "verify search box tooltip", "Enter at least 3 characters. Search for Name, Group, User ID, UPSK, Note or RADIUS Auth Username."
    include_examples "verify search", used_user_names[2], used_user_names[3], true, false
    include_examples "verify search", @used_user_groups[0], @used_user_groups[0].upcase, true, true
    include_examples "verify search", @used_user_ids[4], @used_user_ids[0], true, true
    include_examples "verify search", @used_user_notes[1], @used_user_notes[3], true, false
  end
end