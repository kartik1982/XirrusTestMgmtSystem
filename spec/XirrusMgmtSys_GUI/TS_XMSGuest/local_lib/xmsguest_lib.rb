def get_grid_length_manageguests
  # get the grid entries length as "grid_length"
    grid_entries = @ui.css(".nssg-table")
    grid_entries.wait_until(&:present?)
    $grid_length = grid_entries.trs.length
end

def delete_all_guests_line_by_line
    #verify that the grid is on the first page
    @ui.verify_grid_is_on_first_page
    sleep 0.2
    #get the grid's length
    get_grid_length_manageguests
    $grid_length = $grid_length-1
    sleep 0.2
    # start iterating trough each grid line
    while ($grid_length != 0) do
        # hover over the specific line to reveal the underlay controls
        @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length})").hover
        sleep 0.5
        @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(1) .nssg-actions-container .nssg-action-delete").click
        sleep 0.8
        if (!@ui.css('#_jq_dlg_btn_1').visible?)
          # exit if the delete guest dialog isn't displayed
          break
        else
          @ui.click('#_jq_dlg_btn_1')
          sleep 0.8
        end
    # go line by line
        $grid_length-=1
        # after checking the last line in the grid (first one) start the following procedure
        if ($grid_length == 0)
        if @ui.css('.nssg-paging-controls .nssg-paging-next').exists?
          if @ui.css('.nssg-paging-controls .nssg-paging-next').visible?
              @ui.css('.nssg-paging-controls .nssg-paging-next').click
              sleep 4
            end
        else
          break
        end
          get_grid_length_manageguests
          $grid_length = $grid_length-1
          redo
      end
    end
end

def perform_action(action)
  @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length})").hover
    sleep 0.8
    @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:first-child .nssg-actions-container .nssg-action-#{action}").click
end

def actions_on_guest_in_the_grid(guest_name, action)
  #verify that the grid is on the first page
    @ui.verify_grid_is_on_first_page
    sleep 0.2
    #get the grid's length
    get_grid_length_manageguests
    $grid_length = $grid_length-1
    thead_trs = @ui.css(".nssg-table thead tr").ths.length
    while thead_trs > 1
      if @ui.css(".nssg-table thead tr th:nth-child(#{thead_trs}) .nssg-th-text").text == "Guest Name"
        @column_name_number = thead_trs
        break
      end
      thead_trs-=1
    end
    sleep 0.2
    # start iterating trough each grid line
    while ($grid_length != 0) do
      # search for the guest name string
      puts @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{@column_name_number}) .nssg-td-text").text
      puts guest_name
      if (@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{@column_name_number}) .nssg-td-text").text == guest_name)
        #depending on what action is needed perform the action
        case action
          when "verify"
            puts "FOUND #{guest_name}"
            expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{@column_name_number}) .nssg-td-text").text).to eq(guest_name)
          when "invoke"
            perform_action("invoke")
          when "renew"
            perform_action("renew")
          when "reset"
            perform_action("reset")
          when "extend"
            perform_action("extend")
          when "remove"
            perform_action("remove")
          when "enable"
            perform_action("enable")
          when "delete"
            perform_action("delete")
        end
        break
      end
      # go line by line
        $grid_length-=1
        # after checking the last line in the grid (first one) start the following procedure
        if ($grid_length == 0)
        if @ui.css('.nssg-paging-controls .nssg-paging-next').exists?
          if @ui.css('.nssg-paging-controls .nssg-paging-next').visible?
              @ui.css('.nssg-paging-controls .nssg-paging-next').click
              sleep 4
            else
              found_guest = false
              expect(found_guest).to eq(true)
            end
        else
          found_guest = false
          expect(found_guest).to eq(true)
        end
          get_grid_length_manageguests
          $grid_length = $grid_length-1
          redo
      end
    end
end

