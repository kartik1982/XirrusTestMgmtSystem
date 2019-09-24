def open_certain_container_if_needed(container_id)
    c = @ui.css(container_id + ' .opt_header a')
    c.wait_until_present
    if(c.attribute_value("class")=="expand_collapse")
        c.click
    end
end

shared_examples "update profile optimize settings" do |profile_name|
  describe "Update optimization settings on a certain profile" do
    it "Go to the profile named '#{profile_name}', open the Show Advanced tabs and navigate to the optimizations tab" do
        @ui.goto_profile profile_name
        sleep 1
        adv = @ui.id('profile_config_advanced')
        adv.wait_until_present
        if(adv.text == 'Show Advanced')
          @ui.click('#profile_config_advanced')
        end
        @ui.click('#profile_config_tab_optimization')
        expect(@browser.url).to include('/config/optimization')
    end
    it "Turn off fast roam and save" do
        open_certain_container_if_needed('#optimize_client')
        sleep 1
        @ui.click('#optimization_fastroam_switch .switch_label')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(false)
    end
    it "Turn on fast roam and save" do
        open_certain_container_if_needed('#optimize_client')
        sleep 1
        @ui.click('#optimization_fastroam_switch .switch_label')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(true)
    end
    it "Turn on acXpress and save" do
        open_certain_container_if_needed('#optimize_client')
        @ui.click('#optimization_loadbalancing_bond_switch .switch_label .left')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_loadbalancing_bond_switch_switch"}).set?).to eq(true)
    end
     it "Turn off acXpress and save" do
        @ui.click("#optimize_traffic")
        @ui.click("#optimize_client")
        open_certain_container_if_needed('#optimize_client')
        sleep 2
        @ui.click('#optimization_loadbalancing_bond_switch .switch_label .right')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_loadbalancing_bond_switch_switch"}).set?).to eq(false)
    end
    it "Verify that the RF advanced radio settings menu displays the proper note ('Please note that MU-MIMO and Beamforming are only applicable for 802.11ac wave2 devices')" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        expect(@ui.css('#optimize_rf .opt_header .opt_note').text).to eq('Please note that MU-MIMO and Beamforming are only applicable for 802.11ac wave2 devices')
    end
    it "Turn on MU-MIMO and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        sleep 2
        @ui.css('#optimization_mumimo_switch .switch_label').hover
        @ui.click('#optimization_mumimo_switch .switch_label')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_mumimo_switch_switch"}).set?).to eq(true)
    end
    it "Turn off MU-MIMO and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        sleep 2
        @ui.css('#optimization_mumimo_switch .switch_label').hover
        @ui.click('#optimization_mumimo_switch .switch_label')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_mumimo_switch_switch"}).set?).to eq(false)
    end
    it "Turn off Beamforming and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        @ui.click('#optimization_beamforming_switch .switch_label .right')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_beamforming_switch_switch"}).set?).to eq(false)
    end
    it "Turn on Beamforming and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        @ui.click('#optimization_beamforming_switch .switch_label .left')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_beamforming_switch_switch"}).set?).to eq(true)
    end
    it "Turn on 802.11b and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        @ui.click('#optimization_dot11B_switch .switch_label .left')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_dot11B_switch_switch"}).set?).to eq(true)
    end
    it "Turn off 802.11b and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_rf')
        @ui.click('#optimization_dot11B_switch .switch_label .right')
        sleep 2
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:checkbox, {id: "optimization_dot11B_switch_switch"}).set?).to eq(false)
    end
    it "Set multicast traffic to light and save" do
        open_certain_container_if_needed('#optimize_traffic')
        sleep 1
        @ui.click('#profile_config_optimization_multicast_light + .mac_radio_label')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_light' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end
    it "Set multicast traffic to moderate and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_traffic')
        sleep 1
        @ui.click('#profile_config_optimization_multicast_mode + .mac_radio_label')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_mode' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end
    it "Set multicast traffic to aggresive and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_traffic')
        sleep 1
        @ui.click('#profile_config_optimization_multicast_high + .mac_radio_label')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_high' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end
    it "Add multicast exclude and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_traffic')
        sleep 1
        @ui.click('#profile_config_optimization_multicast_toggle_showexclude')
        sleep 1
        @ui.set_input_val('#profile_config_optimization_multicast_exclude_id','239.2.3.44')
        @ui.set_input_val('#profile_config_optimization_multicast_exclude_desc','test')
        @ui.click('#profile_config_optimization_multicast_exclude_add')
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        item = @ui.css('.multicast_exclude_list .select_list li:nth-child(2)')
        expect(item.text).to include('239.2.3.44')
        expect(item.text).to include('(test)')
        @browser.execute_script('$("#suggestion_box").show()')
    end
    it "Remove multicast exclude and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        open_certain_container_if_needed('#optimize_traffic')
        sleep 1
        item = @ui.css('.multicast_exclude_list .select_list li:nth-child(2)')
        item.wait_until_present
        item.hover
        sleep 1
        del = item.a(:class => 'deleteIcon')
        del.wait_until_present
        del.click
        sleep 1
        @ui.confirm_dialog
        sleep 1
        save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
        sleep 1
        list = @ui.css('.multicast_exclude_list .select_list')
        list.wait_until_present
        expect(list.lis.length).to eq(1)
        @browser.execute_script('$("#suggestion_box").show()')
    end
  end
