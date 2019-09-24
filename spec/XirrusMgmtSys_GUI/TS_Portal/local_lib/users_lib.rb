require_relative "portal_lib.rb"
require_relative "vouchers_lib.rb"
# require_relative "../reports/reports_examples.rb"

def return_users_hash_function
    return Hash["User Names" => ["John Travolta", "Danny DeVito", "Arnold Schwarzenegger", "Silvester Stalone", "Angelina Jolie", "Robert DeNiro", "Brad Pitt", "Leonardo DiCaprio", "Tom Cruise", "Nicolas Cage", "Jim Carrey", "Marlon Brando", "Harrison Ford", "Tom Hanks", "Will Smith", "Julia Roberts", "Hugh Grant", "George Clooney", "Sandra Bullock", "Johnny Depp"], "User Emails" => ["john.t@mail.com", "dannyde.v@mail.com", "arnold.s@mail.com", "silvester.s@mail.com", "angelina.j@mail.com", "rober.n@mail.com", "brad.p@mail.com", "leo@mail.com", "tom.c@mail.com", "nick.c@mail.com", "jimmy@mail.com", "marlon.b@mail.com", "harrison.f@mail.com", "tom.h@test.com", "will.s@mail.com", "julia.r@mail.com", "hugh.g@mail.com", "george.c@mail.com", "sandra.b@mail.com", "johnny.d@mail.com"], "User IDs" => [101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120], "User Notes" => ["Pulp Fiction (1994)", "L.A. Confidential (1997)", "The Terminator (1984), Twins (1988)", "Rocky (1976), Assasins (1995)", "Alexander (2004)", "Once upon a time in America (1984)", "Legends of the fall (1994)", "Titanic (1997)", "Top Gun (1996)", "Con Air (1997)", "Ace Ventura: Pet Detective (1994)", "The Godfather (1972)", "Working Girl (1988)", "Forest Gump (1994)", "Men in Black (1997)", "Nothing Hill (1999)", "Nothing Hill (1999)", "Ocean's Eleven (2001)", "Miss Congeniality (2000)", "Pirates of the Caribbean: The Curse of the Black Pearl (2003)"], "User Groups" => ["Actors Group", "Best Actors Group", nil]]
end

shared_examples "add a user" do |portal_name, user_name, user_id|
    describe "Add the user named '#{user_name}' to the portal '#{portal_name}'" do
        it "Add the user" do
            @ui.click('#manageguests_addnew_btn')
            sleep 1
            @ui.set_input_val('#manageguests_usermodal_name', user_name)
            sleep 1
            @ui.set_input_val('#manageguests_usermodal_id', user_id)
            sleep 1
            @browser.button(:text => 'Save').click 
            # @ui.click('.ko_slideout_content .button.orange')
            sleep 1
            name = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
            name.wait_until_present
            expect(name.title).to eq(user_name)
            id = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) div')
            id.wait_until_present
            expect(id.title).to eq(user_id)
        end
    end
end

shared_examples "edit a user" do |portal_name, user_name, new_user_name, user_id|
    describe "Edit the user named '#{user_name}' for the portal '#{portal_name}'" do
        it "Edit the user" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            tr.hover
            sleep 2
            @ui.click('.nssg-action-invoke')
            sleep 1
            @ui.set_input_val('#manageguests_usermodal_name', new_user_name)
            sleep 1
            @ui.click('.ko_slideout_content .button.orange')
            sleep 1
            name = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
            name.wait_until_present
            expect(name.title).to eq(new_user_name)
            id = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) div')
            id.wait_until_present
            expect(id.title).to eq(user_id)
        end
    end
end

shared_examples "regenerate user PSK" do |portal_name|
    describe "Regenerate the user PSK for the portal '#{portal_name}'" do
        it "Regenerate the user PSK" do
            psk = @ui.css('.nssg-table tbody tr:nth-child(1) .psk div')
            psk.wait_until_present
            pskval = psk.title
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            tr.hover
            sleep 2
            @ui.click('.nssg-action-regeneratepsk')
            sleep 1
            @ui.confirm_dialog
            sleep 1
            psk = @ui.css('.nssg-table tbody tr:nth-child(1) .psk div')
            psk.wait_until_present
            expect(psk.title).to_not eq(pskval)
        end
    end
end

shared_examples "export user" do |portal_name, user_name|
    describe "Export the user for the portal '#{portal_name}'" do
        it "Export the user and verify the .csv file contains '#{user_name}'" do
            @ui.click('xc-csv-menu .blue')
            sleep 1
            @ui.css('xc-csv-menu .blue .active .items').a(text: "Export All Users...").click
            sleep 5
            fname = @download + "/PSK-" + portal_name + "-" + (Date.today.to_s) + ".csv"
            file = File.open(fname, "r")
            data = file.read
            file.close
            expect(data.include?(user_name)).to eq(true)
            File.delete(@download +"/PSK-" + portal_name + "-" + (Date.today.to_s) + ".csv")
        end
    end
