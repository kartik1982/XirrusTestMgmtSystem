shared_examples "if profile name does not exist then create it" do |profile_name, description, readonly|
  describe "Verify that the '#{profile_name}' profile exists or not" do
    it "Click on the Profiles header to open the Profiles DropDown list" do
      @ui.css("#header_nav_profiles").click
    end
    it "Click on the View All Profiles hyperlink " do
      @ui.click("#view_all_nav_item")
    end
    it "Ensure that the View Type is set to Tile" do
      @ui.click("#profiles_tiles_view_btn")
    end
    it "Search for the profile named: '#{profile_name}', if it does not exist, then create it" do
      @bool_found = false
      profiles_list = "#profiles_list .tile_wrapper .ko_container .tile"
      profile_lis = @ui.get(:elements , {css: profiles_list})
      profile_lis.each_with_index do |a, index|
        @index = index
      end
      if !@index.nil?
        index = @index + 1
        while index > 0
          profile = @ui.css("#profiles_list .tile_wrapper .ko_container .tile:nth-of-type(#{index}) a .title").text
          if profile == profile_name
            expect(profile).to eq(profile_name)
            @bool_found = true
          end
          index -= 1
        end
      end
      if @bool_found != true
        @ui.css("#header_nav_profiles").click
        sleep 0.5
        @ui.id("header_new_profile_btn").click
        sleep 0.5
        @ui.id("profiles_new_modal").wait_until_present
        pn = @ui.get(:text_field, {id: "profile_name_input"})
        pn.set profile_name
        sleep 0.5
        @ui.set_textarea_val('.profile_description_input', description)
        sleep 0.5
        if (readonly)
          @ui.css(".show_advanced_container > a").click
          sleep 0.5
          @ui.css("#profile_readonly_switch .switch_label").click
        end
        @ui.get(:button, {id: "newprofile_create"}).click
      end
    end
  end
end

shared_examples "Click on the New Profile button in the Porfiles header menu" do
  describe "Clicks on the New Profile button in the Profiles header menu" do

    it "Click on the Profiles header to open the Profiles DropDown list" do
      # open header profile menu
      sleep 1
      @ui.css("#header_nav_profiles").click
    end

    it "Click on the '+ New profile' button " do
      sleep 1
      @ui.id("header_new_profile_btn").click
    end

  end
end

shared_examples "delete all profiles from the grid" do
  describe "Deletes all the profiles that are already present in the grid" do

    it "Click on the Profiles header to open the Profiles DropDown list" do
      sleep 1
      @ui.css("#header_nav_profiles").click
    end

    it "Click on the View All Profiles hyperlink " do
      sleep 1
      @ui.click("#view_all_nav_item")
    end

    it "Ensure that the View Type is set to Tile" do
      sleep 1
      @ui.click("#profiles_tiles_view_btn")
    end

    it "Delete all entries from the grid" do
      sleep 1
      a = @ui.css('#new_profile_tile')
      until (a.present?) do
        if !["firefox", "edge"].include? @browser_name.to_s
          @ui.css("#profiles_list .tile #profiles_tile_item_0").hover
        #else
#          @ui.hover("#profiles_list .tile #profiles_tile_item_0")
          #@ui.show_needed_control("#profiles_list .tile:nth-child(1) .overlay")
        end
        @ui.show_needed_control("#profiles_list .tile:nth-child(1) .overlay")
        sleep 1
        @ui.click('.overlay .deleteIcon')
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
        sleep 1.5
        if @ui.css('.error').exists?
          @browser.refresh
          sleep 1
          @ui.css("#profiles_list").wait_until_present
        end
      end
    end
  end
end

def go_to_profile_tab(tab)
    base_link = /#profiles\/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}\/config\/#{tab}/
    css_path_of_tab_button = @ui.css("#profile_config_tab_#{tab}")

    if tab == "optimization" or tab == "services" and !@ui.css('#profile_config_tabs li:nth-child(7)').visible?
        @ui.click('#profile_config_advanced')
        sleep 0.5
    end
    sleep 1
    css_path_of_tab_button.click
    sleep 2
    expect(@browser.url).to match(base_link)
end

shared_examples "go to profile" do |profile_name|
    describe "Go to the profile named: '#{profile_name}'" do
        it "Go to the 'View All Profiles' area and click on to the profile tile named: #{profile_name}" do
            # make sure it goes to the profile
            @ui.goto_profile profile_name
            sleep 2
         end
    end
