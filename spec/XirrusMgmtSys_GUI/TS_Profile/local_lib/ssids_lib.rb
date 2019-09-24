require_relative "profile_lib.rb"

def find_mce_menu_button_and_menu_item_button(mce_widget_text_value, mce_text_value)
    @ui.get(:elements , {css: ".mce-widget"}).each { |mce_widget|
        if mce_widget.span.exists?
            if mce_widget.text == mce_widget_text_value
                mce_widget.button.click
            end
        end
    }
    sleep 1
    mce_containers = @ui.get(:elements , {css: ".mce-container"})
    mce_containers.each { |mce_container|
        if !mce_container.attribute_value("style").include?("display: none")
            mce_container.elements(css: ".mce-text").each { |mce_text|
                if mce_text.text == mce_text_value
                    mce_text.click
                end
            }
        end
    }
end

shared_examples "add profile ssid" do |profile_name, ssid_name|
   describe "Add profile ssid" do
        it "Navigate to the profile named: #{profile_name}" do
            @ui.click('#header_logo')
            sleep 2
            @ui.goto_profile profile_name
            sleep 1
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end

        it "Press the '+ New SSID' button" do
            @ui.click('#profile_ssid_addnew_btn')
        end
        it "Set the 'SSID Name' field value to #{ssid_name} and press the 'Save All' button " do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.set_input_val("#profile_ssids_grid_ssidName_inline_edit_"+tr.id, ssid_name)
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 3
            if @ui.css('.dialogOverlay.loading .dialogBox.loading .msgbody').exists?
                @browser.refresh
            end
        end
        it "Expected Result: - the 'SSID Name' field value is #{ssid_name}" do
            tr = @ui.css('.nssg-table tbody')
            tr.wait_until_present
            trs_length = @ui.css('.nssg-table tbody').trs.length
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    break
                end
                trs_length-=1
            end
            name_val = @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .ssidName div")
            name_val.wait_until_present
            expect(name_val.title).to eq(ssid_name)
        end
   end
end

shared_examples "quick add 8 profile ssids" do |profile_name, ssid_name|
    describe "Add 8 profile SSIDs for the profile named '#{profile_name}'" do
        it "Navigate to the profile named: #{profile_name}" do
            @ui.click('#header_logo')
            sleep 2
            @ui.goto_profile profile_name
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 0.5
            @ui.css('#profile_ssid_addnew_btn').wait_until_present
        end
        it "Add 8 profile SSIDs with the name '#{ssid_name}'" do
            (1..8).each_with_index do |rr, index|
                a = index + 1
                puts "a = #{a} _____________________"
                @ui.click('#profile_ssid_addnew_btn')
                tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
                tr.wait_until_present
                sleep 3
                @ui.css("#profile_ssids_grid_ssidName_inline_edit_"+tr.id).wait_until_present
                @ui.set_input_val("#profile_ssids_grid_ssidName_inline_edit_"+tr.id, ssid_name + "#{a}")
                sleep 3
                @ui.click("#profile_config_ssids_view .commonTitle")
                sleep 2
            end
        end
        it "Verify that all 8 ssids are properly entered" do
            table_length = @ui.css('.nssg-table tbody').trs.length
            expect(table_length).to eq(8)
            #while table_length > 0
            #    name_val = @ui.css('.nssg-table tbody tr:nth-child(#table_length) .ssidName div')
            #    name_val.wait_until_present
            #    if name_val == ssid_name
            #        expect(name_val.title).to eq(ssid_name)
            #    end
            #    table_length -= 1
            #end
        end
        it "Save the profile" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
    end
end

shared_examples "edit profile ssid" do |profile_name|
    describe "Edit profile ssid main configurations" do
        before :all do
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an SSID and change the band to 5Ghz" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .band div')

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .band span', '5GHz')
            #@ui.set_dropdown_entry('.nssg-table tbody tr:nth-child(1) .band ', '5GHz')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the band cell has the value '5Ghz'" do
            band = @ui.css('.nssg-table tbody tr:nth-child(1) .band div')
            band.wait_until_present
            expect(band.title).to eq('5GHz')
        end

        it "Edit an SSID and change the band to 2.4Ghz" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .band div')

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .band span', '2.4GHz')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the band cell has the value '2.4Ghz'" do

            band = @ui.css('.nssg-table tbody tr:nth-child(1) .band div')
            band.wait_until_present
            expect(band.title).to eq('2.4GHz')
        end

        it "Edit an SSID and set the status to 'disabled'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled div')

            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the 'Enabled' cell has the string 'No'" do
            enable_val = @ui.css('.nssg-table tbody tr:nth-child(1) .enabled div')
            enable_val.wait_until_present
            expect(enable_val.title).to eq('No')
        end
        it "Edit an SSID and set the status to 'Enabled'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled div')

            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the 'Enabled' cell has the string 'Yes'" do
            enable_val = @ui.css('.nssg-table tbody tr:nth-child(1) .enabled div')
            enable_val.wait_until_present
            expect(enable_val.title).to eq('Yes')
        end

        it "Edit an SSID and turn the Broadcast to 'off'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .broadcast div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .broadcast .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the 'Broadcast' cell has the string 'No'" do
            broadcast_val = @ui.css('.nssg-table tbody tr:nth-child(1) .broadcast div')
            broadcast_val.wait_until_present
            expect(broadcast_val.title).to eq('No')
        end
        it "Edit an SSID and turn the Broadcast to 'on'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .broadcast div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .broadcast .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the 'Broadcast' cell has the string 'Yes'" do
            broadcast_val = @ui.css('.nssg-table tbody tr:nth-child(1) .broadcast div')
            broadcast_val.wait_until_present
            expect(broadcast_val.title).to eq('Yes')
        end

    end
end