end

shared_examples "import user" do |portal_name|
    describe "Import a .csv file containing a user named 'Import User' for the portal '#{portal_name}'" do
        it "Import the user and verify the grid" do
            file = Dir.pwd + "/import_users.csv"
            @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'input[type="file"]\').click()')
            sleep 2
            @browser.file_field(:css,"input[type='file']").set(file)
            sleep 2
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 4
            @ui.click('#replace_switch .switch_label')
            @ui.click('#manageguests_importmodal .button.orange')
            sleep 1
            @ui.click('#profile_name')
            sleep 1
            name = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
            name.wait_until_present
            expect(name.title).to eq('Import User')
            id = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) div')
            id.wait_until_present
            expect(id.title).to eq('1')
        end
    end
end

shared_examples "delete user" do |portal_name|
    describe "Delete a user for the portal named '#{portal_name}'" do
        it "Delete user" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            tr.hover
            sleep 2
            @ui.click('.nssg-action-delete')
            sleep 2
            @ui.confirm_dialog
            sleep 1
            tbody = @ui.css('.nssg-table')
            tbody.wait_until_present
            expect(tbody.trs.length).to eq(1)
        end
    end
end

shared_examples "add, edit and delete user" do |portal_name|
    user_name = "Test User"
    new_user_name = "NEW Test User"
    user_id = "1234"
  it_behaves_like "navigate to the portal second page", portal_name
  it_behaves_like "add a user", portal_name, user_name, user_id
  it_behaves_like "edit a user", portal_name, user_name, new_user_name, user_id
  it_behaves_like "regenerate user PSK", portal_name
  it_behaves_like "export user", portal_name, new_user_name
  it_behaves_like "import user", portal_name
  it_behaves_like "delete user", portal_name
end

shared_examples "verify onboarding users grid and slideout componets" do |what_type|
    describe "Verify the Onboarding portal user's tab grid has the proper components" do
        it "Verify the grid" do
            expect(@ui.css(".nssg-table .nssg-thead").trs.length).to eq(1)
            expect(@ui.css(".nssg-table .nssg-thead tr").ths.length).to eq(11)
            names_array = ["Name", "Group", "User ID", "User-PSK", "Email", "Note", "Registered Devices", "Activation", "Expiration"]
            @ui.css(".nssg-table .nssg-thead tr").ths.length.times do |i|
                if i == 0
                    expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i+1})").attribute_value("class")).to include("nssg-th-actions")
                elsif i == 1
                    expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i+1}) input")).to exist
                else
                    expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i+1}) .nssg-th-text").text).to eq(names_array[i-2])
                end
            end
        end
        it "Verify the User's creation slideout for the availability information message not being available (see PR 32711)" do
            @ui.click('#manageguests_addnew_btn')
            sleep 1
            @ui.css('#guestdetails_close_btn').wait_until_present
            sleep 1
            if what_type == "Mainline"
                expect(@ui.css(".tab_contents .mainline-tech-info")).not_to exist
                #expect(@ui.css(".tab_contents .mainline-tech-info").text).to eq("This feature is only available on Technology firmware.\nTo enable use of Technology firmware click here to go to firmware settings.")
            elsif what_type == "Technology"
                expect(@ui.css(".tab_contents .mainline-tech-info")).not_to exist
            end
            @ui.click('#guestdetails_close_btn')
            sleep 1
            @ui.css('#guestdetails_close_btn').wait_while_present
        end
    end
end

def new_user_details_slideout_add_values(username, email, user_id, note, group)
    @ui.css('#guestdetails_close_btn').wait_until_present
    if username != nil
        @ui.set_input_val('#manageguests_usermodal_name',username)
    end
    sleep 1
    if email != nil
        @ui.set_input_val('#manageguests_usermodal_email',email)
    end
    sleep 1
    if user_id != nil
        @ui.set_input_val('#manageguests_usermodal_id',user_id)
    end
    sleep 1
    if note != nil
        @ui.set_textarea_val('#manageguests_usermodal_note', note)
    end
    sleep 1
    if group != nil
        if group.class == Array
            group = group[0]
            @ui.set_dropdown_entry_by_path("#manageguests_usermodal_group .ko_dropdownlist_combo", group)
            #@ui.set_dropdown_entry_by_path(".ko_dropdownlist_combo_input", group)
        else
            @ui.set_input_val(".ko_dropdownlist_combo_input", group)
        end
    end
    @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
    sleep 1
    @ui.click(".ko_slideout_content .sectiontitle")
    sleep 1
    if @ui.css('.ko_dropdownlist_list.active').exists?
        @browser.execute_script('$(".ko_dropdownlist_list.active").hide()')
    end
    sleep 2
    @ui.click('.ko_slideout_content .orange')
    sleep 0.5
    @ui.css('#guestdetails_close_btn').wait_while_present