end

shared_examples "verify that the profile is properly saved" do
    describe "Verify that pressing the 'Save All' button will properly save the changes on the profile" do
        it "Press the 'Save All' button" do
            # @ui.click('#profile_config_save_btn')
            press_profile_save_config_no_schedule
        end
        it "Verify that no error dialog is displayed and that no tab on the profile shows the dirty flag" do
            if @ui.css('.dialogOverlay.error').exists?
                expect(@ui.css('.dialogOverlay.error')).not_to be_visible
            end
            expect(@ui.css('.dirtyIcon')).not_to be_visible
        end
    end
end

shared_examples "rename a profile" do |original_profile_name, new_profile_name|
    it_behaves_like "go to profile", original_profile_name
    describe "Change the profile name from '#{original_profile_name}' to '#{new_profile_name}'" do
        it "Set the value '#{new_profile_name}' in the 'Profile Name:' input box" do
            @ui.set_input_val('#profile_config_basic_profilename', new_profile_name)
            sleep 1
            @ui.click('#profile_config_tab_general')
            sleep 0.5
            expect(@ui.css('#profile_config_tab_general .dirtyIcon')).to be_present
            expect(@ui.css('#profile_name').text).to eq(new_profile_name)
        end
    end
    it_behaves_like "verify that the profile is properly saved"
end

