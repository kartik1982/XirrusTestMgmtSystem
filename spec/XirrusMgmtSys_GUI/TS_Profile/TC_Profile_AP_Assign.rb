require_relative "./local_lib/profile_lib.rb"
require_relative "./local_lib/ap_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
###############################################################################
############TEST CASE: Access Point Assign to Profile by Drag#################
###############################################################################
describe "**************TEST CASE: Access Point Assign to Profile by Drag************" do
    decription_prefix = "Description for "
    profile_name = UTIL.random_title.downcase
    puts "Profile name is #{profile_name}"
    ap_name = "Auto-XR620-1"    

    include_examples "delete all profiles from the grid"
    include_examples "create profile from header menu", profile_name, "Profile description", false
    include_examples "go to profile", profile_name

    describe "Test dragging" do
        it "Drag first access point to profile #{profile_name}" do
            @ui.click('#profile_tab_arrays')
            @ui.css('#profile_array_add_btn').wait_until_present
            sleep 0.5
            @ui.click('#profile_array_add_btn')
            sleep 1
            list = @ui.css('#add_arrays ul')
            list.wait_until_present

            #puts "Clicking on #{ap_name}"
			@ui.mouse_down_on_element_move_to('#add_arrays ul li[title='+ap_name+']', '#add_arrays .rhs .select_list ul');
			expect(@ui.css('#add_arrays .rhs .select_list ul li[title='+ap_name+']')).to be_present
            @ui.click('#arrays_add_modal_cancel_btn')
        end
    end
end