shared_examples "edit profile ssid encryption/auth general method" do |profile_name, ssid_name, encry_auth_type, encry_mode, auth_mode|
    describe "Edit profile ssid encryption/auth to WPA2/802.1x + Encryption AES + Authentication PSK" do
        it "Ensure you are on the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
            sleep 2
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an SSID (named '#{ssid_name}') and set 'Encryption/Authentication' to '#{encry_auth_type}' + Encryption '#{encry_mode}' + Authentication '#{auth_mode}'" do
            tr = @ui.css('.nssg-table tbody')
            tr.wait_until_present
            trs_length = @ui.css('.nssg-table tbody').trs.length
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    break
                end
                trs_length-=1
            end
            @ui.click(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth div")
            sleep 1
            @ui.set_dropdown_entry_by_path(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth span", encry_auth_type)
            sleep 1
        end
        it "Set the Encryption mode to '#{encry_mode}'" do
            expect(@ui.css("#encryption_modal")).to be_present
            sleep 0.5
            case encry_mode
            when "AES"
                @ui.click('#aes + .mac_radio_label')
            when "TKIP"
                @ui.click('#tkip + .mac_radio_label')
            when "AES & TKIP"
                @ui.click('#aes_tkip + .mac_radio_label')
            end
            sleep 1
        end
        it "Advance to the Authentication tab" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1.8
            expect(@ui.css("#authentication_modal")).to be_present
        end
        it "Set the Authentication method to '#{auth_mode}'" do
            @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', auth_mode)
            sleep 1
        end
        it "Depending on what Authentication method was used set the proper values (#{auth_mode})" do
            case auth_mode
            when "PSK"
                @ui.set_input_val('#preshare', '1234567890')
                sleep 0.5
                @ui.set_input_val('#preshare_confirm', '1234567890')
                sleep 1
            when "EAP"
                sleep 2
                @ui.click('#encryption_accountingSwitch .switch_label')
                puts "????"
                sleep 2
                @ui.click('#ssid_modal_use_altaccount')
                sleep 1
                @ui.set_input_val('#host', '1.2.3.4')
                sleep 0.5
                @ui.set_input_val('#port', '111')
                sleep 0.5
                @ui.set_input_val('#share', '12345678')
                sleep 0.5
                @ui.set_input_val('#share_confirm', '12345678')
                sleep 0.5
                @ui.click('#ssid_modal_addsecnd_sec_btn')
                sleep 0.5
                @ui.set_input_val('#secondary_host', '2.2.3.4')
                sleep 0.5
                @ui.set_input_val('#secondary_port', '211')
                sleep 0.5
                @ui.set_input_val('#secondary_share', '22345678')
                sleep 0.5
                @ui.set_input_val('#secondary_share_confirm', '22345678')
                sleep 0.5

                sleep 0.5

                sleep 0.5
                @ui.set_input_val('#primary_accounting_host', '3.2.3.4')
                sleep 0.5
                @ui.set_input_val('#primary_accounting_port', '311')
                sleep 0.5
                @ui.set_input_val('#primary_accounting_share', '32345678')
                sleep 0.5
                @ui.set_input_val('#primary_accounting_share_confirm', '32345678')
                sleep 1
                @ui.click('#ssid_modal_addsecnd_auth_btn')
                sleep 0.5
                @ui.set_input_val('#secondary_accounting_host', '4.2.3.4')
                sleep 0.5
                @ui.set_input_val('#secondary_accounting_port', '411')
                sleep 0.5
                @ui.set_input_val('#secondary_accounting_share', '42345678')
                sleep 0.5
                @ui.set_input_val('#secondary_accounting_share_confirm', '42345678')
                sleep 0.5
                @ui.set_input_val('#accounting_radius_interval', '200')
                sleep 1
            when "Active Directory"
                @ui.set_dropdown_entry('profile_config_basic_primaryauthentication','Active Directory')
                sleep 1
            end
            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal" do
            tr = @ui.css('.nssg-table tbody')
            tr.wait_until_present
            trs_length = @ui.css('.nssg-table tbody').trs.length
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    break
                end
                trs_length-=1
            end
            @ui.click(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth div")
            sleep 1
            @ui.click(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth .nssg-td-action-container")
            sleep 1
        end
        it "Verify that the proper Encryption mode is selected" do
            expect(@ui.css("#encryption_modal")).to be_present
            sleep 0.5
            case encry_mode
            when "AES"
                expect(@ui.get(:radio , {id: 'aes'}).set?).to eq(true)
            when "TKIP"
                expect(@ui.get(:radio , {id: 'tkip'}).set?).to eq(true)
            when "AES & TKIP"
                expect(@ui.get(:radio , {id: 'aes_tkip'}).set?).to eq(true)
            end
            sleep 1
        end
        it "Change to the Authentication tab" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that the values are properly displayed: (--------) for PSK; host, port and key as (--------) for EAP; Active Directory elements for AD" do
            expect(@ui.css("#authentication_modal")).to be_present
            sleep 0.5
            case auth_mode
            when "PSK"
                p = @ui.get(:text_field, {id: 'preshare' })
                p.wait_until_present
                expect(p.value).to eq("--------")
            when "EAP"
                p = @ui.get(:text_field, {id: 'host' })
                p.wait_until_present
                expect(p.value).to eq("1.2.3.4")
                p = @ui.get(:text_field, {id: 'port' })
                p.wait_until_present
                expect(p.value).to eq("111")
                p = @ui.get(:text_field, {id: 'share' })
                p.wait_until_present
                expect(p.value).to eq("--------")
                sleep 0.5
                p = @ui.get(:text_field, {id: 'secondary_host' })
                p.wait_until_present
                expect(p.value).to eq("2.2.3.4")
                p = @ui.get(:text_field, {id: 'secondary_port' })
                p.wait_until_present
                expect(p.value).to eq("211")
                p = @ui.get(:text_field, {id: 'secondary_share' })
                p.wait_until_present
                expect(p.value).to eq("--------")
                sleep 0.5
                p = @ui.get(:text_field, {id: 'primary_accounting_host' })
                p.wait_until_present
                expect(p.value).to eq("3.2.3.4")
                p = @ui.get(:text_field, {id: 'primary_accounting_port' })
                p.wait_until_present
                expect(p.value).to eq("311")
                p = @ui.get(:text_field, {id: 'primary_accounting_share' })
                p.wait_until_present
                expect(p.value).to eq("--------")
                sleep 0.5
                p = @ui.get(:text_field, {id: 'secondary_accounting_host' })
                p.wait_until_present
                expect(p.value).to eq("4.2.3.4")
                p = @ui.get(:text_field, {id: 'secondary_accounting_port' })
                p.wait_until_present
                expect(p.value).to eq("411")
                p = @ui.get(:text_field, {id: 'secondary_accounting_share' })
                p.wait_until_present
                expect(p.value).to eq("--------")
                sleep 0.5
                p = @ui.get(:text_field, {id: 'accounting_radius_interval' })
                p.wait_until_present
                expect(p.value).to eq("200")
            when "Active Directory"
                expect(@ui.css('#profile_config_ad')).to exist
                expect(@ui.css('#profile_config_ad span').text).to eq("To configure your Active Directory settings")
                expect(@ui.css('#profile_config_ad a').text).to eq("follow this link.")
                expect(@ui.css('#profile_config_ad a').attribute_value("data-bind")).to include("click: goToGeneral")
            end
        end
        it "Close the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string '#{encry_auth_type}'" do
            tr = @ui.css('.nssg-table tbody')
            tr.wait_until_present
            trs_length = @ui.css('.nssg-table tbody').trs.length
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    break
                end
                trs_length-=1
            end
            eauth_val = @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth div")
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq(encry_auth_type)
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
           tr = @ui.css('.nssg-table tbody')
            tr.wait_until_present
            trs_length = @ui.css('.nssg-table tbody').trs.length
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    break
                end
                trs_length-=1
            end
            @ui.click(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth div")
            sleep 1
            @ui.set_dropdown_entry_by_path(".nssg-table tbody tr:nth-child(#{trs_length}) .encryptionAuth span", 'None/Open')
            sleep 0.5
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit profile ssid encryption/auth - WEP/Open" do |profile_name|
    describe "Edit profile ssid encryption/auth to 'WEP/Open'" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an SSID and set the 'Encryption/Authentication' to 'WEP/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5)')
            #@ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'WEP/Open')
            sleep 1
        end
        it "Fill in all the security keys" do

            @ui.set_input_val('#wep_key_1', '1234567890')
            @ui.set_input_val('#confirm_wep_key_1', '1234567890')
            @ui.set_input_val('#wep_key_2', '2234567890')
            @ui.set_input_val('#confirm_wep_key_2', '2234567890')
            @ui.set_input_val('#wep_key_3', '3234567890')
            @ui.set_input_val('#confirm_wep_key_3', '3234567890')
            @ui.set_input_val('#wep_key_4', '4234567890')
            @ui.set_input_val('#confirm_wep_key_4', '4234567890')

            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end
        it "Save the profile and reopen the 'Encryption & Authentication' modal" do

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            #@ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div').hover
            @ui.show_needed_control('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div').click
            sleep 1
        end
        it "Verify that the security keys are properly displayed (--------)" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            wep1 = @ui.get(:text_field, {id: 'wep_key_1' })
            wep1.wait_until_present
            expect(wep1.value).to eq("--------")

            wep2 = @ui.get(:text_field, {id: 'wep_key_2' })
            wep2.wait_until_present
            expect(wep2.value).to eq("--------")

            wep3 = @ui.get(:text_field, {id: 'wep_key_3' })
            wep3.wait_until_present
            expect(wep3.value).to eq("--------")

            wep4 = @ui.get(:text_field, {id: 'wep_key_4' })
            wep4.wait_until_present
            expect(wep4.value).to eq("--------")

            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'WEP/Open'" do
            if @ui.css('#ssid_encrypt_auth_modal').exists? and @ui.css('#ssid_encrypt_auth_modal').visible?
                @ui.click('#ssid_modal_cancel_btn')
            end
            @ui.click("#profile_config_ssids_view .commonTitle")
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WEP/Open')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            #reset
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
    end
end

shared_examples "edit profile ssid encryption/auth - WPA2/802.1x PSK" do |profile_name|
    describe "Edit profile ssid encryption/auth to WPA2/802.1x + Encryption AES + Authentication PSK" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an SSID and set 'Encryption/Authentication' to WPA2/802.1x + Encryption AES + Authentication PSK" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'WPA2/802.1x')
            sleep 1
        end
        it "Advance to the Authentication tab" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Add pre-shared keys and save the modal" do
            @ui.set_input_val('#preshare', '1234567890')
            @ui.set_input_val('#preshare_confirm', '1234567890')

            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end

        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that the pre-shared key is properly displayed (--------)" do
            p = @ui.get(:text_field, {id: 'preshare' })
            p.wait_until_present
            expect(p.value).to eq("--------")
        end
        it "Close the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'WPA2/802.1x'" do
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA2/802.1x')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            #reset
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit profile ssid encryption/auth - WPA2/802.1x EAP" do |profile_name|
    describe "Edit profile ssid encryption/auth to WPA2/802.1x + Encryption AES + Authentication EAP" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and set encryption/auth to WPA2/802.1x EAP" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'WPA2/802.1x')
            sleep 1
        end
        it "Advance to the Authentication tab" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Set primary Authentication as 'EAP'" do
            @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', 'EAP')
        end
        it "Add 'Secondary RADIUS Server', use accounting, use 'Alternate Accounting Server', add 'Secondary Accounting Server'" do
            @ui.click('#ssid_modal_addsecnd_sec_btn')
            @ui.click('#encryption_accountingSwitch .switch_label')
            @ui.click('#ssid_modal_use_altaccount')
            @ui.click('#ssid_modal_addsecnd_auth_btn')
        end
        it "Set the External RADIUS Server's values" do
            @ui.set_input_val('#host', '1.2.3.4')
            @ui.set_input_val('#port', '111')
            @ui.set_input_val('#share', '12345678')
            @ui.set_input_val('#share_confirm', '12345678')
        end
        it "Set the External Secondary RADIUS Server's values" do
            @ui.set_input_val('#secondary_host', '2.2.3.4')
            @ui.set_input_val('#secondary_port', '211')
            @ui.set_input_val('#secondary_share', '22345678')
            @ui.set_input_val('#secondary_share_confirm', '22345678')
        end
        it "Set the primary Accounting Server's values" do
            @ui.set_input_val('#primary_accounting_host', '3.2.3.4')
            @ui.set_input_val('#primary_accounting_port', '311')
            @ui.set_input_val('#primary_accounting_share', '32345678')
            @ui.set_input_val('#primary_accounting_share_confirm', '32345678')
        end
        it "Set the secondary Accounting Server's values and set 200 seconds frequency for RADIUS accounting" do
            @ui.set_input_val('#secondary_accounting_host', '4.2.3.4')
            @ui.set_input_val('#secondary_accounting_port', '411')
            @ui.set_input_val('#secondary_accounting_share', '42345678')
            @ui.set_input_val('#secondary_accounting_share_confirm', '42345678')

            @ui.set_input_val('#accounting_radius_interval', '200')
        end
        it "Save the modal" do
            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal and go to the Authentication tab" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that all values coincide with the previously assigned ones" do
            p = @ui.get(:text_field, {id: 'host' })
            p.wait_until_present
            expect(p.value).to eq("1.2.3.4")
            p = @ui.get(:text_field, {id: 'port' })
            p.wait_until_present
            expect(p.value).to eq("111")
            p = @ui.get(:text_field, {id: 'share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_host' })
            p.wait_until_present
            expect(p.value).to eq("2.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_port' })
            p.wait_until_present
            expect(p.value).to eq("211")
            p = @ui.get(:text_field, {id: 'secondary_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'primary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("3.2.3.4")
            p = @ui.get(:text_field, {id: 'primary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("311")
            p = @ui.get(:text_field, {id: 'primary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("4.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("411")
            p = @ui.get(:text_field, {id: 'secondary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'accounting_radius_interval' })
            p.wait_until_present
            expect(p.value).to eq("200")
        end
        it "CLose the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'WPA2/802.1x'" do
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA2/802.1x')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            #reset
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit profile ssid encryption/auth - WPA & WPA2/802.1x TKIP PSK" do |profile_name|
    describe "Edit profile ssid encryption/auth to WPA & WPA2/802.1x + Encryption TKIP + Authentication PSK" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and set encryption/auth to WPA & WPA2/802.1x" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'WPA & WPA2/802.1x')
            sleep 1
        end
        it "Set the Encryption to TKIP" do
            @browser.execute_script('$(\'#tkip\').click()')
            #@ui.click('#tkip')
            sleep 1
        end
        it "Advance to the Authentication tab and ensure the method set is 'PSK'" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1
            @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', 'PSK')
            sleep 1
        end
         it "Add pre-shared keys and save the modal" do
            @ui.set_input_val('#preshare', '1234567890')
            @ui.set_input_val('#preshare_confirm', '1234567890')

            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end

        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that the pre-shared key is properly displayed (--------)" do
            p = @ui.get(:text_field, {id: 'preshare' })
            p.wait_until_present
            expect(p.value).to eq("--------")
        end
        it "Close the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'WPA & WPA2/802.1x'" do
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA & WPA2/802.1x')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            #reset
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit profile ssid encryption/auth - WPA/802.1x AES & TKIP AD" do |profile_name|
    describe "Edit profile ssid encryption/auth to WPA/802.1x + Encryption AES & TKIP + Authentication Active Directory" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and set encryption/auth to WPA/802.1x" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'WPA/802.1x')
            sleep 1
        end
        it "Set the Encryption to AES & TKIP" do
            @browser.execute_script('$(\'#tkip\').click()')
            #@ui.click('#aes_tkip')
            sleep 1
        end
        it "Advance to the Authentication tab" do
            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
         it "Set the Authentication dropdown list to 'Active Directory'" do
            @ui.set_dropdown_entry('profile_config_basic_primaryauthentication','Active Directory')
            sleep 1
            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(false)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that the Active Directory description and link appears" do
            expect(@ui.css('#profile_config_ad')).to exist
           ################################### TO ADD ASSERTIONS
        end
        it "Close the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'WPA/802.1x'" do
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA/802.1x')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            #reset
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit profile ssid encryption/auth - None/RADIUS MAC" do |profile_name|
    describe "Edit profile ssid encryption/auth to None/RADIUS MAC" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and set encryption/auth to None/RADIUS MAC" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/RADIUS MAC')
            sleep 1
        end
        it "Add 'Secondary RADIUS Server', use accounting, use 'Alternate Accounting Server', add 'Secondary Accounting Server'" do
            @ui.click('#ssid_modal_addsecnd_sec_btn')
            @ui.click('#encryption_accountingSwitch .switch_label')
            @ui.click('#ssid_modal_use_altaccount')
            @ui.click('#ssid_modal_addsecnd_auth_btn')
        end
        it "Set the External RADIUS Server's values" do
            @ui.set_input_val('#host', '1.2.3.4')
            @ui.set_input_val('#port', '111')
            @ui.set_input_val('#share', '12345678')
            @ui.set_input_val('#share_confirm', '12345678')
        end
        it "Set the External Secondary RADIUS Server's values" do
            @ui.set_input_val('#secondary_host', '2.2.3.4')
            @ui.set_input_val('#secondary_port', '211')
            @ui.set_input_val('#secondary_share', '22345678')
            @ui.set_input_val('#secondary_share_confirm', '22345678')
        end
        it "Set the primary Accounting Server's values" do
            @ui.set_input_val('#primary_accounting_host', '3.2.3.4')
            @ui.set_input_val('#primary_accounting_port', '311')
            @ui.set_input_val('#primary_accounting_share', '32345678')
            @ui.set_input_val('#primary_accounting_share_confirm', '32345678')
        end
        it "Set the secondary Accounting Server's values and set 200 seconds frequency for RADIUS accounting" do
            @ui.set_input_val('#secondary_accounting_host', '4.2.3.4')
            @ui.set_input_val('#secondary_accounting_port', '411')
            @ui.set_input_val('#secondary_accounting_share', '42345678')
            @ui.set_input_val('#secondary_accounting_share_confirm', '42345678')

            @ui.set_input_val('#accounting_radius_interval', '200')
        end
        it "Save the modal" do
            @ui.click('#ssid_modal_save_btn')
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Reopen the 'Encryption/Authentication' modal and go to the Authentication tab" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth .nssg-td-action-container')

            @ui.click('#ssid_modal_tab_auth')
            sleep 1
        end
        it "Verify that all values coincide with the previously assigned ones" do
            p = @ui.get(:text_field, {id: 'host' })
            p.wait_until_present
            expect(p.value).to eq("1.2.3.4")
            p = @ui.get(:text_field, {id: 'port' })
            p.wait_until_present
            expect(p.value).to eq("111")
            p = @ui.get(:text_field, {id: 'share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_host' })
            p.wait_until_present
            expect(p.value).to eq("2.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_port' })
            p.wait_until_present
            expect(p.value).to eq("211")
            p = @ui.get(:text_field, {id: 'secondary_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'primary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("3.2.3.4")
            p = @ui.get(:text_field, {id: 'primary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("311")
            p = @ui.get(:text_field, {id: 'primary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("4.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("411")
            p = @ui.get(:text_field, {id: 'secondary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'accounting_radius_interval' })
            p.wait_until_present
            expect(p.value).to eq("200")
        end
        it "CLose the modal" do
            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Verify that the 'Encryption/Authentication' cell has the string 'None/RADIUS MAC'" do
            eauth_val = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('None/RADIUS MAC')
        end
        it "Return the 'Encryption/Authentication' option to 'None/Open'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            #reset
            @ui.click('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            sleep 1
            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "delete profile ssids" do |profile_name|
    describe "Delete ALL the SSIDs assigned to a profile" do
        it "Navigate to the profile named: #{profile_name}" do

            @ui.goto_profile profile_name
            sleep 1
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end
        it "Place a tick in the checkbox for the SSID line" do
            @ui.click('.nssg-table thead tr th:nth-child(2) .mac_chk_label')
            sleep 1
        end
        it "Press the 'Delete' button" do
            @ui.click('#ssid_delete_btn')
            sleep 1
        end
        it "Press the 'Remove SSIDs' button on the confirmation prompt" do
            @ui.confirm_dialog
            sleep 1
        end
        it "Expected Result: - the SSID line is properly removed from the grid" do
            grid = @ui.css('.nssg-table')
            grid.wait_until_present
            expect(grid.trs.length).to eq(1)
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
    end
end

shared_examples "add honeypot ssid" do |profile_name|
   describe "Add honeypot ssid" do
      it "Navigate to the profile named: #{profile_name}" do

            @ui.goto_profile profile_name
            sleep 1
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end

        it "Enable the 'Show Advanced' option" do
            @ui.click('#ssids_show_advanced');
            sleep 1
        end
        it "Click on the 'Add Honeypot' button" do
            @ui.click('#ssid_honeypot_btn');
            sleep 1
        end

        it "Click on the profiles' line in the grid then press the 'Save All' button" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Expected results: - name value should be 'honeypot' " do
            name_val = @ui.css('.nssg-table tbody tr:nth-child(1) .ssidName div')
            name_val.wait_until_present
            expect(name_val.title).to eq('honeypot')

        end
   end
end

shared_examples "edit honeypot ssid" do |profile_name|
   describe "Edit honeypot ssid" do
       it "Navigate to the profile named: #{profile_name}" do

            @ui.goto_profile profile_name
            sleep 1
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end
        it "Ensure that the 'honeypot' line is in the grid and click on it" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled div')
            sleep 1
        end
        it "Set the Enabled switch control to NO" do
            @ui.click('.nssg-table tbody tr:nth-child(1) .enabled .switch .switch_label')
            sleep 1
        end
        it "Click outside the grid and then click on the 'Save All' button" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Expected results: - name value should be 'honeypot' " do
            name_val = @ui.css('.nssg-table tbody tr:nth-child(1) .ssidName div')
            name_val.wait_until_present
            expect(name_val.title).to eq('honeypot')
        end
        it "Expected result: - 'Enabled' switch should be set to NO " do
            enable_val = @ui.css('.nssg-table tbody tr:nth-child(1) .enabled div')
            enable_val.wait_until_present
            expect(enable_val.title).to eq('No')
        end
   end
end

shared_examples "delete honeypot ssid" do |profile_name|
   describe "Delete honeypot ssid" do
       it "Navigate to the profile named: #{profile_name}" do

            @ui.goto_profile profile_name
            sleep 1
        end
        it "Go to the SSIDs tab" do
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end

        it "Place a tick in the checkbox for the honeypot line" do
            @ui.click('.nssg-table thead tr th:nth-child(2) .mac_chk_label')
            sleep 1
        end
        it "Press the 'Delete' button" do
            @ui.click('#ssid_delete_btn')
            sleep 1
        end
        it "Confirm the deletion process" do
            @ui.confirm_dialog
            sleep 1
        end

        it "Expected result: - the grid does not contain the 'honeypot' line" do
            grid = @ui.css('.nssg-table')
            grid.wait_until_present
            expect(grid.trs.length).to eq(1)
        end
   end
end

shared_examples "toggle vlans from ssids" do |profile_name|
    describe "toggle vlans" do

            it "Navigate to the profile named: #{profile_name}" do

                @ui.goto_profile profile_name
                sleep 1
            end
                it "Go to the SSIDs tab" do
                @ui.click('#profile_config_tab_ssids')
                sleep 1
            end

        it "Press the 'Enable VLANs' hyperlink" do
            vlan = @ui.id('toggle_vlan')
            vlan.wait_until_present

            if vlan.text.include?"Enable VLANs"
                  puts 'Turn on vlans'
                  @ui.click('#toggle_vlan')
            else
                  puts 'Turn off vlans'
                  @ui.click('#toggle_vlan')
                  sleep 3
                  if @ui.css(".dialogBox.confirm").exists?
                    @ui.confirm_dialog
                end
            end
        end

        it "Press the 'Save All' button" do
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        end
    end
end

shared_examples "profile ssids vlans" do |profile_name|
    describe "profile ssids vlans" do

            it "Navigate to the profile named: #{profile_name}" do

                @ui.goto_profile profile_name
                sleep 1
            end
                it "Go to the SSIDs tab" do
                @ui.click('#profile_config_tab_ssids')
                sleep 1
            end

        it "Click on the VLAN cell from the SSID line and set the VLAN id to '111'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5)')
            sleep 1

            @ui.set_input_val('#profile_ssids_grid_vlanOverrides_select_' + tr.id + ' .spinner input',"111")
        end
        it "Click outside the grid and then click on the 'Save All' button" do
            sleep 2
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 1

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 2
        end
        it "Expected result: - the VLAN cell contains the text 'Primary (VLAN 111)'" do
            vlan = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) div .input.disabled .tagWrapper span:first-child .text')
            #vlan = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper .tag .text')
            vlan.wait_until_present
            expect(vlan.text).to eq('Primary (VLAN 111)')
        end

        it "Click on the 'Edit VLANs' button" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5)')
            sleep 2
            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5) .spinner input')
            sleep 1

            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5) .nssg-td-action-container .button.orange')
        end

        it "Add 31 more VLANs and press the 'Save All' button" do
            $i = 300
            $num = 331
            while $i < $num do
                  name = "vlan" + $i.to_s
                  @ui.set_input_val('#vlan_name_field .ko_dropdownlist_combo_input', name)
                  sleep 1
                  if @ui.css('.ko_dropdownlist_list.active ul li').present?
                    @ui.click('.ko_dropdownlist_list.active ul li')
                    sleep 1
                  end
                  if @ui.css('#ko_dropdowlist_overlay').exists?
                    if @ui.css('#ko_dropdowlist_overlay').attribute_value("style") == "display: block;"
                        @browser.execute_script('$("#ko_dropdowlist_overlay").hide()')
                        sleep 0.5
                    end
                  end
                  @ui.click('#vlan_modal .commonTitle')
                  @ui.set_input_val('#vlan_number_field', $i.to_s)
                  @ui.click('#ssid_vlan_add_btn')
                  sleep 1
                  $i += 1
            end
            sleep 2

            @ui.click('#vlan_modal .buttons .orange')
            sleep 2

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end

        it "Expected result: - the VLAN cell contains the text 'Primary (VLAN 111) '+31' '" do
            expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) .tagWrapper .remainder').text).to eq('+31')

            @ui.click("#profile_config_ssids_view .commonTitle")
        end

        it "Click on the '+31' VLANs box" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(5) .tagWrapper .remainder')
            sleep 1

            tt = @ui.css('.tooltip')
            tt.wait_until_present
        end
        it "Press the 'Delete' (x) button" do
            @ui.click('.tooltip .withDelete .delete')
            sleep 1
        end
        it "Press the 'Remove tag' button" do
            @ui.confirm_dialog
            sleep 1
        end
        it "Press the 'Save All' button" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Expected result: - the VLAN cell contains the text 'Primary (VLAN 111) '+30' '" do
            expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(5) .tagWrapper .remainder').text).to eq('+30')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit an ssid and verify setup captive portal modal splash page internal" do |profile_name|
    describe "Edit and SSID and verify that the setup captive portal modal contains the proper controls" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
            @ui.css('#profile_config_tab_ssids').wait_until_present
            @ui.click('#profile_config_tab_ssids')
            sleep 3
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'Splash Page (Host on Xirrus Access Point)'" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
        end
        it "Set the 'Redirect Timeout' to 60 seconds" do
            expect(@ui.css('#captiveportal_timeout_switch').parent.span.text).to eq("Would you like to set a duration of time before the splash page disappears (without clicking) and the user is redirected to the URL of their choice?")
            @ui.click('#captiveportal_timeout_switch')
            sleep 1
            @ui.set_input_val("#captiveportal_timeout", "60")
        end
        it "Verify that the 'Session Timeout' control isn't visible" do
            expect(@ui.css('#captiveportal_authtimeout_switch')).not_to be_visible
        end
        it "Open the 'Show Advanced' container and set the landing page to the value 'https://www.landing.page.org'" do
            expect(@ui.css("#landing").parent.parent.parent.p.text).to eq("")
            @ui.click('#captiveportal_showadvanced')
            sleep 1
            @browser.execute_script('$(\'#landing\').click()')
            @browser.execute_script('$(\'#landing\').click()')
            sleep 1
            #@ui.css('#landing').parent.label.click
            sleep 1
            @ui.set_input_val("#landingpage4", "https://www.landing.page.org")
        end
        it "Set the IP '3.3.3.3' in the 'Whitelist' control" do
            expect(@ui.css("#captiveportal_whitelist_switch").parent.span.text).to eq("Would you like to add a list of web sites that can bypass the captive portal process?")
            @ui.click('#captiveportal_whitelist_switch')
            sleep 1
            @ui.set_input_val("#captiveportal_new_whitelist_item", "3.3.3.3")
            sleep 1
            @ui.click('#captiveportal_add_whitelist_item')
        end
        it "Go to the designer page and insert a 'Horizontal line' element" do
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            find_mce_menu_button_and_menu_item_button("File", "New document")
            find_mce_menu_button_and_menu_item_button("Insert", "Horizontal line")
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
        end
        it "Save the profile and verify that the SSID has the value 'Splash'" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Click the 'Next' button and verify the proper values are kept" do
            @ui.click('#ssid_modal_captiveportal_btn_next')
            expect(@ui.get(:input, {id: "captiveportal_timeout"}).value).to eq("60")
             expect(@ui.css('#captiveportal_authtimeout_switch')).not_to be_visible
            expect(@ui.get(:input, {id: "landingpage4"}).value).to eq("https://www.landing.page.org")
            expect(@ui.get(:span, {css: ".whitelist_record"}).text).to eq("3.3.3.3")
            sleep 1
            @ui.click('#ssid_captiveportal_modal_closemodalbtn')
        end
    end
end

shared_examples "edit an ssid and verify setup captive portal modal splash page external" do |profile_name|
    describe "Edit and SSID and verify that the setup captive portal modal contains the proper controls" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
            @ui.css('#profile_config_tab_ssids').wait_until_present
            @ui.click('#profile_config_tab_ssids')
            sleep 3
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'Splash Page (Host Externally)'" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 1
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH .host .mac_chk_label')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
        end
        it "Set the 'Landing Page' to 'http://xirrus-external.com' and redirect secrets to '12345678'" do
            @ui.set_input_val('#landingpage1', 'http://xirrus-external.com')
            @ui.set_input_val('#externalsplash_redirect','12345678')
            @ui.set_input_val('#externalsplash_confirmredirect','12345678')
        end
        it "Verify that the 'Session Timeout' control is visible and can be set to 60 minutes" do
            expect(@ui.css('#captiveportal_authtimeout_switch')).to be_visible
            @ui.click('#captiveportal_authtimeout_switch')
            sleep 1
            @ui.set_input_val('#captiveportal_authtimeout', '60')
        end
        it "Open the 'Show Advanced' container and set the landing page to the value 'https://www.landing.page.org'" do
            expect(@ui.css("#landing").parent.parent.parent.p.text).to eq("")
            @ui.click('#captiveportal_showadvanced')
            sleep 1
            @browser.execute_script('$(\'#landing\').click()')
            @browser.execute_script('$(\'#landing\').click()')
            sleep 1
            #@ui.css('#landing').parent.label.click
            sleep 1
            @ui.set_input_val("#landingpage4", "https://www.landing.page.org")
        end
        it "Set the IP '3.3.3.3' in the 'Whitelist' control" do
            expect(@ui.css("#captiveportal_whitelist_switch").parent.span.text).to eq("Would you like to add a list of web sites that can bypass the captive portal process?")
            @ui.click('#captiveportal_whitelist_switch')
            sleep 1
            @ui.set_input_val("#captiveportal_new_whitelist_item", "3.3.3.3")
            sleep 1
            @ui.click('#captiveportal_add_whitelist_item')
        end
        it "Save the modal changes" do
            @ui.click('#ssid_modal_captiveportal_btn_save')
        end
        it "Save the profile and verify that the SSID has the value 'External Splash'" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Splash')
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Click the 'Next' button and verify the proper values are kept" do
            @ui.click('#ssid_modal_captiveportal_btn_next')
            expect(@ui.get(:input, {id: "landingpage1"}).value).to eq('http://xirrus-external.com')
            expect(@ui.get(:input, {id: "captiveportal_authtimeout"}).value).to eq("60")
            expect(@ui.get(:input, {id: "landingpage4"}).value).to eq("https://www.landing.page.org")
            expect(@ui.get(:span, {css: ".whitelist_record"}).text).to eq("3.3.3.3")
            sleep 1
            @ui.click('#ssid_captiveportal_modal_closemodalbtn')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal splash page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal splash page" do
        before :all do
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
            @browser.refresh
        end

        it "edit an ssid and change access control to captive portal splash page" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            @ui.clear_mce
            @ui.insert_proceed

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal splash page for aos light profile" do |profile_name|
    describe "Edit an ssid and change access control to captive portal splash page for a profile that has an AOS Light device assigned" do
        before :all do
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal splash page for aos light profile" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 1
            expect(@ui.css('#ssid_captiveportal_modal .CaptivePortalType_SPLASH .host .mac_chk_label')).not_to exist

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1

            @ui.set_input_val('#landingpage1', 'http://xirrus-external.com')
            @ui.set_input_val('#externalsplash_redirect','12345678')
            @ui.set_input_val('#externalsplash_confirmredirect','12345678')

            @ui.click('#captiveportal_showadvanced')
            sleep 0.5
            @ui.click('#landing + .mac_radio_label')
            sleep 0.5

            @ui.set_input_val('#landingpage4', 'http://xirrus-external.co.uk')

            @ui.click('#captiveportal_whitelist_switch .switch_label')
            sleep 1
            @ui.set_input_val('#captiveportal_new_whitelist_item', '*.xirrus.com')
            sleep 0.5
            @ui.click('#captiveportal_add_whitelist_item')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Splash')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal splash page external" do |profile_name|
    describe "Edit an ssid and change access control to captive portal splash page external" do
        before :all do
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
            @browser.refresh
        end

        it "edit an ssid and change access control to captive portal splash page external" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 1
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH .host .mac_chk_label')

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1

            @ui.set_input_val('#landingpage1', 'http://xirrus-external.com')
            @ui.set_input_val('#externalsplash_redirect','12345678')
            @ui.set_input_val('#externalsplash_confirmredirect','12345678')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Splash')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal login page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal login page" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
            @ui.css('#profile_config_tab_ssids').wait_until_present
            @ui.click('#profile_config_tab_ssids')
            sleep 3
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
               @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
               @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
               sleep 1
            end
        end
        it "Select the option 'Basic Login Page (hosted on AP)'" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the RADIUS Authentication to 'CHAP' and the IP to '1.2.3.4'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(4) #captiveportal_authtype', "CHAP")
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_ip1','1.2.3.4')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret1','')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret1','12345678')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_confirmsecret1','12345678')
        end
        it "Verify that the 'Called Station ID' controls are not visible" do
            expect(@ui.css('.captiveportal-stationformats')).not_to be_visible
        end
        it "Open the 'Show Advanced' and set the Landing Page to 'http://xirrus.com'" do
            if (@ui.css('#captiveportal_advanced_container').visible?)
                sleep 1
            else
                @ui.click('#captiveportal_showadvanced')
                sleep 1
            end
            @ui.click('#landing + .mac_radio_label')
            sleep 1
            @ui.set_input_val('#landingpage4', 'http://xirrus.com')
        end
        it "Add the entry '*.xirrus.com' in the Whitelist control and save the configurations" do
            @ui.click('#captiveportal_whitelist_switch .switch_label')
            sleep 1
            @ui.set_input_val('#captiveportal_new_whitelist_item', '*.xirrus.com')
            sleep 0.5
            @ui.click('#captiveportal_add_whitelist_item')
        end
        it "Go to the 'Page Design' step and save the captive portal" do
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            find_mce_menu_button_and_menu_item_button("File", "New document")
            sleep 0.5
            find_mce_menu_button_and_menu_item_button("Insert", "Login Form")
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
        end
        it "Save the profile and verify that the SSID shows the value 'Login' not 'External Login'" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Login')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal login page external" do |profile_name|
    describe "Edit an ssid and change access control to captive portal login page external" do
        it "Go to the profile named '#{profile_name}'" do
            @ui.goto_profile profile_name
            @ui.css('#profile_config_tab_ssids').wait_until_present
            @ui.click('#profile_config_tab_ssids')
            sleep 3
        end
        it "Open the Setup Captive Portal modal for the SSID" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
               @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
               @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
               sleep 1
            end
        end
        it "Select the option 'Basic Login Page (hosted externally)'" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            sleep 1
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN .host .mac_chk_label')

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the 'External Landing page' to 'http://xirrus-external.com' " do
            expect(@ui.css('#captiveportal-calledStaIdFormat').parent.html).to include("Called Station ID\nAttribute Format:")
            expect(@ui.css('#captiveportal-staMacFormat').parent.html).to include("Station MAC Format:")
            @ui.set_input_val('#landingpage2', 'http://xirrus-external.com')
            sleep 0.5
            @ui.set_input_val('#externallogin_redirect','')
            sleep 0.5
            @ui.set_input_val('#externallogin_redirect','12345678')
            sleep 0.5
            @ui.set_input_val('#externallogin_confirmredirect','12345678')
        end
        it "Set the RADIUS Authentication to 'CHAP' and the IP to '1.2.3.4'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal_authtype', "CHAP")
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_ip2','1.2.3.4')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret2','')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret2','12345678')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_confirmsecret2','12345678')
        end
        it "Set the secondary RADIUS Authentication to IP '2.2.3.4'" do
            @ui.click('#ssid_modal_addsecnd_cp_auth_btn2')
            sleep 1
            @ui.set_input_val('#captiveportal_secondary_radius_ip2','2.2.3.4')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','22345678')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_confirmsecret2','22345678')
        end
        it "Set the 'Caller Station ID' to 'BSSID:SSID' and 'lower-case (xxxxxxxxxxxx)'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-calledStaIdFormat','BSSID:SSID')
            sleep 0.5
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-staMacFormat', 'lower-case (xxxxxxxxxxxx)')
        end
        it "Save the profile and verify that the SSID shows the value 'External Login'" do
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
        it "Open the Setup Captive Portal modal for the SSID and press the 'Next' button" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
               @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
               @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
               sleep 1
            end
             @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the 'Caller Station ID' to 'BSSID' and 'UPPER-case (XXXXXXXXXXXX)'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-calledStaIdFormat','BSSID')
            sleep 0.5
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-staMacFormat', 'UPPER-case (XXXXXXXXXXXX)')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
        end
        it "Save the profile and verify that the SSID shows the value 'External Login'" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
        it "Open the Setup Captive Portal modal for the SSID and press the 'Next' button" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
               @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
               @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
               sleep 1
            end
             @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the 'Caller Station ID' to 'Ethernet-MAC' and 'lc-hyphenated (xx-xx-xx-xx-xx-xx)'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-calledStaIdFormat','Ethernet-MAC')
            sleep 0.5
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-staMacFormat', 'lc-hyphenated (xx-xx-xx-xx-xx-xx)')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
        end
        it "Save the profile and verify that the SSID shows the value 'External Login'" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
        it "Open the Setup Captive Portal modal for the SSID and press the 'Next' button" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present
            if dd.text.include?"Captive Portal"
               @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
               @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
               sleep 1
            end
             @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the 'Caller Station ID' to 'Ethernet-MAC' and 'UC-hyphenated (XX-XX-XX-XX-XX-XX)'" do
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-calledStaIdFormat','Ethernet-MAC')
            sleep 0.5
            @ui.set_dropdown_entry_by_path('#ssid_captiveportal_modal .config div:nth-child(5) #captiveportal-staMacFormat', 'UC-hyphenated (XX-XX-XX-XX-XX-XX)')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
        end
        it "Save the profile and verify that the SSID shows the value 'External Login'" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal login page for aos light profile" do |profile_name|
    describe "Edit an ssid and change access control to captive portal login page for aos light profile" do
        before :all do
            @ui.goto_profile profile_name
            sleep 2
            @ui.click('#profile_config_tab_ssids')
            sleep 2
        end
        it "Open the 'Setup Captive Portal' modal" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select 'Basic Login' and verify that the 'Host on AP' checkbox isn't present" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            sleep 1
            expect(@ui.css('#ssid_captiveportal_modal .CaptivePortalType_LOGIN .host .mac_chk_label')).not_to exist

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Set the 'External Landing page' to 'http://xirrus-external.com' and redirect secrets as '12345678'" do
            @ui.set_input_val('#landingpage2', 'http://xirrus-external.com')
            sleep 0.5
            @ui.set_input_val('#externallogin_redirect','')
            sleep 0.5
            @ui.set_input_val('#externallogin_redirect','12345678')
            sleep 0.5
            @ui.set_input_val('#externallogin_confirmredirect','12345678')
            sleep 0.5
        end
        it "Set the first Radius values to: '1.2.3.4', '12345678'" do
            @ui.set_input_val('#captiveportal_radius_ip2','1.2.3.4')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret2','')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_secret2','12345678')
            sleep 0.5
            @ui.set_input_val('#captiveportal_radius_confirmsecret2','12345678')
            sleep 0.5
        end
        it "Set the secod Radius values to: 'host.domain.tld', '22345678'" do
            @ui.click('#ssid_modal_addsecnd_cp_auth_btn2')
            sleep 1

            @ui.set_input_val('#captiveportal_secondary_radius_ip2','host.domain.tld')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','22345678')
            sleep 0.5
            @ui.set_input_val('#captiveportal_secondary_radius_confirmsecret2','22345678')
            sleep 0.5
        end
        it "Open the 'Show advanced' container" do
            if (@ui.css('#captiveportal_advanced_container').visible?)
                sleep 1
            else
                @ui.click('#captiveportal_showadvanced')
                sleep 1
            end
        end
        it "Choose 'Landing Page' radio button and set value as 'http://xirrus.com'" do
            @ui.click('#landing + .mac_radio_label')
            sleep 1

            @ui.set_input_val('#landingpage4', 'http://xirrus.com')
        end
        it "Enable (if needed) the 'Whitelist' and set an entry as '*.xirrus.co.uk'" do
            if (@ui.css('#captiveportal_new_whitelist_item').visible?)
                sleep 0.5
            else
                @ui.click('#captiveportal_whitelist_switch .switch_label')
            end
            sleep 1
            @ui.set_input_val('#captiveportal_new_whitelist_item', '*.xirrus.co.uk')
            sleep 0.5
            @ui.click('#captiveportal_add_whitelist_item')
            sleep 1
        end
        it "Save the modal" do
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 0.5

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the grid shows the SSID line having the Access Control as 'External Login'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
        it "Reopen the 'Setup Captive Portal' modal" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            sleep 1
            expect(@ui.css('#ssid_captiveportal_modal .CaptivePortalType_LOGIN .host .mac_chk_label')).not_to exist

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
        end
        it "Verify the previous values" do
            expect(@ui.get(:input , {id: "landingpage2"}).value).to eq('http://xirrus-external.com')
            expect(@ui.get(:input , {id: "externallogin_redirect"}).value).to eq("--------")
            expect(@ui.get(:input , {id: "captiveportal_radius_ip2"}).value).to eq('1.2.3.4')
            expect(@ui.get(:input , {id: "captiveportal_radius_secret2"}).value).to eq("--------")
            expect(@ui.get(:input , {id: "captiveportal_secondary_radius_ip2"}).value).to eq('host.domain.tld')
            expect(@ui.get(:input , {id: "captiveportal_secondary_radius_secret2"}).value).to eq("--------")
            expect(@ui.get(:input , {id: "landingpage4"}).value).to eq('http://xirrus.com')
            expect(@ui.css('#captiveportal_select_list ul li:first-child .whitelist_record').text).to eq('*.xirrus.co.uk')
        end
        it "Save the modal" do
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal landing page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal landing page" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal landing page" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LANDING')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_input_val('#landingpage3','http://langing_page.com')
            sleep 1

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Landing')
        end
    end
end

shared_examples "edit an ssid and add an external image on the splash page" do |profile_name|
    describe "Edit an ssid and add an external image on the splash page" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an ssid Access Control (set to Splash Page)" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Go to 'File' and press the 'New Document' button" do
            find_mce_menu_button_and_menu_item_button("File", "New document")
            sleep 1
        end
        it "Go to 'Insert' and press the 'Proceed button'" do
            find_mce_menu_button_and_menu_item_button("Insert", "Proceed Button")
            sleep 1
        end
         it "Insert an external image and save the profile" do
            find_mce_menu_button_and_menu_item_button("Insert", "Insert image")
            sleep 1
            @ui.click('.mce-imagebrowser .mce-external')
            sleep 1
            @ui.set_input_val('.mce-window[aria-label="Add external image"] .mce-textbox','https://i.imgur.com/4VOBizw.jpg')
            @ui.click('.mce-window[aria-label="Add external image"] .mce-primary')
            sleep 2
            if @ui.css(".dialogOverlay").exists? and @ui.css(".dialogOverlay").visible?
                @ui.click("#_jq_dlg_btn_2")
                sleep 2
            end
            @ui.click('.mce-imagebrowser .mce-imagelist .mce-listitem')
            sleep 1
            @ui.click('.mce-imagebrowser .mce-primary')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
            @ui.click("#profile_config_ssids_view .commonTitle")
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the SSID line shows the Access Control as 'Splash'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and add an internal image on the splash page" do |profile_name|
    describe "Edit an ssid and add an internal image on the splash page" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Edit an ssid Access Control (set to Splash Page)" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 0.5
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Go to 'File' and press the 'New Document' button" do
            find_mce_menu_button_and_menu_item_button("File", "New document")
            sleep 1
        end
        it "Go to 'Insert' and press the 'Proceed button'" do
            find_mce_menu_button_and_menu_item_button("Insert", "Proceed Button")
            sleep 1
        end
        it "Insert an external image and save the profile" do
            find_mce_menu_button_and_menu_item_button("Insert", "Insert image")
            sleep 1

            file = Dir.pwd + "/xirrus.png"
            @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'input[type="file"]\').click()')
            sleep 1
            @browser.file_field(:css,"input[type='file']").set(file)
            sleep 1
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 4

            if @ui.css(".dialogOverlay").exists? and @ui.css(".dialogOverlay").visible?
                @ui.click("#_jq_dlg_btn_2")
                sleep 2
            end

            @ui.click('.mce-imagebrowser .mce-imagelist .mce-listitem')
            sleep 1
            @ui.click('.mce-imagebrowser .mce-primary')
            sleep 1


            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and add a new captive portal gap" do |profile_name, portal_type|
    describe "Edit an ssid and add a new captive portal gap (type '#{portal_type}') for the profile named #{profile_name}" do
        before :all do

            @ui.goto_profile profile_name
            sleep 1
            @ui.click('#profile_config_tab_ssids')
        end
        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            sleep 1
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Add a NEW captive portal (type '#{portal_type}') as Access Control" do
            @ui.click('#captiveportal_new_gap')
            sleep 1
        end
        it "Presses the #{portal_type} tile to create the portal" do
            sleep 0.5
            expect(@ui.css('#guestportals_newportal')).to be_visible
            sleep 0.5
            #@ui.css('#guestportals_newportal .portal_type.' + portal_type).hover
            @ui.css('#guestportals_newportal .' + portal_type).wait_until_present
            sleep 1
            @ui.css('#guestportals_newportal .' + portal_type).click
            sleep 0.5
            expect(@ui.css('.portal_details.show')).to be_visible
            sleep 0.5
        end
        it "Set the the name as 'NEW_GAP #{portal_type}' and the description as 'description text for #{portal_type}'" do
            @ui.set_input_val('#guestportal_new_name_input', 'NEW_GAP ' + portal_type)
            sleep 0.5
            @ui.set_input_val('#guestportal_new_description_input', 'description text for ' + portal_type )
            sleep 0.5
            @ui.click('#newportal_next')
            sleep 0.5
            if (@ui.css('.msgbody').exists?)
                @ui.click('#_jq_dlg_btn_2')
            end
        end
        it "Ensure that the 'Setup Captive Portal' modal is displayed and the selected dropdown list item is 'NEW_GAP #{portal_type}'" do
            expect(@ui.css('#ssid_captiveportal_modal')).to be_visible
            sleep 1
            expect(@ui.css('#captiveportal_gaps_select .ko_dropdownlist_button span').text).to eq('NEW_GAP ' + portal_type)
            sleep 1
        end
        it "Press the 'Save & Finish' button" do
            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
        end
        #it "Ensure that the 'Save Changes?' modal is displayed and press the <SAVE> button" do
        #    sleep 1
        #    expect(@ui.css('.title').text).to eq("Save Changes?")
        #    sleep 0.5
        #    expect(@ui.css('#confirmButtons')).to be_visible
        #    sleep 0.5
        #    @ui.click('#_jq_dlg_btn_2')
        #end
        it "Save the profile " do
            # @ui.click('#profile_config_save_btn')
            press_profile_save_config_no_schedule
            sleep 1
        end
        it "Verify that the Access Control cell has the value 'EasyPass Portal'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            #expect(cp.title).to eq('EasyPass Portal')
            expect(cp.title).to eq('NEW_GAP ' + portal_type)
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal gap" do |profile_name, portal_name, portal_type|
    describe "Edit an ssid and change access control to captive portal gap using the portal '#{portal_name}'" do
        before :all do
            @ui.goto_profile profile_name
            sleep 3
            @ui.click('#profile_config_tab_ssids')
            sleep 2
        end

        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        if portal_type == "facebook aos"
            it "Verify that the application will show the 'There are no EasyPass Portals' screen" do
                expect(@ui.css('#captiveportal_gaps_select')).not_to be_present
                expect(@ui.css('#captiveportal_new_gap')).to be_present
            end
            it "Close the modal" do
                @ui.click("#ssid_captiveportal_modal .modal-close")
                sleep 2
                expect(@ui.css('#ssid_captiveportal_modal')).not_to be_visible
            end
        else
            it "Select the captive portal (type '#{portal_type}' and name '#{portal_name}') as Access Control" do
                @ui.set_dropdown_entry('captiveportal_gaps_select', portal_name)
                sleep 1
                portal_type_str = ""
                case portal_type
                  when "onetouch"
                     portal_type_str = "One-Click Access Portal"
                  when "self_reg"
                     portal_type_str = "Self-Registration Portal"
                  when "ambassador"
                     portal_type_str = "Guest Ambassador Portal"
                  when "onboarding"
                     portal_type_str = "EasyPass Onboarding Portal"
                  when "voucher"
                     portal_type_str = "EasyPass Voucher Portal"
                  when "personal"
                     portal_type_str = "EasyPass Personal Wi-Fi Portal"
                  when "google"
                     portal_type_str = "EasyPass Google Portal"
                   when "azure"
                     portal_type_str = "Microsoft Azure Portal"
                   when "facebook"
                     portal_type_str = "Facebook Wi-Fi Portal"
                   when "mega"
                     portal_type_str = "Two-Way Portal"
                end
                expect(@ui.css('.portal_type').text).to eq(portal_type_str)
            end
            it "Press the <SAVE & FINISH> button" do
                @ui.click('#ssid_modal_captiveportal_btn_save')
                sleep 1
                @ui.click("#profile_config_ssids_view .commonTitle")
            end
            it "Save the profile changes" do
                save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
                sleep 1
            end
            it "Verify that the cell for Access Control has the string 'EasyPass Portal name (#{portal_name})'" do
                    cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
                    cp.wait_until_present
                    #expect(cp.title).to eq('EasyPass Portal')
                    expect(cp.title).to eq(portal_name)
            end
            it "Set the Access Control type to 'NONE'" do
                tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
                tr.wait_until_present

                sleep 1
                @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

                dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
                dd.wait_until_present

                @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'None')
                sleep 1
            end
        end
        it "Save the profile changes" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the cell for Access Control has the string 'NONE'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('None')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal gap onboarding" do |profile_name, portal_name|
    describe "Edit an ssid and change access control to captive portal gap onboarding" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Select the captive portal (type 'onboarding' and name '#{portal_name}') as Access Control" do
            @ui.set_dropdown_entry('captiveportal_gaps_select', portal_name)

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 2
            @ui.confirm_dialog
        end
        it "Save the profile" do

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the cell for Access Control has the string 'EasyPass Portal'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            #expect(cp.title).to eq('EasyPass Portal')
            expect(cp.title).to eq(portal_name)
        end
        it "Verify that the cell for Encryption/Authentication has the string 'WPA2/802.1x'" do
            e = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            e.wait_until_present
            expect(e.title).to eq('WPA2/802.1x')
        end
    end
end

shared_examples "edit an ssid with onboarding and remove UPSK encryption" do |profile_name|
    describe "edit an ssid with onboarding and remove UPSK encryption" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "Open the dropdown for the Encryption/Authentication cell" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            sleep 1
        end
        it "Set the dropdown to the option 'NONE'" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .encryptionAuth span', 'None/Open')
            sleep 1

            @ui.confirm_dialog
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the cell for Access Control has the string 'None'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('None')
        end
        it "Verify that the cell for Encryption/Authentication has the string 'None'" do
            e = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            e.wait_until_present
            expect(e.title).to eq('None/Open')
        end
    end
end

shared_examples "edit an ssid with onboarding and change portal to self registration" do |profile_name, portal_name|
    describe "edit an ssid with onboarding and change portal to self registration" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')
            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Select the captive portal (type 'Self Registration' and name '#{portal_name}') as Access Control" do
            @ui.set_dropdown_entry('captiveportal_gaps_select', portal_name)

            @ui.click('#ssid_modal_captiveportal_btn_save')
            @ui.css("#_jq_dlg_btn_1").wait_until_present
            sleep 3
            @ui.click("#_jq_dlg_btn_1")
            sleep 1
        end
        it "Save the profile" do
            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the cell for Access Control has the string 'EasyPass Portal'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            #expect(cp.title).to eq('EasyPass Portal')
            expect(cp.title).to eq(portal_name)
        end
        it "Verify that the cell for 'Encryption/Authentication' has the string 'None'" do
            e = @ui.css('.nssg-table tbody tr:nth-child(1) .encryptionAuth div')
            e.wait_until_present
            expect(e.title).to eq('None/Open')
        end
        it "Verify that the cell for 'Enabled' has the string 'No'" do
            e = @ui.css('.nssg-table tbody tr:nth-child(1) .enabled div')
            e.wait_until_present
            expect(e.title).to eq('No')
        end
    end
end

shared_examples "edit an ssid and change access control to airwatch" do |profile_name|
    describe "edit an ssid and change access control to airwatch" do
        before :all do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to airwatch" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'AirWatch')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('AirWatch')
        end
    end
end

shared_examples "edit an ssid and change access control to none" do |profile_name|
    describe "edit an ssid and change access control to none" do
        before :all do
            @ui.goto_profile profile_name
            sleep 3
            @ui.click('#profile_config_tab_ssids')
            sleep 2
        end

        it "edit an ssid and change access control to none" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'None')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1

            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            expect(cp.title).to eq('None')
        end
    end
end

shared_examples "ssids grid general configurations - verify tab contents" do |profile_name|
    describe "Verify general features are present on the SSIDs tab and grid from the Profile Configuration" do
        it "Go to the profile named #{profile_name}" do
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "Verify the title, subtitle " do #and warning message" do
            sleep 0.5
            expect(@ui.css('#profile_config_ssids_view .commonTitle span').text).to eq('SSIDs')
            expect(@ui.css('#profile_config_ssids_view .commonSubtitle').text).to eq('Edit or view an existing SSID, assign SSIDs, and create new SSIDs here.')
            #expect(@ui.css('#profile_config_ssids_view .ssids-warning').text).to eq('Enabling AirWatch on an SSID will prevent this profile from having XR-320/X2-120 Access Points.')
        end
        it "Verify that the SSID grid exists and is visible" do
            sleep 0.5
            expect(@ui.css('.nssg-table')).to exist
            expect(@ui.css('.nssg-table')).to be_visible
        end
        it "Verify that the SSID grid has the following columns: 'SSID Name','Band','Encryption/Authentication','Enabled','Broadcast','Access Control'" do
            for column_name in ['SSID Name','Band','Encryption/Authentication','Enabled','Broadcast','Access Control']
                 @ui.find_grid_header_by_name(column_name)
                 expect($header_column.text).to eq(column_name)
            end
        end
        it "Verify that the 'Show Advanced' hyperlink exists and is visible" do
            sleep 0.5
            expect(@ui.css('#ssids_show_advanced')).to exist
            expect(@ui.css('#ssids_show_advanced')).to be_visible
        end
        it "Verify that the 'Enable VLANs' hyperlink exists and is visible" do
            sleep 0.5
            expect(@ui.css('#toggle_vlan')).to exist
            expect(@ui.css('#toggle_vlan')).to be_visible
        end
        it "Enable VLANs" do
            sleep 0.5
            @ui.click('#toggle_vlan')
        end
        it "Create a new SSID" do
            @ui.click('#profile_ssid_addnew_btn')
            sleep 0.5
            @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_0', "SSID no. 0")
            sleep 1
            @ui.set_input_val('#profile_ssids_grid_vlanOverrides_select_0 .spinner input', "4094")
            sleep 0.5
            @ui.css('#profile_config_ssids_view .commonTitle').click
        end
        it "Verify that the SSID grid has the following columns: 'SSID Name','Band','VLAN',Encryption/Authentication','Enabled','Broadcast','Access Control'" do
            for column_name in ['SSID Name','Band','VLAN','Encryption/Authentication','Enabled','Broadcast','Access Control']
                @ui.find_grid_header_by_name(column_name)
                expect($header_column.text).to eq(column_name)
            end
        end
        it "Save the profile" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(false)
        end
        it "Disable VLANs" do
            sleep 0.5
            @ui.click('#toggle_vlan')
            sleep 5
            expect(@ui.css(".dialogBox.confirm")).to exist
            expect(@ui.css('.msgbody')).to be_present
            sleep 0.5
            @ui.find_grid_header_by_name("VLAN")
            expect($header_column_chk_label).to exist
            sleep 1
            @browser.element(:id => '_jq_dlg_btn_1').click
        end
        it "Save the profile" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(false)
        end
    end
end

shared_examples "ssids grid general configurations - max 8 grids" do |profile_name, portal_name, delete_type|
    describe "General Configurations on the SSIDs tab and grid from the Profile Configuration - working with SSIDs (max 8)" do
        it "Go to the profile named #{profile_name}" do
            @ui.goto_profile profile_name
            sleep 3
            @ui.click('#profile_config_tab_ssids')
        end
        it "Create 8 SSIDs" do
            ssid_no = 0
            while (ssid_no < 8) do
                @ui.click('#profile_ssid_addnew_btn')
                sleep 0.5
                ssid_string = ssid_no.to_s
                @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_'+ ssid_string, "SSID no. " + ssid_string)
                sleep 0.5
                @ui.css('#profile_config_ssids_view .commonTitle').click
                ssid_no+=1
            end
        end
        it "Verify that the grid length is '8' rows" do
            @ui.get_grid_length
            expect($grid_length).to eq(8)
        end
        if delete_type != "All at once"
            it "Verify that the 'Show Advanced' hyperlink isn't visible, the '+ New SSID' button isn't visible, the 'Enable VLANs' hyperlink exists and is visible" do
                expect(@ui.css('#ssids_show_advanced')).to exist
                expect(@ui.css('#ssids_show_advanced')).not_to be_visible
                expect(@ui.css('#profile_ssid_addnew_btn')).to exist
                expect(@ui.css('#profile_ssid_addnew_btn')).not_to be_visible
                expect(@ui.css('#toggle_vlan')).to exist
                expect(@ui.css('#toggle_vlan')).to be_visible
            end
            it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
                tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
                tr.wait_until_present

                @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

                dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
                dd.wait_until_present

                @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                sleep 1
            end
            it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
                @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
                @ui.click('#ssid_modal_captiveportal_btn_next')
                sleep 1
            end
            it "Select the captive portal (type 'onboarding' and name '#{portal_name}') as Access Control and press the <SAVE> button" do
                @ui.set_dropdown_entry('captiveportal_gaps_select', portal_name)

                @ui.click('#ssid_modal_captiveportal_btn_save')
                sleep 1
            end
            it "Verify that the application shows the error message: 'You cannot use EasyPass Personal if you have 5 or more SSIDs in the Profile'" do
                expect(@ui.css('.msgbody')).to exist
                expect(@ui.css('.msgbody').text).to eq('You cannot use EasyPass Personal if you have 5 or more SSIDs in the Profile')
            end
            it "Close the 'Setup Captive Portal' wizard" do
                sleep 2
                @ui.click('#ssid_captiveportal_modal_closemodalbtn')
            end
            it "Rename all SSIDs" do
                ssid_no = 0
                row_no = 8
                while (ssid_no < 8)
                    ssid_string = ssid_no.to_s
                    row_string = row_no.to_s
                    @ui.click('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div')
                    sleep 1
                    @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_'+ ssid_string, "SSID no. " + ssid_string + " - UPDATED !!!")
                    sleep 0.5
                    @ui.css('#profile_config_ssids_view .commonTitle').click
                    ssid_no+=1
                    row_no-=1
                end
            end
          it "Save the profile" do
              save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
          end
          it "Verify that the grid length is '8' rows" do
              @ui.get_grid_length
              expect($grid_length).to eq(8)
              sleep 1
          end
          it "Verify that the SSID names are properly displayed" do
              ssid_no = 0
              row_no = 8
              while (ssid_no < 8)
                  ssid_string = ssid_no.to_s
                  row_string = row_no.to_s
                  expect(@ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').text).to include("SSID no. ")
                  expect(@ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').text).to include(" - UPDATED !!!")
                  ssid_no+=1
                  row_no-=1
              end
          end
        end
        if delete_type == "All at once"
           it "Save the profile" do
              save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
          end
          it "Verify that the grid length is '8' rows" do
              @ui.get_grid_length
              expect($grid_length).to eq(8)
              sleep 1
          end
          it "Verify that the SSID names are properly displayed" do
              ssid_no = 0
              row_no = 8
              while (ssid_no < 8)
                  ssid_string = ssid_no.to_s
                  row_string = row_no.to_s
                  expect(@ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').text).to include("SSID no.")
                  expect(@ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').text).not_to include(" - UPDATED !!!")
                  ssid_no+=1
                  row_no-=1
              end
          end
            it "Place a tick in the checkbox to select all grid entries" do
                @ui.click('.nssg-table thead tr th:nth-child(2) .mac_chk_label')
            end
            it "Press the 'Delete' button and expect the 'Remove SSIDs and Associated Policies' confirmation dialog is displayed, then confirm the deletion of the SSIDs" do
                @ui.click('#ssid_delete_btn')
                sleep 0.5
                expect(@ui.css('.msgbody')).to exist
                expect(@ui.css('.msgbody div').text).to eq('Are you sure you want to remove the selected SSIDs and every Policy and EasyPass portal connectivity associated with the selected SSIDs?')
                sleep 1
                @ui.click('#_jq_dlg_btn_1')
            end
        elsif delete_type == "One by one"
            it "Delete all SSIDs using the 'Delete' context button unlocked by hovering over a line" do
                row_no = 8
                while (row_no > 0)
                    row_string = row_no.to_s
                    @ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').hover
                    # @ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') .ssidName div').focus
                    @ui.show_needed_control('.nssg-table tbody tr:nth-child(' + row_string + ') td:first-child a')
                    sleep 1
                    @ui.css('.nssg-table tbody tr:nth-child(' + row_string + ') td:first-child a').click
                    sleep 1
                    @ui.click('#_jq_dlg_btn_1')
                    sleep 1
                    row_no-=1
                end
            end
        end
        it "Save the profile and verify that the grid length is '0' rows" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 2
            expect(@ui.css('.nssg-table tbody')).not_to be_visible
        end
    end
end

shared_examples "ssids grid general configurations - max 7 grids and honeypot" do |profile_name|
    describe "General Configurations on the SSIDs tab and grid from the Profile Configuration - working with SSIDs (max 8)" do
        it "Go to the profile named #{profile_name}" do
            @ui.goto_profile profile_name
            sleep 3
            @ui.click('#profile_config_tab_ssids')
        end
        it "Create 7 SSIDs" do
            sleep 2
            ssid_no = 0
            while (ssid_no < 7) do
                @ui.click('#profile_ssid_addnew_btn')
                sleep 0.5
                ssid_string = ssid_no.to_s
                @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_'+ ssid_string, "SSID no. " + ssid_string)
                sleep 0.5
                @ui.css('#profile_config_ssids_view .commonTitle').click
                ssid_no+=1
            end
        end
        it "Click the 'Show Advanced' hyperlink then the '+ Honeypot' button" do
            @ui.click('#ssids_show_advanced')
            sleep 0.5
            @ui.click('#ssid_honeypot_btn')
            sleep 0.5
        end
        it "Verify a new line is created and that it has the proper values, then that the XR-320/X2-120 warning message is displayed" do
            @ui.get_grid_length
            expect($grid_length).to eq(1)
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(3) div').text).to eq("honeypot")
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(4) div').text).to eq("2.4GHz & 5GHz")
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(5) div').text).to eq("None/Open")
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(6) div').text).to eq("Yes")
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(7) div').text).to eq("Yes")
            expect(@ui.css('.nssg-table tbody tr:last-child td:nth-child(8) div').text).to eq("None")
            expect(@ui.css('.profile-ssids-honeypot-xr3200-warning span').text).to eq('Honeypot SSID is not supported on XR-320/X2-120 Access Points.')
        end
        it "Save the profile" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 2
            @ui.click('#profile_config_tab_network')
            sleep 2
            @ui.click('#profile_config_tab_ssids')
            sleep 2
        end
        it "Verify that the grid length is '8' rows" do
            @ui.get_grid_length
            expect($grid_length).to eq(8)
            sleep 1
        end
        it "Verify that the 'Show Advanced' hyperlink isn't visible, the '+ New SSID' button isn't visible, the 'Enable VLANs' hyperlink exists and is visible" do
            expect(@ui.css('#ssids_show_advanced')).to exist
            expect(@ui.css('#ssids_show_advanced')).not_to be_visible
            expect(@ui.css('#profile_ssid_addnew_btn')).to exist
            expect(@ui.css('#profile_ssid_addnew_btn')).not_to be_visible
            expect(@ui.css('#toggle_vlan')).to exist
            expect(@ui.css('#toggle_vlan')).to be_visible
        end
#        it "For all columns, verify that the 'colgrip' control once activated sets the class value to 'resizing' for the table head column, refresh the browser then verify that the column width is the same as before the refresh" do
#            for column_no in 3..7
#                @ui.mouse_down_on_element(".nssg-table thead tr th:nth-child(#{column_no}) .nssg-col-grip")
#                tr_path = @ui.css('.nssg-table thead tr')
#                tr_class =  tr_path.attribute_value("class")
#                expect(tr_class).to eq("resizing")
#                column_width = @ui.css(".nssg-table thead tr th:nth-child(#{column_no})")
#                sleep 1
#                original_column_width =  column_width.attribute_value("style")
#
#                @browser.refresh
#                sleep 2
#
#                column_width = @ui.css(".nssg-table thead tr th:nth-child(#{column_no})")
#                sleep 1
#                new_column_width =  column_width.attribute_value("style")
#                expect(original_column_width).to eq(new_column_width)
#            end
#             #@ui.mouse_up_on_element(".nssg-table thead tr th:nth-child(2) .gridhead div")
#        end
    end
end

shared_examples "edit an ssid and verrify that the access control to captive portal landing page is disabled for aos light profile" do |profile_name|
    describe "Edit an ssid and verrify that the access control to captive portal landing page is disabled for aos light profile" do
        before :all do
            @ui.goto_profile profile_name
            sleep 2
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and verrify that the access control to captive portal landing page is disabled" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end

            expect(@ui.css('#ssid_captiveportal_modal .type.CaptivePortalType_LANDING.disabled')).to exist
            expect(@ui.css('#ssid_captiveportal_modal .type.CaptivePortalType_LANDING.disabled')).to be_visible
            sleep 1
            @ui.click('#ssid_captiveportal_modal_closemodalbtn')
        end
    end
end

shared_examples "delete profile from tile" do |profile_name|
  describe "Delete the Profile named '#{profile_name}' using the tile controls" do
    it "Go to the Profiles landing page" do
      @ui.click('#header_logo')
      sleep 1
      @ui.click('#header_profiles_arrow')
      sleep 0.5
      expect(@ui.css('#view_all_nav_item')).to be_visible
      sleep 0.5
      @ui.click('#view_all_nav_item .title')
      sleep 1.5
      expect(@browser.url).to include('/#profiles')
    end
    it "Hover over the '#{profile_name}' Profile's tile to reveal overlay buttons and press the 'Delete' button" do
      profile_titles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile a span:nth-child(1)"})
      profile_delete_icons = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile div:first-child div .deleteIcon"})
      profile_titles.each { |profile_title|
        if profile_title.text == profile_name
          profile_title.hover
          sleep 0.5
          break
        end
      }
      profile_delete_icons.each { |profile_delete_icon|
        if profile_delete_icon.visible?
          profile_delete_icon.click
          sleep 0.5
          break
        end
      }
    end
    it "Confirm the deletion and verify the grid does not show the Profile named '#{profile_name}'" do
      if @ui.css('.dialogOverlay').exists?
        if @ui.css('.dialogOverlay').visible?
            @ui.confirm_dialog
        end
      end
      sleep 3
      profile_titles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile a span:nth-child(1)"})
      profile_titles.each { |profile_title|
        expect(profile_title.text).not_to eq(profile_name)
      }

    end
  end
end

shared_examples "edit an ssid and change access control to captive portal personal wifi for aos light profile" do |profile_name, portal_name, portal_type|
    describe "Edit an SSID and add the Access Control as '#{portal_name}' to prepare for adding an AOS Light device to the profile" do
        it "Go to the profile named #{profile_name} on the SSIDs tab" do

            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
            else
                  @ui.set_dropdown_entry_by_path('.nssg-table tbody tr:nth-child(1) .accessControl span', 'Captive Portal')
                  sleep 1
            end
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Select the captive portal (type '#{portal_type}' and name '#{portal_name}') as Access Control" do
            @ui.set_dropdown_entry('captiveportal_gaps_select', portal_name)

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")
        end
        it "Save the profile changes" do
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
        end
        it "Verify that the cell for Access Control has the string 'EasyPass Portal'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            #expect(cp.title).to eq('EasyPass Portal')
            expect(cp.title).to eq(portal_name)
        end
    end
end

shared_examples "verify ssid on aos light profile has captive portal personal wifi" do |profile_name, portal_name, portal_description|
    describe "Verify that the SSID on an AOS Light profile has the captive portal set to Personal WiFi" do
        it "Go to the profile named #{profile_name} on the SSIDs tab" do

            @ui.goto_profile profile_name
            @ui.click('#profile_tab_config')
            @ui.click('#profile_config_tab_ssids')
        end
        it "Verify that the cell for Access Control has the string 'EasyPass Portal'" do
            cp = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl div')
            cp.wait_until_present
            #expect(cp.title).to eq('EasyPass Portal')
            expect(cp.title).to eq(portal_name)
        end
        it "Focus on the ssid line and open the 'Setup Captive Portal' wizard" do
            tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl div')

            dd = @ui.css('.nssg-table tbody tr:nth-child(1) .accessControl span .ko_dropdownlist_button .text')
            dd.wait_until_present

            @ui.click('.nssg-table tbody tr:nth-child(1) .accessControl .nssg-td-action-container')
        end
        it "Select the option 'EasyPass Portal' and press the <NEXT> button" do
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
        end
        it "Ensure that the dropdown list has the string '#{portal_name}'" do
            expect(@ui.css('#captiveportal_gaps_select .ko_dropdownlist_button span:first-child').text).to eq(portal_name)
        end
        it "Ensure that the description strings contain the proper 'portal name', 'portal description' and 'portal type'" do
            expect(@ui.css('.guest_portal_details .gap_name').text).to eq(portal_name)
            expect(@ui.css('.guest_portal_details .portal_type').text).to eq("EasyPass Personal Wi-Fi Portal")
            expect(@ui.css('.guest_portal_details .portal_description').text).to eq(portal_description)
        end
        it "Close the 'Setup Captive Portal' modal and go to the home page" do
            @ui.click('#ssid_captiveportal_modal_closemodalbtn')
            sleep 1
            @ui.click('#header_logo')
        end
    end
end

shared_examples "verify certain ssid line on certain profile" do |profile_name, ssid_name, verified_line_hash|
    describe "Verify that the SSID named '#{ssid_name}' has expected values on the profile named '#{profile_name}'" do
        it "Go to the profile named '#{profile_name}' and on the SSID tab" do
            @ui.goto_profile profile_name
            sleep 1
            @ui.click('#profile_config_tab_ssids')
            sleep 1
        end
        it "Find the SSID line named '#{ssid_name}'" do
            @ui.css('.nssg-table tbody').wait_until_present
            expect(@ui.css('.nssg-table .nssg-tbody').trs.length).to be >= 1
            trs_length = @ui.css('.nssg-table tbody').trs.length
            found_ssid_line = false
            while trs_length > 0
                if @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .nssg-td-text .nssg-td-text").text == ssid_name
                    found_ssid_line = true
                    break
                end
                trs_length-=1
            end
            expect(found_ssid_line).to eq(true)
            ["ssidName", "band", "encryptionAuth", "enabled", "broadcast", "accessControl"].each do |css_val|
                object = @ui.css(".nssg-table tbody tr:nth-child(#{trs_length}) .#{css_val} div")
                expect(object.title).to eq(verified_line_hash[css_val])
            end
        end
    end
end