shared_examples "perform changes on all tabs of a profile in order to verify the deploy to child domain" do |profile_name|
    describe "Perform changes to all the tabs of the profile named '#{profile_name}' in order to verify the 'Deploy to child Domain' function" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
        end
        it "Ensure you are on the 'GENERAL' tab" do
            go_to_profile_tab("general")
        end
        it "Change the description value to 'Description for deploy', and the Country to 'Denmark'" do
            @ui.set_textarea_val('#profile_config_basic_description', 'Description for deploy')
            sleep 0.5
            @ui.set_dropdown_entry('profile_config_basic_country', 'Denmark')
            sleep 0.5
        end
        it "Open the 'Show Advanced' controls and set the following values in the Active Directory input boxes: Admin / Admini$trator1 / dc01.xirrus.alfa.com / ALFA / Earth" do
            @ui.click('#general_show_advanced')
            sleep 0.5
            @ui.click('#has_ADswitch .switch_label')
            sleep 0.5
            @ui.set_input_val('#profile_config_basic_domain_administrator','Admin')
            sleep 0.5
            ad_pass_input = @ui.get(:text_field, {id: "profile_config_basic_domain.password"})
            ad_pass_input.click
            sleep 0.5
            @browser.send_keys "Admini$trator1"
            sleep 0.5
            ad_contr_input = @ui.get(:text_field, {id: "profile_config_basic_domain.controller"})
            ad_contr_input.click
            sleep 0.5
            @browser.send_keys "dc01.xirrus.alfa.com"
            sleep 0.5
            ad_wkg_input = @ui.get(:text_field, {id: "profile_config_basic_workgroup.domain"})
            ad_wkg_input.click
            sleep 0.5
            @browser.send_keys "ALFA"
            sleep 0.5
            @ui.set_input_val('#profile_config_basic_realm','Earth')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'SSIDS' tab" do
            go_to_profile_tab("ssids")
        end
        it "Add two SSID named 'TEST SSID 1' and 'TEST SSID 2' then the 'honeypot'" do
            @ui.click('#profile_ssid_addnew_btn')
            sleep 0.5
            @ui.set_input_val('.nssg-table tbody tr td:nth-child(3) input', 'TEST SSID 1')
            sleep 0.5
            @ui.click('#profile_ssid_addnew_btn')
            sleep 0.5
            @ui.set_input_val('.nssg-table tbody tr td:nth-child(3) input', 'TEST SSID 2')
            sleep 0.5
            @ui.click('#ssids_show_advanced')
            sleep 1.5
            @ui.click('#ssid_honeypot_btn')
            sleep 0.5
            @ui.click('#profile_config_ssids_view .commonTitle')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Set the 'honeypot' to Enabled NO, Encyption 'NONE/Radius MAC' for 'TEST SSID 1' and Access Control to 'Splash' for 'TEST SSID 2'" do
            @ui.click('#profile_config_ssids_view .commonTitle')
            sleep 0.5
            @ui.grid_verify_strig_value_on_specific_line(3, "honeypot", "div", 3, "div", "honeypot")
            @ui.click(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(6)")
            sleep 0.5
            @ui.click(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(6) .switch .switch_label")
            sleep 0.5
            @ui.click('#profile_config_ssids_view .commonTitle')
            sleep 1
            @ui.grid_verify_strig_value_on_specific_line(3, "TEST SSID 2", "div", 3, "div", "TEST SSID 2")
            @ui.click(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(8)")
            sleep 0.5
            @ui.set_dropdown_entry_by_path(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(8) .ko_dropdownlist", 'Captive Portal')
            sleep 0.5
            @ui.click('.CaptivePortalType_SPLASH')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
            @ui.click('#mce_32')
            sleep 0.5
            @ui.click('#mce_51')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 0.5
            @ui.click('#profile_config_ssids_view .commonTitle')
            sleep 1
            @ui.grid_verify_strig_value_on_specific_line(3, "TEST SSID 1", "div", 3, "div", "TEST SSID 1")
            @ui.click(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(5)")
            sleep 0.5
            @ui.set_dropdown_entry_by_path(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(5) .ko_dropdownlist", 'None/RADIUS MAC')
            sleep 0.5
            @ui.set_input_val('#host', '1.2.3.4')
            sleep 0.5
            @ui.set_input_val('#share', '123')
            sleep 0.5
            @ui.set_input_val('#share_confirm', '123')
            sleep 0.5
            @ui.click('#ssid_modal_save_btn')
            sleep 1
            @ui.click('#profile_config_ssids_view .commonTitle')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'NETWORK' tab" do
            go_to_profile_tab("network")
        end
        it "Change the 'IP Address' and 'DNS' settings to the option 'Set on AP (Don't change)'" do
            @ui.click('.profile-network-dhcpip-switch .ko-tss-right label:nth-child(2)')
        end
        it "Open the 'Show Advanced' settings and enable VLANs" do
            @ui.click('#network_show_advanced')
            sleep 0.5
            @ui.css('#profile_config_network_enableVLAN .switch_label').hover
            sleep 0.5
            @ui.css('#profile_config_network_enableVLAN .switch_label').click
            sleep 0.5
            @ui.set_input_val('#profile-config-network-vlans-input', "1")
            sleep 0.5
            @ui.click('#profile-config-network-vlans-btn')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'POLICIES' tab" do
            go_to_profile_tab("policies")
        end
        it "Add an 'SSID' policy for 'honeypot' " do
            @ui.click('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-head .policy-new-icon')
            sleep 0.5
            @ui.set_dropdown_entry('new_policy_ssids_select', "honeypot")
            sleep 0.5
            @ui.click('#new_policy_submit')
            sleep 0.5
            @ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-head .policy-head-right button').hover
            sleep 0.5
            @ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-head .policy-head-right button').click
            sleep 0.5
            @ui.click('#rule_action .switch_label')
            sleep 0.5
            @ui.set_dropdown_entry('rule_protocol', 'TCP')
            sleep 0.5
            @ui.set_dropdown_entry('rule_port', 'POP3')
            sleep 0.5
            @ui.click('#policy-rule-submit')
            sleep 1
            @ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy .policy-head .policy-head-right button').hover
            sleep 0.5
            @ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy .policy-head .policy-head-right button').click
            sleep 1
            @ui.click('#new_rule_modal div:nth-child(2) .rule-selection-container .rule-types .rule-type:nth-of-type(2) .rule-type-icon')
            sleep 0.5
            @ui.click('#policy-rule-submit')
            sleep 1
            expect(@ui.css('.dialogOverlay.success .msgbody div').text).to eq('Added 13 air cleaner policies.')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'BONJOUR' tab" do
            go_to_profile_tab("bonjour")
        end
        it "Enable Bonjour Forwarding and select ALL services" do
            @ui.click('#profile_config_bonjour_enableForwarding .switch_label')
            sleep 1
            @ui.click('#profile_config_bonjour_service_select_all')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'ADMIN' tab" do
            go_to_profile_tab("admin")
        end
        it "Set the Full Name as 'Test Account' and Email as 'test@email.com'" do
            @ui.set_input_val('#profile_config_admin_name','Test Account')
            sleep 0.5
            @ui.set_input_val('#profile_config_admin_email','test@email.com')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'OPTIMIZATION' tab" do
            go_to_profile_tab("optimization")
        end
        it "Set the 'Client - Load Balancing - acXpress & Load Balancing' optimizations to ON" do
            if !@ui.css('#optimize_client .togglebox_contents.active').exists?
                @ui.css('#optimize_client').hover
                sleep 0.5
                @ui.css('#optimize_client').click
                sleep 0.5
            end
            @ui.click('#optimization_loadbalancing_bond_switch .switch_label')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
        it "Ensure you are on the 'SERVICES' tab" do
            go_to_profile_tab("services")
        end
        it "Enable the 'Location Reporting' and set the URL value to 'https://www.google.co.uk' " do
            # @ui.click('#profile-services-location-enable')
            # sleep 0.5
            @ui.click('#profile-services-location-send-switch')
            sleep 0.5
            @ui.set_input_val('#profile-services-forward-url', "https://www.google.co.uk")
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
    end
end

def save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(dialog_overlay)
    # @ui.click('#profile_config_save_btn')
    press_profile_save_config_no_schedule
    sleep 0.3
    if dialog_overlay == true
        @ui.css('.dialogOverlay.success .msgbody div').wait_until(&:present?)
        expect(@ui.css('.dialogOverlay.success .msgbody div').text).to eq("Profile saved successfully.\nChanges will take effect momentarily")
    end
    expect(@ui.css('.temperror')).not_to be_present
    expect(@ui.css('.error')).not_to be_present
    sleep 2
    config_tabs = @ui.get(:elements, {css: "#profile_config_tabs li"})
    config_tabs.each { |config_tab|
        puts "#{config_tab.element(css: '.name').text}"
        expect(config_tab.element(:css => ".dirtyIcon")).not_to be_visible
        expect(config_tab.element(:css => ".invalidIcon")).not_to be_visible
    }
end

shared_examples "verify deployed profile has the proper configurations" do |profile_name|
    describe "Verify that the '#{profile_name}' profile has the proper configurations after it was deployed" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
        end
        it "Ensure you are on the 'GENERAL' tab" do
            go_to_profile_tab("general")
        end
        it "Verify that the description value is 'Description for deploy', and the Country is 'Denmark'" do
            expect(@ui.get(:textarea, {id: 'profile_config_basic_description'}).value).to eq('Description for deploy')
            expect(@ui.css('#profile_config_basic_country a span:nth-child(1)').text).to eq('Denmark')
        end
        it "Open the 'Show Advanced' controls and verify the values in the Active Directory input boxes: Admin / Admini$trator1 / dc01.xirrus.alfa.com / ALFA / Earth" do
            @ui.click('#general_show_advanced')
            sleep 0.5
            expect(@ui.get(:checkbox, {id: 'has_ADswitch_switch'}).value).to eq('on')
            expect(@ui.get(:checkbox, {id: 'has_ADswitch_switch'}).set?).to eq(true)
            expect(@ui.get(:input, {id: 'profile_config_basic_domain_administrator'}).value).to eq('Admin')
            #expect(@ui.get(:input, {id: 'profile_config_basic_domain.password'}).value).to eq('Admini$trator1')
            expect(@ui.get(:input, {id: 'profile_config_basic_domain.controller'}).value).to eq('dc01.xirrus.alfa.com')
            expect(@ui.get(:input, {id: 'profile_config_basic_workgroup.domain'}).value).to eq('ALFA')
            expect(@ui.get(:input, {id: 'profile_config_basic_realm'}).value).to eq('Earth')
        end
        it "Ensure you are on the 'SSIDS' tab" do
            go_to_profile_tab("ssids")
        end
        it "Verify that the grid has 3 SSIDs named 'TEST SSID 1', 'TEST SSID 2' and 'honeypot'" do
            expect(@ui.css('.nssg-table tbody').trs.length).to eq(3)
            @ui.grid_verify_strig_value_on_specific_line(3, "honeypot", "div", 3, "div", "honeypot")
            @ui.grid_verify_strig_value_on_specific_line(3, "TEST SSID 1", "div", 3, "div", "TEST SSID 1")
            @ui.grid_verify_strig_value_on_specific_line(3, "TEST SSID 2", "div", 3, "div", "TEST SSID 2")
        end
        it "Verify that the 'honeypot' is Enabled NO, 'TEST SSID 1' has Encyption 'NONE/Radius MAC' and that the 'TEST SSID 2' has Access Control set to 'NONE'" do
            verify_entire_line_in_ssid_grid("honeypot", 3, true, Hash[4 => "2.4GHz & 5GHz", 5 => "", 6 => "None/Open", 7 => "No", 8 => "Yes", 9 => "None"])
            verify_entire_line_in_ssid_grid("TEST SSID 1", 3, true, Hash[4 => "2.4GHz & 5GHz", 5 => "", 6 => "None/Open", 7 => "Yes", 8 => "Yes", 9 => "Splash"])
            verify_entire_line_in_ssid_grid("TEST SSID 2", 3, true, Hash[4 => "2.4GHz & 5GHz", 5 => "", 6 => "None/RADIUS MAC", 7 => "Yes", 8 => "Yes", 9 => "None"])
        end
        it "Ensure you are on the 'NETWORK' tab" do
            go_to_profile_tab("network")
        end
        it "Verify that the 'IP Address' and 'DNS' settings are set to the option 'Set on AP (Don't change)'" do
            expect(@ui.css('.profile-network-dhcpip-switch .ko-tss-right label:nth-child(2)').attribute_value("class")).to eq('ko-tss-label ko-tss-label-selected')
            expect(@ui.css('.profile-network-dhcp-switch .ko-tss-right label:nth-child(2)').attribute_value("class")).to eq('ko-tss-label ko-tss-label-selected')
        end
        it "Open the 'Show Advanced' settings verify that VLANs are enabled and that the entry '1' appreas" do
            if !@ui.css('#network_show_advanced').text == "Hide Advanced"
                @ui.click('#network_show_advanced')
            end
            sleep 0.5
            expect(@ui.get(:checkbox, {id: 'profile_config_network_enableVLAN_switch'}).value).to eq('on')
            expect(@ui.get(:checkbox, {id: 'profile_config_network_enableVLAN_switch'}).set?).to eq(true)
            expect(@ui.css('.togglebox_contents.active .profile-config-network-vlans .tagControlContainerWrapper .vlans_list .tag.withDelete')).to be_visible
            expect(@ui.css('.togglebox_contents.active .profile-config-network-vlans .tagControlContainerWrapper .vlans_list .tag.withDelete .text').text).to eq("(VLAN 1)")
        end
        it "Ensure you are on the 'POLICIES' tab" do
            go_to_profile_tab("policies")
        end
        it "Verify that the 'General' policy exists, has 13 air cleanear policies, and that the 'SSID' policy for 'honeypot' exists and the firewall rule has the settings: " do

            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(1) .policy .policy-head .policy-head-right .policy-rule-count').text).to eq("13 Rules")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-head .policy-head-right .policy-rule-count').text).to eq("1 Rules")
            sleep 0.5
            @ui.click('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-head .policy-toggle-icon')
            sleep 0.5
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-number').text).to eq("1.")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-name').text).to eq("Block Firewall 1")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-layer').text).to eq("Layer: 3")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-protocol').text).to eq("Protocol: TCP")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-port').text).to eq("Port: POP3")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-source').text).to eq("Source: Any")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-destination').text).to eq("Dest: Any")
            expect(@ui.css('#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-action').text).to eq("Allow/Block: BLOCK")
            expect(@ui.get(:input, {css: '#profile_config_policies .policies-container .policy-type-container:nth-of-type(2) .policy .policy-body .policy-rule-layer-container:nth-of-type(2) .policy-rules-container .policy-rule .policy-rule-enable input'}).value).to eq("on")
        end
        it "Ensure you are on the 'BONJOUR' tab" do
            go_to_profile_tab("bonjour")
        end
        it "Verify that Bonjour Forwarding is ENABLED and that ALL services are selected" do
            expect(@ui.get(:checkbox, {id: 'profile_config_bonjour_enableForwarding_switch'}).set?).to eq(true)
            services_list = @ui.get(:elements, {css: '.services_list .service_item'})
            expect(services_list.length).to eq(9)
            services_list.each { |service_item|
                expect(@ui.get(:checkbox, {css: '.mac_chk'}).set?).to eq(true)
            }
        end
        it "Ensure you are on the 'ADMIN' tab" do
            go_to_profile_tab("admin")
        end
        it "Verify that the Full Name is 'Test Account' and Email is 'test@email.com'" do
            expect(@ui.get(:input, {id: "profile_config_admin_name"}).value).to eq('Test Account')
            expect(@ui.get(:input, {id: "profile_config_admin_email"}).value).to eq('test@email.com')
        end
        it "Ensure you are on the 'OPTIMIZATION' tab" do
            go_to_profile_tab("optimization")
        end
        it "Verify that the 'Client - Load Balancing - acXpress & Load Balancing' optimizations are OFF" do
            if !@ui.css('#optimize_client .togglebox_contents.active').exists?
                @ui.css('#optimize_client').hover
                sleep 0.5
                @ui.css('#optimize_client').click
                sleep 0.5
            end
            expect(@ui.get(:checkbox, {id: 'optimization_loadbalancing_bond_switch_switch'}).set?).to eq(true)
        end
        it "Ensure you are on the 'SERVICES' tab" do
            go_to_profile_tab("services")
        end
        it "Verify that the 'Location Reporting' is enabled and the URL field is set to 'https://www.google.co.uk'" do
            expect(@ui.get(:checkbox, {css: '#profile_config_services_view .togglebox .fl_right.switch .switch_checkbox'}).set?).to eq(true)
            expect(@ui.get(:input, {css: '#profile_config_services_view .togglebox .togglebox_contents .services-field .full'}).value).to eq('https://www.google.co.uk')
        end
    end