shared_examples "general features guest ambassador" do
  describe "Test the general features of a Guest Ambassador account on the application" do
    it "Ensure the view is on the 'Home' page" do
      sleep 1
      expect(@browser.url).to include('/#guestambassador')
    end
    it "Verify the main header has the following features: 'Xirrus' logo, 'Home' link, 'Manage Guests' link, 'Tenants' dropdown list, 'Help' link and 'user options' dropdown list" do
      expect(@ui.css('#header_logo')).to be_visible
      expect(@ui.css('#header_nav_guestambassador')).to be_visible
      expect(@ui.css('#header_nav_manageguests')).to be_visible
      if @ui.css('#tenant_scope_options').exists?
        expect(@ui.css('#tenant_scope_options')).to be_visible
      end
      expect(@ui.css('#header_nav_help')).to be_visible
      expect(@ui.css('#header_nav_user')).to be_visible
    end
    it "Verify that the 'user options' dropdown list has the entries: 'Contact Us...' and 'Log Out'" do
      @ui.click('#header_nav_user .user-icon')
      sleep 1
      expect(@ui.css('#header_contact')).to be_visible
      expect(@ui.css('#header_logout_link')).to be_visible
      sleep 1
      @ui.click('#header_nav_guestambassador')
    end
    it "Verify that the general features of the main window" do
      expect(@ui.css('#main_container #guestambassador')).to be_visible
      expect(@ui.css('#main_container #guestambassador .welcome span:first-child').text).to eq('Welcome')
      expect(@ui.css('#main_container #guestambassador .welcome span:nth-child(2)').text).to include('Guest')
      expect(@ui.css('#main_container #guestambassador .welcome span:nth-child(2)').text).to include('Dinte')
      expect(@ui.css('#main_container #guestambassador .description').text).to eq('To the GUEST PORTAL for granting guests access to your Wi-Fi.')
      expect(@ui.css('#guestambassador_search')).to be_visible
      expect(@ui.css('#guestambassador_search_btn')).to be_visible
      expect(@ui.css('#main_container #guestambassador .addNew')).to be_visible
      expect(@ui.css('#main_container #guestambassador .addNew .details .title').text).to eq('Add New Guest')
      expect(@ui.css('#main_container #guestambassador .addNew .details .description').text).to eq('Create a username and password for a new guest signing in.')
      expect(@ui.css('#main_container #guestambassador .manageGuests')).to be_visible
      expect(@ui.css('#main_container #guestambassador .manageGuests .details .title').text).to eq('Manage Guests')
      expect(@ui.css('#main_container #guestambassador .manageGuests .details .description').text).to eq('Update guest information, resend passwords or expire access.')
    end
  end
end

shared_examples "delete all guests select all lines" do
  describe "Delete all available guests" do
    it "Go to the 'Manage Guests' area" do
      @ui.click('#header_nav_manageguests')
    end
    it "Place a tick in the 'Select All Lines' checkbox" do
      if @ui.css('.nssg-table thead tr:first-child th:nth-child(2) .mac_chk_label').visible?
        @ui.click('.nssg-table thead tr:first-child th:nth-child(2) .mac_chk_label')
        $bool_skip = false
      else
        puts "SKIPPED - no guests are present in the grid"
        $bool_skip = true
      end
    end
    it "Press the 'Delete' button" do
      if $bool_skip == false
        @ui.click('.delete_guest_btn')
        sleep 2.4
        expect(@ui.css('.dialogOverlay')).to be_visible
      end
    end
    it "Press the 'Yes, Delete Guest' button on the confirmation overlay" do
      if $bool_skip == false
        @ui.click('#_jq_dlg_btn_1')
      end
    end
  end
end

shared_examples "delete all guests line by line" do
  describe "Delete all available guests" do
    it "Go to the 'Manage Guests' area" do
      @ui.click('#header_nav_manageguests')
    end
    it "Delete each guest line by line" do
      delete_all_guests_line_by_line
    end
    it "Expect that the grid length is '1' (table header)" do
      get_grid_length_manageguests
      expect($grid_length).to eq(1)
    end
  end
end