end

shared_examples "optimizations multicast isolation" do |profile_name|
    describe "Test the OPTIMIZATIONS MULTICAST ISOLATION feature on the profile named '#{profile_name}'" do
        it "Go to the profile named '#{profile_name}', open the Show Advanced tabs and navigate to the optimizations tab" do
            @ui.goto_profile profile_name
            sleep 1
            adv = @ui.id('profile_config_advanced')
            adv.wait_until_present
            if(adv.text == 'Show Advanced')
              @ui.click('#profile_config_advanced')
            end
            @ui.click('#profile_config_tab_optimization')
            expect(@browser.url).to include('/config/optimization')
        end
        it "Open the Traffic container and verify the general features of the 'Multicast Isolation' controls" do
            @browser.execute_script('$("#suggestion_box").hide()')
            open_certain_container_if_needed('#optimize_traffic')
            @ui.css('#optimize_traffic .opt_fields div:first-child').wait_until_present
            expect(@ui.css('#optimize_traffic .opt_fields div:first-child').text).to eq("Multicast Isolation")
            expect(@ui.css('#optimize_traffic .opt_fields div:nth-child(2) .opt_field_label').text).to eq("Would you like to enable multicast isolation?")
            expect(@ui.css('#optimize_traffic .opt_fields div:nth-child(2) .opt_info').text).to eq("Multicast isolation provides control over how and which multicast frames are distributed in the network. This feature allows devices which rely on multicast to be utilized in a large network environment while minimizing the airtime impact.\nNeighbors are those Access Points within range of each other, that can hear each other's beacons.")
        end
        it "Set the 'Multicast Isolation' to 'Yes'" do
            expect(@ui.css('#optimization-multicast-iso-enabled-switch')).to be_present
            @ui.click('#optimization-multicast-iso-enabled-switch_switch + .switch_label')
            sleep 1
            expect(@ui.css('#optimization-multicast-iso-neighbors-switch')).to be_present
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(true)
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-neighbors-switch_switch"}).set?).to eq(false)
        end
        it "Set the 'Include Neighbors' to 'Yes'" do
            expect(@ui.css('#optimization-multicast-iso-neighbors-switch')).to be_present
            expect(@ui.css('.multicast-iso-enable').text).to eq("Enable Isolation by Access Point")
            @ui.click('#optimization-multicast-iso-neighbors-switch_switch + .switch_label')
            sleep 1
            expect(@ui.css('.multicast-iso-neighbors').text).to eq("Include Access Point Neighbors")
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-neighbors-switch_switch"}).set?).to eq(true)
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(true)
        end
        it "Set the 'Include Neighbors' to 'No'" do
            expect(@ui.css('#optimization-multicast-iso-neighbors-switch')).to be_present
            @ui.click('#optimization-multicast-iso-neighbors-switch_switch + .switch_label')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-neighbors-switch_switch"}).set?).to eq(false)
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(true)
        end
        it "Set the 'Multicast Isolation' to 'No'" do
            expect(@ui.css('#optimization-multicast-iso-enabled-switch')).to be_present
            @ui.click('#optimization-multicast-iso-enabled-switch_switch + .switch_label')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(false)
            expect(@ui.css('#optimization-multicast-iso-neighbors-switch')).not_to be_present
        end
        it "Set the 'Multicast Isolation' to 'Yes', set the 'Include Neighbors' to 'Yes', save, refresh the browser and verify proper values are kept" do
            @ui.click('#optimization-multicast-iso-enabled-switch_switch + .switch_label')
            sleep 1
            @ui.click('#optimization-multicast-iso-neighbors-switch_switch + .switch_label')
            sleep 1
            save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
            sleep 1
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-neighbors-switch_switch"}).set?).to eq(true)
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(true)
            @browser.refresh
            sleep 1
            @ui.css('#optimize_traffic').wait_until_present
            open_certain_container_if_needed('#optimize_traffic')
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-neighbors-switch_switch"}).set?).to eq(true)
            expect(@ui.get(:checkbox, {id: "optimization-multicast-iso-enabled-switch_switch"}).set?).to eq(true)
        end
    end
end