end

shared_examples "verify that a certain profile is set as default" do |profile_name|
    describe "verify that the profile named '#{profile_name}' is set as the Default Profile" do
        it "Go to the profiles landing page" do
            @ui.view_all_profiles
        end
        it "Find the profile tile named '#{profile_name}' and verify that the 'Default' icon (star) is displayed" do
            sleep 2
            expect(@ui.get(:element, {css: '#profiles_list .tile.default'}).element(:css => ".title").text).to eq(profile_name)
            expect(@ui.get(:element, {css: '#profiles_list .tile.default'}).element(:css => ".defaultIcon.selected.icon")).to exist
        end
        it "Open the profiles dropdown list and verify that the '#{profile_name}' exists, is the first entry and has the default icon displayed" do
            @ui.click('#header_nav_profiles')
            sleep 0.5
            expect(@ui.css('#header_profiles_arrow .profile_nav.drop_menu_nav.active #profile_items')).to be_visible
            sleep 0.5
            expect(@ui.css('#profile_items .nav_item:first-child .title').text).to eq(profile_name)
            expect(@ui.css('#profile_items .nav_item:first-child .profile_icons .icon.defaultIcon.selected')).to be_visible
        end
        it "Go to My Network" do
            @ui.click('#header_nav_mynetwork')
        end
    end