shared_examples "add guests" do |area, number_of_guests, portal_name, mobile_flag|
  describe "Add '#{number_of_guests}' guests for portal named '#{portal_name}' using the area '#{area}'" do
    it "Go to the '#{area}' section" do
      if area == "Manage Guests"
        @ui.click('#header_nav_manageguests')
      elsif area == "Home"
        if @browser.url.include?('/manageguests')
          @ui.click('#header_nav_guestambassador')
        end
        @ui.click('#header_nav_guestambassador')
      else
        puts "Something went terribly wrong !!!"
      end
      sleep 1
    end
    it "Add '#{number_of_guests}' guests" do
      @browser.execute_script('$("#suggestion_box").hide()')
                a = 1
                mobile_number = 123456789
            while (a <= number_of_guests) do

                guest_name = UTIL.random_title.downcase
                guest_email = UTIL.random_title.downcase + "@xirrus.com"
                guest_company = UTIL.random_title.downcase + " GmbH"
                guest_note = UTIL.random_title.downcase + " " + UTIL.random_title.upcase

                if area == "Manage Guests"
          @ui.click('#manageguests_addnew_btn')
        elsif area == "Home"
          @ui.click('#main_container #guestambassador .addNew .img')
        else
          puts "Something went terribly wrong !!!"
        end

                sleep 1
                @ui.set_input_val('#guestmodal_name_input',guest_name)
                sleep 1
                @ui.set_input_val('#guestmodal_email_input',guest_email)
                sleep 2

                if (mobile_flag==true)
                    @ui.click('.ko_slideout_content .mac_chk_label')
                    sleep 1
                    if @ui.css("#guestambassador_guestmodal_mobile_country").exists?
                      if @ui.css("#guestambassador_guestmodal_mobile_country").visible?
                        @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_country', 'Belgium')
                      end
                    end
                    sleep 1
                    @ui.set_input_val('#guestambassador_guestmodal_mobile_number',mobile_number)
                    sleep 1
                    if @ui.css("#guestambassador_guestmodal_mobile_carrier").exists?
                      if @ui.css("#guestambassador_guestmodal_mobile_carrier").visible?
                        @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_carrier', 'Mobistar')
                      end
                    end
                    sleep 2
                    mobile_number+=123
                end
                sleep 1
                company = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(6) input'})
          company.set guest_company
                sleep 1
                note = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(7) input'})
          note.set guest_note
                sleep 1
                @ui.click('#guestambassador_guestmodal div:nth-child(8) .ko_dropdownlist.small.white a .arrow')
                sleep 1
                @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", portal_name)
                sleep 1
                @ui.click('.ko_slideout_content .save')
                sleep 1
                @ui.click('#guestambassador_guestpassword .done')
                sleep 1
                @ui.refresh
                sleep 2
                a+=1
            end
    end
  end
end

shared_examples "add specific guest" do |guest_name, email, text_message, country, mobile_number, provider, guest_company, guest_note, guest_portal|
  describe "Add the guest with the name '#{guest_name}' and the email '#{email}' to the portal named '#{guest_portal}'" do
    it "Go to the 'Manage Guests' section" do
      @ui.click('#header_nav_manageguests')
    end
    it "Press the '+ NEW GUEST' button" do
      @ui.click('#manageguests_addnew_btn')
      sleep 1
      expect(@ui.css('.ko_slideout_content')).to be_visible
    end
    it "Set the 'Guest Name' inputbox to the value #{guest_name}" do
      @ui.set_input_val('#guestmodal_name_input',guest_name)
    end
    it "Set the 'Email' inputbox to the value #{email}" do
            @ui.set_input_val('#guestmodal_email_input',email)
    end
    it "Set 'Receive password via text messate' to '#{text_message}'; set the 'Country' to '#{country}'; 'Number' to '#{mobile_number}' and 'Provider' to '#{provider}'" do
            if text_message == true
              @ui.click('.ko_slideout_content .mac_chk_label')
              sleep 1
              @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_country', country)
              sleep 1
              @ui.set_input_val('#guestambassador_guestmodal_mobile_number',mobile_number)
              sleep 1
              @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_carrier', provider)
          end
    end
    it "Set the 'Company' inputbox to the value '#{guest_company}'" do
      company = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(6) input'})
      company.set guest_company
    end
    it "Set the 'Note' inputbox to the value '#{guest_note}'" do
      note = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(7) input'})
      note.set guest_note
    end
    it "Set the 'Guest Portal' dropdown list to '#{guest_portal}'" do
      @ui.click('#guestambassador_guestmodal div:nth-child(8) .ko_dropdownlist.small.white a .arrow')
            sleep 1
            @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", guest_portal)
    end
    it "Press the 'SAVE & SEND PASSWORD' button and close the 'Password sent' promt" do
      @ui.click('#guestdetails_save')
      sleep 1
      @ui.click('#guestambassador_guestpassword .done')
    end
    it "Verify that the guest named '#{guest_name}' is added to the grid" do
      actions_on_guest_in_the_grid(guest_name, "verify")
    end
    it "Open the 'View/Edit Details' slideout window for the guest named '#{guest_name}'" do
      actions_on_guest_in_the_grid(guest_name, "invoke")
    end
    it "Verify that all the values are correct" do
      guest_name_input = @ui.get(:input, {id: 'guestmodal_name_input'})
      guest_name_value = guest_name_input.value
      expect(guest_name_value).to eq(guest_name)

      email_input = @ui.get(:input, {id: 'guestmodal_email_input'})
      email_input_value = email_input.value
      expect(email_input_value).to eq(email)

      if text_message == true
        country_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_country a .text'})
        country_dropdown_value = country_dropdown.attribute_value('title')
        expect(country_dropdown_value).to eq(country)

        number_input = @ui.get(:input, {id: 'guestambassador_guestmodal_mobile_number'})
        number_input_value = number_input.value
        expect(number_input_value).to eq(mobile_number)

        provider_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_carrier a .text'})
        provider_dropdown_value = provider_dropdown.attribute_value('title')
        expect(provider_dropdown_value).to eq(provider)
      end

      company_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(6) input'})
      company_input_value = company_input.value
      expect(company_input_value).to eq(guest_company)

      note_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(7) input'})
      note_input_value = note_input.value
      expect(note_input_value).to eq(guest_note)

      guest_portal_value = @ui.css('#guestambassador_guestmodal div:nth-child(8) span').text
      expect(guest_portal_value).to eq(guest_portal)
    end
    it "Close the slideout window" do
      @ui.click('#guestdetails_close_btn')
    end
  end
