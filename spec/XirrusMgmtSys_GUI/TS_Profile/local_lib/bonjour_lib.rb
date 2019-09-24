shared_examples "update profile bonjour settings" do |profile_name|
  describe "Update profile bonjour settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_config_tab_bonjour')
    end

    it "Enable vlan" do
      box = @ui.css('.forwarding_options .togglebox')
      box.wait_until_present
      expect(box.attribute_value('class')).to eq("togglebox disabled")

      @ui.click('#profile_config_bonjour_enablevlan')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      box.wait_until_present
      expect(box.attribute_value('class')).to_not eq("togglebox disabled")
    end

    it "Enable forwarding" do
      @ui.click('#profile_config_bonjour_enableForwarding .switch_label')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      box = @ui.id('profile_config_bonjour_content_container')
      expect(box.attribute_value('class')).to eq("togglebox_contents active")
    end

    it "Add a service" do
      @ui.click('.services_list .service_item label')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      expect(@ui.get(:checkbox, {css: ".services_list .service_item .mac_chk"}).set?).to eq(true)
    end

    it "Remove a service" do
      @ui.click('.services_list .service_item label')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      expect(@ui.get(:checkbox, {css: ".services_list .service_item .mac_chk"}).set?).to eq(false)
    end

    it "Select all services" do
      @ui.click('#profile_config_bonjour_service_select_all')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      p = @ui.css('.services_list')
      lis = p.lis(:css => '.service_item')
      checked = 0

      lis.each { |li|
        if(li.checkbox.set?)
              checked = checked + 1
        end
      }

      expect(lis.length).to eq(checked)
    end

    it "Deselect all services" do
      @ui.click('#profile_config_bonjour_service_deselect_all')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      p = @ui.css('.services_list')
      lis = p.lis(:css => '.service_item')
      checked = 0

      lis.each { |li|
        if(li.checkbox.set?)
              checked = checked + 1
        end
      }

      expect(checked).to eq(0)
    end

    it "Add a vlan" do
      @ui.set_input_val('#profile_config_bonjour_add_default_vlan_input','111')
      @ui.click('#profile_config_bonjour_add_default_vlan_btn')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      list = @ui.id('profile_config_bonjour_vlan_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      expect(tag.span(:css => '.text').text).to eq('(VLAN 111)')
    end

    it "Remove a vlan" do
      list = @ui.id('profile_config_bonjour_vlan_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      tag.span(:css => '.delete').click
      sleep 1
      @ui.confirm_dialog
      sleep 1

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      expect(list.spans(:css => '.tag').length).to eq(0)
    end

    it "Add a vlan override" do
      @ui.set_input_val('#profile_config_bonjour_override_tag_input input', 'TAG')
      @ui.click('#ko_dropdownlist_overlay')
      @ui.set_input_val('#profile_config_bonjour_override_vlan_input','111,222')
      @ui.click('#profile_config_bonjour_override_add')

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      list = @ui.id('profile_config_bonjour_overrides_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      expect(tag.span(:css => '.text').text).to include('TAG (VLAN')
      expect(tag.span(:css => '.text').text).to include('111')
      expect(tag.span(:css => '.text').text).to include('222')
    end

    it "Remove a vlan override" do
      list = @ui.id('profile_config_bonjour_overrides_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      tag.span(:css => '.delete').click
      sleep 1
      @ui.confirm_dialog
      sleep 1

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1

      expect(list.spans(:css => '.tag').length).to eq(0)
    end

    it "Disable VLAN" do
      @ui.click('#profile_config_tab_network')
      sleep 2
      expect(@browser.url).to include("/config/network")
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      sleep 3
      if @ui.css(".dialogBox.confirm").exists?
        @ui.confirm_dialog
      end
      sleep 1

      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 2

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
      sleep 2

      @ui.click('#profile_config_tab_bonjour')

      box = @ui.css('.forwarding_options .togglebox')
      box.wait_until_present
      expect(box.attribute_value('class')).to eq("togglebox disabled")
    end
  end
end