end

shared_examples "create profile direct" do |profile_name|
    describe "Create profile direct" do
        it "create the profile directly" do
            @ui.create_profile_direct(profile_name)
            @browser.refresh
            sleep 1
        end
    end
end

shared_examples "create profile direct read only" do |profile_name|
    describe "Create profile direct read only" do
        it "create the profile directly read only" do
            @ui.create_profile_direct(profile_name, true)
            @browser.refresh
            sleep 1
        end
    end
end

def verify_entire_line_in_ssid_grid(verify_text, what_column, skip_vlan, verify_hash)
    grid_length = @ui.css('.nssg-table tbody').trs.length
    while grid_length > 0
        path = ".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(#{what_column}) .nssg-td-text"
        if @ui.css(path).text == verify_text
            for i in 4..verify_hash.length+4
                if skip_vlan != true and i != 5
                    path_verify = ".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(#{i}) .nssg-td-text"
                    expect(@ui.css(path)).to eq(verify_hash[i])
                end
            end
            break
        end
        grid_length -= 1
    end
end

def press_profile_save_config_no_schedule
    if @ui.css('#suggestion_box .suggestionContainer .suggestionTitle').visible?
      @ui.click('#suggestion_box .suggestionTitle')
      sleep 0.5
      @ui.click('#suggestion_hide')
    end
    @ui.click('#profile_config_save_btn')
    sleep 0.4
    @browser.button(:text => 'Push Now').wd.location_once_scrolled_into_view  
    sleep 0.4
    @browser.button(:text => 'Push Now').click
