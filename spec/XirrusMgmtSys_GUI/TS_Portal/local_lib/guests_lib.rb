require_relative "portal_lib.rb"

shared_examples "verify guests grid" do |portal_name|
    describe "Verify that the grid from the 'Guests' tab has the proper functionalities" do
        it "Go to the 'Guests' tab of the profile" do
          navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
          sleep 2
          @ui.click('#general_show_advanced')
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
        end
        it "Open the 'Select Columns' modal" do
            @ui.click('#guestportal_guests_grid_cp')
            sleep 1
            expect(@ui.css('#guestportal_guests_grid_cp_modal')).to be_present
        end
        it "Click the 'Restore defaults' link and verify both containers have the appropriate entries" do
            left_container_control_elements = Hash[0 => "First Name", 1 => "Last Name", 2 => "Gender", 3 => "Age", 4 => "Locale"]
            right_container_control_elements = Hash[0 => "Guest Name", 1 => "Email", 2 => "Mobile", 3 => "Note", 4 => "Opt in", 5 => "State", 6 => "Activation", 7 => "Expiration"]
            @ui.click('#column_selector_restore_defaults')
            sleep 1
            left_container_elements = @ui.get(:elements, {css: ".lhs .ko_container li"})
            left_container_elements.each_with_index { |element, i|
                expect(element.text).to eq(left_container_control_elements[i])
            }
            right_container_elements = @ui.get(:elements, {css: ".rhs .ko_container li"})
            right_container_elements.each_with_index { |element, i|
                expect(element.text).to eq(right_container_control_elements[i])
            }
        end
        it "Close the 'Select Columns' modal and verify the grid contains the proper columns" do
            columns = Hash[3 => "Guest Name", 4 => "Email", 5 => "Mobile", 6 => "Note", 7 => "Opt in", 8 => "State", 9 => "Activation", 10 => "Expiration"]
            @ui.click("#column_selector_modal_save_btn")
            sleep 1
            (3..10).each do |i|
                expect(@ui.css(".nssg-table .nssg-thead-tr th:nth-child(#{i}) .nssg-th-text").text).to eq(columns[i])
            end
        end
        it "Verify that the table contains the 'Refresh' button" do
            expect(@ui.css('.nssg-refresh')).to be_present
        end
    end
end

shared_examples "add, edit and delete guests" do |portal_name|
  describe "add, edit and delete guests" do
    before :all do
      # make sure it goes to the portal
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
      sleep 2
      @ui.click('#general_show_advanced')
      sleep 2
      @ui.click('#profile_tabs a:nth-child(2)')
    end

    it "add a guest" do
        @browser.execute_script('$("#suggestion_box").hide()')

        @ui.click('#manageguests_addnew_btn')
        @ui.set_input_val('#guestmodal_name_input','GUEST')
        @ui.set_input_val('#guestmodal_email_input','guest@xirrus.com')
        @ui.click('.ko_slideout_content .save')
        sleep 1
        @ui.click('#guestambassador_guestpassword .done')
        sleep 1

        band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
        band.wait_until_present
        expect(band.title).to eq('GUEST')

        band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) div')
        band.wait_until_present
        expect(band.title).to eq('guest@xirrus.com')
    end

    it "edit a guest" do
        @browser.execute_script('$("#suggestion_box").hide()')

        @ui.css('.nssg-table tbody tr:nth-child(1)').hover
        sleep 1

        @ui.click('.nssg-action-invoke')
        sleep 1

        @ui.set_input_val('#guestmodal_name_input', 'GUEST edited')
        @ui.click('.ko_slideout_content .save')
        sleep 1

        band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
        band.wait_until_present
        expect(band.title).to eq('GUEST edited')

        band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) div')
        band.wait_until_present
        expect(band.title).to eq('guest@xirrus.com')
    end

    #it "extend guest access" do
        #band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(9) div')
        #band.wait_until_present
        #date = band.title
        #dsplit = date.split(/\//)
        #newdate = dsplit[0] + "/" + (dsplit[1].to_i + 1).to_s + "/" + dsplit[2]

        #@ui.css('.nssg-table tbody tr:nth-child(1)').hover
        #sleep 1

        #@ui.click('.nssg-action-extend')
        #sleep 1

        #@ui.confirm_dialog
        #sleep 1

        #band = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(9) div')
        #band.wait_until_present
        #expect(band.title).to eq(newdate)
    #end

    it "export guest" do
        @ui.click('#manageguests_exportallcsv_btn')
        sleep 1

        fname = @download + "/Guests-" + portal_name + "-" + (Date.today.to_s) + ".csv"
        file = File.open(fname, "r")
        data = file.read
        file.close

        expect(data.include?('GUEST edited')).to eq(true)

        @ui.click('#guestportal_container .top .commonTitle')

        File.delete(@download +"/Guests-" + portal_name + "-" + (Date.today.to_s) + ".csv")
    end

    it "delete a guest" do
        sleep 3
        tr = @ui.css('.nssg-table tbody tr:nth-child(1)').hover
        sleep 1

        @ui.click('.nssg-action-delete')
        sleep 1

        @ui.confirm_dialog
        sleep 1

        tbody = @ui.css('.nssg-table')
        tbody.wait_until_present
        expect(tbody.trs.length).to eq(1)
    end
  end