end

shared_examples "add several users" do |portal_name, number_of_users, username, email, user_id, note, group|
    describe "Add '#{number_of_users}' guest(s)" do
        before :all do
          navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
        it "Add '#{number_of_users}' user(s)" do
            @browser.execute_script('$("#suggestion_box").hide()')
            number_of_users.times do
                username_new = username+"#{UTIL.ickey_shuffle(8)}"
                user_id_new = user_id+"#{UTIL.ickey_shuffle(9)}"
                sleep 1
                @ui.click('#manageguests_addnew_btn')
                sleep 1
                new_user_details_slideout_add_values(username_new, email, user_id_new, note, group)
            end
        end
    end
end

shared_examples "create csv file" do |file_name|
    describe "Create a new CSV file with values" do
        it "Create the CSV file" do
            CSV.new("#{file_name}.csv") #"/home/adriandlocal/Sites/xirrus-auto/users_import_with_new_groups.csv")
        end
        it "Open the CSV and add data" do
            CSV.open("#{file_name}.csv", "wb") do |csv|  #"/home/adriandlocal/Sites/xirrus-auto/users_import_with_new_groups.csv", "wb") do |csv|
                csv << ["Name","Note","UserId","Passphrase","Authentication Username","Registered Devices","Group"]
                csv << ["New User","Some Note text","#{UTIL.ickey_shuffle(9)}","a#{UTIL.ickey_shuffle(2)}b#{UTIL.ickey_shuffle(2)}c#{UTIL.ickey_shuffle(2)}d#{UTIL.ickey_shuffle(2)}","","0","NEW GROUP FROM IMPORT"]
            end
        end
    end
end

shared_examples "import users" do |portal_name, csv_file_name, use_replace, verify_number_of_users|
    describe "Import Users from a .csv file to the portal '#{portal_name}' and verify the grid length" do
        before :all do
          navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
        it "Import a .csv file named '#{csv_file_name}'" do
            file = Dir.pwd + "/#{csv_file_name}.csv"
            @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'input[type="file"]\').click()')
            sleep 2
            @browser.file_field(:css,"input[type='file']").set(file)
            sleep 2
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 4
            if use_replace == true
                @ui.click('#replace_switch .switch_label')
            end
            sleep 1
            if @ui.css('#manageguests_importmodal .button.orange').visible?
                @ui.click('#manageguests_importmodal .button.orange')
            end
            sleep 1
            @ui.click('#profile_name')
        end
        it "Verify the grid length" do
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","500")
            sleep 2
            grid_length = @ui.css('.nssg-table tbody').trs.length
            expect(grid_length).to eq(verify_number_of_users)
            sleep 2
            @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","10")
        end
    end
end

shared_examples "add user for onboarding" do |portal_name, user_name, user_email, user_id, user_note, user_group, original_length, verify_error, error_message|
    describe "Add a certain user to an Onboarding portal" do
        before :all do
          # make sure it goes to the portal
          navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
        it "Add the user with '#{user_name}', '#{user_id}' and '#{user_note}'" do
            @browser.execute_script('$("#suggestion_box").hide()')
            @ui.click('#manageguests_addnew_btn')
            sleep 1
            @ui.set_input_val('#manageguests_usermodal_name',user_name)
            sleep 0.5
            @ui.set_input_val('#manageguests_usermodal_email',user_email)
            sleep 1
            @ui.set_input_val('#manageguests_usermodal_id',user_id)
            sleep 1
            @ui.set_textarea_val('#manageguests_usermodal_note', user_note)
            sleep 1.5
            if user_group != nil
                if user_group.class == Array
                    user_group = user_group[0]
                    @ui.set_dropdown_entry_by_path("#manageguests_usermodal_group .ko_dropdownlist_combo", user_group)
                else
                    @ui.set_input_val(".ko_dropdownlist_combo_input", user_group)
                end
                sleep 2
                @browser.execute_script('$(".ko_dropdownlist_list.active").removeClass(\'active\')')
                @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
            end
            sleep 1
            @ui.click('.ko_slideout_content .orange')
        end
        if verify_error == true
            it "Verify the the application displays an error message with the text: '#{error_message}'" do
                @ui.css('.temperror').wait_until_present
                expect(@ui.css('.temperror')).to be_visible
                expect(@ui.css('.temperror .msgbody div').text).to eq(error_message)
                @ui.css('.temperror').wait_while_present
                if @ui.css('#guestdetails_close_btn').visible?
                    @ui.click('#guestdetails_close_btn')
                    sleep 1
                end
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","500")
                sleep 2
                grid_length = @ui.css('.nssg-table tbody').trs.length
                expect(grid_length).to eq(original_length)
                sleep 2
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","10")
            end
        else
            it "Expect that the user is properly entered in the grid and find, then verify the entry" do
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","500")
                sleep 2
                grid_length = @ui.css('.nssg-table tbody').trs.length
                expect(grid_length).to eq(original_length + 1)
                sleep 2
                @ui.grid_verify_strig_value_on_specific_line("3",user_name,"div","3","div",user_name)
                @ui.grid_verify_strig_value_on_specific_line("3",user_name,"div","5","div",user_id.to_s)
                @ui.grid_verify_strig_value_on_specific_line("3",user_name,"div","8","div",user_note)
                @ui.grid_verify_strig_value_on_specific_line("3",user_name,"div","4","div",user_group)
                @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","10")
            end
        end
    end