end

shared_examples "verify schedule config push panel" do |profile_name|
  describe "verify schedule config push panel for profile '#{profile_name}'" do
    it "verify NOTEs on profile schedule panel" do
      @ui.click("#header_nav_mynetwork")
      sleep 0.5
      @ui.goto_profile profile_name
      sleep 3
      @ui.click('#profile_config_save_btn')
      sleep 0.5
      expect(@ui.css('#profile-schedule-push-popover div:nth-child(2)').text).to eq("Do you want to push your configuration now, or schedule push for a later time?")
      expect(@ui.css('#profile-schedule-push-popover div:nth-child(3)').text).to eq("Note: Pushing configuration to Access Points will interrupt service for up to several minutes.")
    end
    it "verify button on profile schedule panel" do
      expect(@ui.css('#profile_config_save_btn').text).to eq("SAVE CONFIGURATION")
      expect(@ui.css('#profile-schedule-push-popover center button:nth-child(1)').text).to eq("PUSH NOW")
      expect(@ui.css('#profile-schedule-push-popover center button:nth-child(2)').text).to eq("SCHEDULE PUSH")
      expect(@ui.css('#profile-schedule-push-popover center button:nth-child(3)').text).to eq("Cancel")
    end
  end
end

shared_examples "verify schedule profile config push with Schedule button" do |profile_name, start_date, start_time, time_zone, push_note|
  describe "verify schedule profile config push with Schedule button for profile '#{profile_name}'" do
    it "set profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      set_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)      
      sleep 1
      @browser.button(:text, 'Schedule Push').click
    end
    it "verify profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      verify_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)
    end
  end