end

shared_examples "edit guest" do |guest_name, text_message|
  describe "Edit the guest with the named #{guest_name}" do
    it "Go to the 'Manage Guests' section" do
      @ui.click('#header_nav_manageguests')
    end
    it "Open the 'View/Edit Details' slideout window for the guest named '#{guest_name}'" do
      actions_on_guest_in_the_grid(guest_name, "invoke")
      sleep 1
      expect(@ui.css('.ko_slideout_content')).to be_visible
    end
    it "Change all values except for the email and portal name" do
      guest_name_input = @ui.get(:text_field, {id: 'guestmodal_name_input'})
      $guest_name_value = guest_name_input.value
      guest_name_input.set $guest_name_value + "- NEW"

      email_input = @ui.get(:input, {id: 'guestmodal_email_input'})
      $email_input_value = email_input.value

      if text_message == true
        country_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_country a .text'})
        $country_dropdown_value = country_dropdown.attribute_value('title')
        @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_country', "United Kingdom")

        number_input = @ui.get(:text_field, {id: 'guestambassador_guestmodal_mobile_number'})
        $number_input_value = number_input.value
        @ui.set_input_val('#guestambassador_guestmodal_mobile_number', "000123000321")
        sleep 1

        provider_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_carrier a .text'})
        $provider_dropdown_value = provider_dropdown.attribute_value('title')
        @ui.click('#guestambassador_guestmodal_mobile_carrier a .arrow')
        @ui.set_dropdown_entry('guestambassador_guestmodal_mobile_carrier', "Virgin Mobile")
      end

      company_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(6) input'})
      $company_input_value = company_input.value
      company_input.set $company_input_value + "- NEW"

      note_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(7) input'})
      $note_input_value = note_input.value
      note_input.set $note_input_value + "- NEW"

      $guest_portal_value = @ui.css('#guestambassador_guestmodal div:nth-child(8) span').text
    end
    it "Press the 'SAVE' button" do
      @ui.click('#guestdetails_save')
    end
    it "Open the 'View/Edit Details' slideout window for the guest named '#{guest_name}- NEW' and verify the changes" do
      actions_on_guest_in_the_grid(guest_name + "- NEW", "invoke")
      sleep 1
      expect(@ui.css('.ko_slideout_content')).to be_visible

      guest_name_input = @ui.get(:input, {id: 'guestmodal_name_input'})
      guest_name_new_value = guest_name_input.value
      expect(guest_name_new_value).to eq($guest_name_value + "- NEW")

      email_input = @ui.get(:input, {id: 'guestmodal_email_input'})
      email_input_new_value = email_input.value
      expect(email_input_new_value).to eq($email_input_value)

      if text_message == true
        country_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_country a .text'})
        country_dropdown_new_value = country_dropdown.attribute_value('title')
        expect(country_dropdown_new_value).to eq("United Kingdom")

        number_input = @ui.get(:input, {id: 'guestambassador_guestmodal_mobile_number'})
        number_input_new_value = number_input.value
        expect(number_input_new_value).to eq("000123000321")

        provider_dropdown = @ui.get(:span, {css: '#guestambassador_guestmodal_mobile_carrier a .text'})
        provider_dropdown_new_value = provider_dropdown.attribute_value('title')
        expect(provider_dropdown_new_value).to eq("Virgin Mobile")
      end

      company_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(6) input'})
      company_input_new_value = company_input.value
      expect(company_input_new_value).to eq($company_input_value + "- NEW")

      note_input = @ui.get(:text_field, {css: '#guestambassador_guestmodal div:nth-child(7) input'})
      note_input_new_value = note_input.value
      expect(note_input_new_value).to eq($note_input_value + "- NEW")

      guest_portal_new_value = @ui.css('#guestambassador_guestmodal div:nth-child(8) span').text
      expect(guest_portal_new_value).to eq($guest_portal_value)
    end
    it "Close the slideout window" do
      @ui.click('#guestdetails_close_btn')
    end
  end
end