end

shared_examples "add several guests" do |number_of_guests, portal_name, mobile_flag|
    describe "Add '#{number_of_guests}' guest(s)" do
        before :all do
          # make sure it goes to the portal
          navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
          sleep 2
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
        it "Add '#{number_of_guests}' guest(s) with the option of mobile set to '#{mobile_flag}'" do
            @browser.execute_script('$("#suggestion_box").hide()')
                a = 1
                mobile_number = 123456789
            while (a <= number_of_guests) do
                number = UTIL.ickey_shuffle(9)
                sleep 1

                guest_name = "Name - " + number
                guest_email = "email" + number + "@macadamian.ro"
                guest_company = "S.C." + number + " S.R.L"
                guest_note = UTIL.chars_255

                @ui.click('#manageguests_addnew_btn')
                sleep 1
                @ui.set_input_val('#guestmodal_name_input',guest_name)
                sleep 0.5
                @ui.set_input_val('#guestmodal_email_input',guest_email)
                sleep 1

                if (mobile_flag==true)
                    @ui.click('.ko_slideout_content .mac_chk_label')
                    sleep 0.5
                    @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_country', 'Belgium')
                    sleep 0.5
                    @ui.set_input_val('#guestambassador_guestmodal_mobile_number',mobile_number)
                    sleep 0.5
                    @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_carrier', 'Mobistar')
                    sleep 1
                    mobile_number+=123
                end

                @ui.click('.ko_slideout_content .save')
                sleep 1
                @ui.click('#guestambassador_guestpassword .done')
                sleep 2
                a+=1
            end
        end
    end
end

shared_examples "add guest" do |portal_name, guest_name, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, scoped|
    describe "Add the guest named '#{guest_name}' with the following features: '#{guest_email}', '#{country}', '#{mobile_number}', '#{mobile_carrier}', '#{guest_company}' and '#{note}" do
        it "Go to the portal named '#{portal_name}' and then to the 'Guests' tab" do
            navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,scoped)
            @ui.click('#profile_tabs a:nth-child(2)')
            sleep 2
        end
        it "Open the 'New Guest' slideout window and add the appropriate values" do
            @browser.execute_script('$("#suggestion_box").hide()')
            sleep 1
            @ui.click('#manageguests_addnew_btn')
            sleep 2
            @ui.set_input_val("#guestmodal_name_input", guest_name)
            sleep 0.5
            @ui.set_input_val("#guestmodal_email_input", guest_email)
            sleep 0.5
            if receive_via_sms != false
                @ui.click('#guestambassador_guestmodal .row.sendByText .mac_chk_label')
                sleep 1
                @ui.set_dropdown_entry("guestambassador_guestmodal_mobile_country", country)
                sleep 0.5
                @ui.set_input_val("#guestambassador_guestmodal_mobile_number", mobile_number)
                sleep 0.5
                @ui.set_dropdown_entry("guestambassador_guestmodal_mobile_carrier", mobile_carrier)
                sleep 0.5
            end
            @ui.set_input_val('#guestambassador_guestmodal div:nth-child(6) input', guest_company)
            sleep 0.5
            @ui.set_input_val('#guestambassador_guestmodal div:nth-child(7) input', note)
            sleep 1
            @ui.click('#guestdetails_save')
            (1..10).each {
                sleep 0.4
                expect(@ui.css('.dialogOverlay.temperror').exists?).to eq(false)
                expect(@ui.css('.error').exists?).to eq(false)
            }
            sleep 1
        end
        it "Close the 'Password Sent' modal" do
            @ui.click('#guestambassador_guestpassword_closemodalbtn')
            sleep 1
        end
    end
end