end
shared_examples "verify schedule profile config push with Push Now button" do |profile_name, start_date, start_time, time_zone, push_note|
  describe "verify schedule profile config push with Push Now button for profile '#{profile_name}'" do
    it "set profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      set_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)      
      sleep 1
      @browser.button(:text, 'Push Now').click
    end
    it "verify profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      verify_profile_configuration_push_on_schedule_data(profile_name,"", "", "(GMT-08:00) Pacific Time (US & Canada)", "Add notes here to capture the configuration changes that you made.")
    end
  end
end

shared_examples "verify schedule profile config push with Cancel button" do |profile_name, start_date, start_time, time_zone, push_note|
  describe "verify schedule profile config push with Cancel button for profile '#{profile_name}'" do
    it "set profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      set_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)      
      sleep 1
      @browser.button(:text, 'Cancel').click
    end
    it "verify profile configuration push on schedule for '#{start_date}', '#{start_time}', '#{time_zone}" do
      verify_profile_configuration_push_on_schedule_data(profile_name,"", "", "(GMT-08:00) Pacific Time (US & Canada)", "Add notes here to capture the configuration changes that you made.")
    end
  end
end
def set_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)
  if @ui.css('#profile-schedule-push-popover').visible?
     @browser.button(:text => 'Push Now').wd.location_once_scrolled_into_view 
     sleep 0.4
     @browser.button(:text => 'Cancel').click
   end
  sleep 0.5
  @ui.goto_profile profile_name
  sleep 3
  @ui.click('#profile_config_save_btn')
  sleep 0.5
  @ui.set_val_for_input_field('#profile-schedule-push-startdate', start_date)
  sleep 1
  @ui.click('#profile-schedule-push-starttime')
  sleep 0.5
  @ui.set_val_for_input_field('#profile-schedule-push-starttime', start_time)
  sleep 1
  @ui.set_dropdown_entry_by_path('.profile-schedule-push-inputs .ko_dropdownlist', time_zone)
  sleep 2
  @ui.set_textarea_val('.profile-schedule-push-controls .profile-schedule-push-inputs .customext_input', push_note)
end
def verify_profile_configuration_push_on_schedule_data(profile_name, start_date, start_time, time_zone, push_note)
  if @ui.css('#profile-schedule-push-popover').visible?
     @browser.button(:text => 'Push Now').wd.location_once_scrolled_into_view 
     sleep 0.4
     @browser.button(:text => 'Cancel').click
   end
  sleep 0.5
  @ui.goto_profile profile_name
  sleep 3
  @ui.click('#profile_config_save_btn')
  sleep 0.5
  expect(@ui.get(:input, {id: 'profile-schedule-push-startdate'}).value).to eq(start_date)
  expect(@ui.get(:input, {id: 'profile-schedule-push-starttime'}).value).to eq(start_time)
  expect(@ui.css('.profile-schedule-push-inputs .ko_dropdownlist').text).to eq(time_zone)
  expect(@ui.get(:textarea, {css: '.profile-schedule-push-controls .profile-schedule-push-inputs .customext_input'}).value).to eq(push_note) 
  @browser.button(:text => 'Push Now').wd.location_once_scrolled_into_view 
  sleep 0.4
  @browser.button(:text => 'Cancel').click  
end