end

shared_examples "send upsk" do |portal_name, user_names, email|
    describe "Send U-PSKs to '#{user_names}' from the Onboarding portal named '#{portal_name}'" do
        before :all do
          # make sure it goes to the portal
          navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
        if user_names.class == Array
            it "Tick the needed user checkboxes" do
                user_names.each do |user_name|
                    @ui.grid_tick_on_specific_line("3", user_name, "div")
                end
                sleep 1
                @ui.click('#send_psk_btn')
            end
        else
            it "Click the 'Send All U-PSKs' button" do
                @ui.click('#send_psk_all_btn')
            end
        end
        it "Verify the confirmation modal" do
            sleep 1
            grid_length = @ui.css('.nssg-table tbody').trs.length
            @ui.css('.confirm').wait_until_present
            if user_names.class == Array
                expect(@ui.css('.confirm .title span').text).to eq("Send UPSK")
                expect(@ui.css('.confirm .msgbody div').text).to eq("You will be sending a UPSK notification to the user(s) selected on this page.\nDo you want to proceed?")
            else
                expect(@ui.css('.confirm .title span').text).to eq("Send All UPSKs")
                expect(@ui.css('.confirm .msgbody div').text).to eq("You will be sending all users (#{grid_length}) in the list notification of their UPSK.\nDo you want to proceed?")
            end
        end
        it "Press the 'SEND' button" do
            @ui.click('#_jq_dlg_btn_1')
            @ui.css('.confirm').wait_while_present
        end
        it "Sleep 10 seconds" do
            sleep 10
        end
    end
end

shared_examples "prepare bulk email inbox for upsks emails" do
  describe "Copy all emails from the Xirrus bulk email to another folder for greater visibility" do
    it "Perform the needed actions" do
        @browser_new = Watir::Browser.new :chrome
        @browser_new.driver.manage.window.maximize
        @ui_new = XMS::NG::UI.new(args = {browser: @browser_new})
        @browser_new.goto("https://mail.google.com/mail")
        sleep 2
        login_to_gmail("xirrusms@gmail.com", "Xirrus!234")
        until @ui_new.css('.aRu .aRv').visible? do
          @ui_new.click(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh")
          sleep 0.3
          if @ui_new.css(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh").parent.attribute_value("aria-checked") != "true"
            @ui_new.click(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh")
            sleep 0.3
          end
          @ui_new.css(".aeH div:last-child .ns .asa .ase").wait_until_present
          @ui_new.click(".aeH div:last-child .ns .asa .ase")
          sleep 0.3
          @ui_new.css(".J-M.agd.aYO .J-M-Jz div:first-child div").wait_until_present
          @ui_new.click(".J-M.agd.aYO .J-M-Jz div:first-child div")
          sleep 0.3
          if @ui_new.css('.v1').visible?
            @ui_new.css('.v1').wait_while_present
          end
          @ui_new.css('.bofITb').wait_until_present
          sleep 1.5
        end
        expect(@ui_new.css('.aRu .aRv')).to be_visible
        @browser_new.quit
    end
  end
end

shared_examples "force the search box to be displayed" do
    describe "(For Google Login or Microsoft Azure portals) Force the search box to be displayed even with no entries in the grid" do
        it "Force the search input box to be visible" do
            @browser.execute_script("$('.clearfix.push-right search').css({'display':'block'})")
            sleep 1
            expect(@ui.css('.clearfix.push-right search')).to be_present
        end
    end
end