shared_examples "edit guest" do |portal_name, edit_option, guest_name, guest_name_new, guest_email, receive_via_sms, country, mobile_number, mobile_carrier, guest_company, note, scoped|
    describe "Edit the guest named '#{guest_name}'" do
        it "Go to the portal named '#{portal_name}' and then to the 'Guests' tab" do
            navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,scoped)
            @ui.click('#profile_tabs a:nth-child(2)')
            sleep 2
        end
        it "Find the guest with the the credentials: '#{guest_email}' and open the slideout window" do
            @ui.grid_action_on_specific_line("4", "div", guest_email, "invoke")
        end
        case edit_option
            when "Extend Access"
                it "Get the expiry time of the guest" do
                    @@initial_access = @ui.css('#guestambassador_guestmodal .access').text
                end
                it "Press the 'Extend Access' button, reopen and verify the change" do
                    @ui.click('#guestmodal_extendaccess')
                    sleep 1
                    @ui.css('.confirm').wait_until_present
                    expect(@ui.css('#_jq_dlg_btn_1').text).to eq('YES, EXTEND ACCESS')
                    @ui.click('#_jq_dlg_btn_1')
                    sleep 3
                    @ui.grid_action_on_specific_line("4", "div", guest_email, "invoke")
                    sleep 2
                    new_access = @ui.css('#guestambassador_guestmodal .access').text
                    expect(@@initial_access).not_to eq(new_access)
                end
            when "Remove Access"
                it "Get the access of the guest" do
                    @@access = @ui.css('#guestambassador_guestmodal .access').text
                end
                it "Press the 'Remove Access' button, reopen and verify the change" do
                    @ui.click('#guestmodal_accessaction')
                    sleep 1
                    @ui.css('.confirm').wait_until_present
                    expect(@ui.css('#_jq_dlg_btn_1').text).to eq('YES, REMOVE ACCESS')
                    @ui.click('#_jq_dlg_btn_1')
                    sleep 3
                    @ui.grid_action_on_specific_line("4", "div", guest_email, "invoke")
                    sleep 2
                    new_access = @ui.css('#guestambassador_guestmodal .access').text
                    expect(@@access).not_to eq(new_access)
                end
            when "Enable Access"
                it "Get the access of the guest" do
                    @@access = @ui.css('#guestambassador_guestmodal .access').text
                end
                it "Press the 'Remove Access' button, reopen and verify the change" do
                    @ui.click('#guestmodal_accessaction')
                    sleep 1
                    @ui.css('.confirm').wait_until_present
                    expect(@ui.css('#_jq_dlg_btn_1').text).to eq('YES, ENABLE ACCESS')
                    @ui.click('#_jq_dlg_btn_1')
                    sleep 3
                    @ui.grid_action_on_specific_line("4", "div", guest_email, "invoke")
                    sleep 2
                    new_access = @ui.css('#guestambassador_guestmodal .access').text
                    expect(@@access).not_to eq(new_access)
                end
            when "Reset & Send Password"
                it "Press the 'Reset & Send Password' button" do
                    @ui.click('#guestmodal_resetpassword')
                    sleep 1
                    @ui.css('.confirm').wait_until_present
                    expect(@ui.css('#_jq_dlg_btn_2').text).to eq('SAVE, RESET & SEND PASSWORD')
                    @ui.click('#_jq_dlg_btn_2')
                    sleep 1
                    @ui.css('#guestambassador_guestpassword').wait_until_present
                    expect(@ui.css('#guestambassador_guestpassword .orange').text).to eq("THANKS! Close window")
                    sleep 1
                    @ui.click('#guestambassador_guestpassword .orange')
                end
            when "Edit user details"
                if guest_name_new != ""
                    it "Change the guest name to '#{guest_name_new}'" do
                        @ui.set_input_val("#guestmodal_name_input", guest_name_new)
                    end
                end
                if receive_via_sms != false
                    it "Set the mobile country to '#{country}', mobile number to '#{mobile_number}' and mobile carrier to '#{mobile_carrier}'" do
                        @ui.set_dropdown_entry("guestambassador_guestmodal_mobile_country", country)
                        sleep 0.5
                        @ui.set_input_val("#guestambassador_guestmodal_mobile_number", mobile_number)
                        sleep 0.5
                        @ui.set_dropdown_entry("guestambassador_guestmodal_mobile_carrier", mobile_carrier)
                    end
                end
                if guest_company != ""
                    it "Change the guest company to '#{guest_company}'" do
                        @ui.set_input_val('#guestambassador_guestmodal div:nth-child(6) input', guest_company)
                     end
                end
                if note != ""
                    it "Change the note to '#{note}'" do
                        @ui.set_input_val('#guestambassador_guestmodal div:nth-child(7) input', note)
                    end
                end
                it "Save the guest and verify no error message is received" do
                    @ui.click('#guestdetails_save')
                    (1..10).each {
                        sleep 0.4
                        expect(@ui.css('.dialogOverlay.temperror').exists?).to eq(false)
                        expect(@ui.css('.error').exists?).to eq(false)
                    }
                end
            when "Verify user slideout"
                if mobile_carrier != nil
                    it "On account of the issue: PR 33167 -> reopen the user" do
                       @ui.grid_action_on_specific_line("4", "div", guest_email, "invoke")
                       # expect("PR 33167 IS NOT PRESENT").to eq(true)
                    end
                end
                it "Verify that the user details slideout has the proper information:
                    - Title: Guest: '#{guest_name}'
                    - Subtitle: '#{guest_name}'
                    - Email: '#{guest_email}'
                    - Receive via SMS: '#{receive_via_sms}'
                    - Mobile Country: '#{country}'
                    - Mobile Number; '#{mobile_number}'
                    - Mobile Carrier: '#{mobile_carrier}'
                    - Guest Company: 'WILL SKIP ON ACCOUNT OF THE ISSUE 26642'
                    - Note: 'WILL SKIP FOR NOW'" do
                    expect(@ui.css('#guestportal_container .manageguests .opened .ko_slideout_content .slideout_title span').text).to eq("Guest: #{guest_name}")
                    expect(@ui.css('#guestambassador_guestmodal .left .name').text).to eq(guest_name)
                    expect(@ui.css('#guestambassador_guestmodal .left .email').text).to eq(guest_email)
                    expect(@ui.get(:input , {id: 'guestmodal_name_input'}).value).to eq(guest_name)
                    expect(@ui.get(:input , {id: 'guestmodal_email_input'}).value).to eq(guest_email)
                    if country != nil
                        if country != "NULL"
                            expect(@ui.css('#guestambassador_guestmodal_mobile_country .text').attribute_value("title")).to eq(country)
                        else
                            expect(@ui.css('#guestambassador_guestmodal_mobile_country .text').attribute_value("class")).to include("null")
                        end
                    else
                        expect(@ui.css('#guestambassador_guestmodal_mobile_country')).not_to exist
                    end
                    if mobile_number != nil
                        if mobile_number != nil
                            expect(@ui.get(:input , {id: 'guestambassador_guestmodal_mobile_number'}).value).to eq(mobile_number)
                        end
                    else
                        expect(@ui.css('#guestambassador_guestmodal_mobile_number')).not_to exist
                    end
                    if mobile_carrier != nil
                        if mobile_carrier != "NULL"
                            expect(@ui.css('#guestambassador_guestmodal_mobile_carrier .text').attribute_value("title")).to eq(mobile_carrier)
                        else
                            expect(@ui.css('#guestambassador_guestmodal_mobile_carrier')).not_to be_visible
                        end
                    else
                        expect(@ui.css('#guestambassador_guestmodal_mobile_carrier')).not_to exist
                    end
                end
                it "Close the user slideout" do
                    @ui.click('#guestdetails_close_btn')
                    sleep 1
                    if @ui.css('.confirm').exists?
                        @ui.click('#_jq_dlg_btn_0')
                    end
                    @ui.css('.opened').wait_while_present
                end
        end
    end
end

shared_examples "delete guest" do |portal_name, guest_email|
    describe "Delete the guest that has the email '#{guest_email}'" do
        it "Go to the portal named '#{portal_name}' and then to the 'Guests' tab" do
            navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
            sleep 2
            @ui.click('#profile_tabs a:nth-child(2)')
            sleep 2
        end
        it "Find the guest with the the credentials: '#{guest_email}'" do
            @ui.grid_tick_on_specific_line("4", guest_email, "div")
            sleep 1
            @ui.click(".delete_guest_btn")
        end
        it "Wait for the confirmation prompt and press the 'Yes, Delete Guest' button" do
            @ui.click("#_jq_dlg_btn_1")
            sleep 1.5
            if @ui.css('.nssg-table tbody tr').exists?
                expect(@ui.grid_verify_strig_value_on_specific_line(3, guest_email, "div", 3, "div", guest_email)).to eq(nil)
            end
        end
    end
end

shared_examples "verify add guest button disabled" do |portal_name|
    describe "Verify that the 'Add Guest' button is disabled and the application shows the proper tooltip" do
        it "Go to the portal named '#{portal_name}' and then to the 'Guests' tab" do
            navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
            @ui.click('#profile_tabs a:nth-child(2)')
            sleep 2
        end
        it "Verify the 'Add Guest' button" do
            expect(@ui.css('#manageguests_addnew_btn').attribute_value("class")).to include('disabled')
            @ui.css('#manageguests_addnew_btn').hover
            sleep 1
            expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq("You have used all user account licenses available.\nEither delete active guest accounts or contact Support to order more Guest Access Licenses.")
        end
    end
end