def ensure_show_advanced_is_open
  if @ui.css('#network_show_advanced').text != "Hide Advanced"
    @ui.click('#network_show_advanced')
  end
  sleep 1
end

shared_examples "dhcp pool with single ssid" do |profile_name, ssid_name|
  describe "Verify the DHCP pool settings with a single SSID" do
     it "Go to the profile named '#{profile_name}'" do
        @ui.goto_profile profile_name
        sleep 4
        @ui.click('#profile_config_tab_network')
     end
     it "Set DHCP Pool to 'Yes' and then the following values: NAT 'No', Lease '4000', start '192.168.10.2', end '192.168.10.254', gateway '192.168.10.1', mask '255.255.255.0', domain 'test.org', dns1 '172.24.10.10', dns2 '172.25.5.1' and dns3 '213.154.124.1' then save" do
      ensure_show_advanced_is_open
      enable_dhcp_heading_text = @browser.execute_script('return $("span:contains(\'Enable DHCP Pool Settings?\')")')
      expect(enable_dhcp_heading_text[0].text).to eq('Enable DHCP Pool Settings?')
      enable_dhcp_pool_switch = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_label')
      enable_dhcp_pool_switch.click
      sleep 1
      nat_switch = enable_dhcp_heading_text[0].parent.element(css: '.togglebox_contents.active .field .switch .switch_label')
      nat_switch.click
      sleep 1
      nat_switch_switch = enable_dhcp_heading_text[0].parent.element(css: '.togglebox_contents.active .field .switch .switch_checkbox')
      nat_switch_switch_id = nat_switch_switch.id
      expect(@ui.get(:checkbox , {id: nat_switch_switch_id}).set?).to eq(false)
      sleep 1
      @ui.set_input_val('#pcn-dhcp-lease', "4000")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-ipstart', "192.168.10.2")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-ipend', "192.168.10.254")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-gateway', "192.168.10.1")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-subnet', "255.255.255.0")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-domain', "test.org")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-primary', "172.24.10.10")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-secondary', "172.25.5.1")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-tertiary', "213.154.124.1")
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.6
      expect(@ui.get(:checkbox , {id: nat_switch_switch_id}).set?).to eq(false)
      expect(@ui.get(:input  , {id: "pcn-dhcp-lease"}).value).to eq("4000")
      expect(@ui.get(:input  , {id: "pcn-dhcp-ipstart"}).value).to eq("192.168.10.2")
      expect(@ui.get(:input  , {id: "pcn-dhcp-ipend"}).value).to eq("192.168.10.254")
      expect(@ui.get(:input  , {id: "pcn-dhcp-gateway"}).value).to eq("192.168.10.1")
      expect(@ui.get(:input  , {id: "pcn-dhcp-subnet"}).value).to eq("255.255.255.0")
      expect(@ui.get(:input  , {id: "pcn-dhcp-domain"}).value).to eq("test.org")
      expect(@ui.get(:input  , {id: "pcn-dhcp-primary"}).value).to eq("172.24.10.10")
      expect(@ui.get(:input  , {id: "pcn-dhcp-secondary"}).value).to eq("172.25.5.1")
      expect(@ui.get(:input  , {id: "pcn-dhcp-tertiary"}).value).to eq("213.154.124.1")
    end
    it "Enable the limit to single SSID feature and use the SSID named '#{ssid_name}'" do
      ensure_show_advanced_is_open
      @ui.click("#profile_config_network_limitDhcpPool_switch + .switch_label")
      sleep 1
      @ui.css('#profile_config_network_limitDhcpPool_ssids').wait_until_present
      @ui.set_dropdown_entry('profile_config_network_limitDhcpPool_ssids', ssid_name)
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 2
    end
    it "Set DHCP Pool to 'No' then save" do
      ensure_show_advanced_is_open
      enable_dhcp_heading_text = @browser.execute_script('return $("span:contains(\'Enable DHCP Pool Settings?\')")')
      expect(enable_dhcp_heading_text[0].text).to eq('Enable DHCP Pool Settings?')
      enable_dhcp_pool_switch = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_label')
      enable_dhcp_pool_switch.click
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 0.8
      expect(@ui.css(".error")).not_to be_present
      sleep 1.6
      enable_dhcp_pool_switch_id = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_checkbox').id
      expect(@ui.get(:checkbox , {id: enable_dhcp_pool_switch_id}).set?).to eq(false)
    end
  end
end

shared_examples "update profile network settings" do |profile_name|
  describe "Update profile network settings" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
      sleep 4
      @ui.click('#profile_config_tab_network')
    end
    it "Update the IP address to set on AP then save" do
      @ui.click('#profile_config_network_useDhcpIP1_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(false)
      sleep 1
      expect(@ui.get(:radio, { id: 'profile_config_network_useDhcpIP1' }).set?).to eq(true)
      expect(@ui.get(:radio, { id: 'useDhcpSwitch1' }).set?).to eq(true)
    end
    it "Update the IP address to static and save" do
      @ui.click('#profile_config_network_useDhcpIP2_label')
      sleep 1
      @ui.set_input_val('#profile_config_network_domain', 'xirrus.com')
      @ui.set_input_val('#profile_config_network_dns1', '1.1.1.1')
      @ui.set_input_val('#profile_config_network_dns2', '1.1.1.2')
      @ui.set_input_val('#profile_config_network_dns3', '1.1.1.3')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:radio, {id: 'profile_config_network_useDhcpIP2' }).set?).to eq(true)
      expect(@ui.get(:radio, {id: 'useDhcpSwitch2' }).set?).to eq(true)
      expect(@ui.get(:input, {css: '#profile_config_network_domain'}).value).to eq("xirrus.com")
      expect(@ui.get(:input, {css: '#profile_config_network_dns1'}).value).to eq("1.1.1.1")
      expect(@ui.get(:input, {css: '#profile_config_network_dns2'}).value).to eq("1.1.1.2")
      expect(@ui.get(:input, {css: '#profile_config_network_dns3'}).value).to eq("1.1.1.3")
    end
    it "Update the IP address to DHCP and save" do
      @ui.click('#useDhcpSwitch0_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:radio, {id: 'useDhcpSwitch0' }).set?).to eq(true)
      expect(@ui.get(:radio, {id: 'profile_config_network_useDhcpIP0' }).set?).to eq(true)
    end
    it "Show advanced options" do
      ensure_show_advanced_is_open
    end
    it "Set CDP to 'Yes', interval to '90' and hold time to '160' and save" do
      @ui.click('#profile_config_network_enableCDP .switch_label')
      @ui.set_input_val('#profile_config_network_cdpinterval', '90')
      @ui.set_input_val('#profile_config_network_cdpholdtime', '160')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableCDP_switch"}).set?).to eq(true)
      expect(@ui.get(:input, {css: '#profile_config_network_cdpinterval'}).value).to eq("90")
      expect(@ui.get(:input, {css: '#profile_config_network_cdpholdtime'}).value).to eq("160")
    end
    it "Set CDP to 'No' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_enableCDP .switch_label')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableCDP_switch"}).set?).to eq(false)
    end
    it "Set LLDP to 'Yes', interval to '90' and hold time to '160' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_enableLLDP .switch_label')
      @ui.set_input_val('#profile_config_network_lldpinterval', '90')
      @ui.set_input_val('#profile_config_network_lldpholdtime', '160')
      @ui.click('#profile_config_network_ethernet_lldp .switch_label')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableLLDP_switch"}).set?).to eq(true)
      expect(@ui.get(:input, {css: '#profile_config_network_lldpinterval'}).value).to eq("90")
      expect(@ui.get(:input, {css: '#profile_config_network_lldpholdtime'}).value).to eq("160")
      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_lldp_switch"}).set?).to eq(true)
    end
    it "Set LLDP to 'No' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_enableLLDP .switch_label')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableLLDP_switch"}).set?).to eq(false)
    end
    it "Set DHCP Pool to 'Yes' and then the following values: NAT 'No', Lease '4000', start '192.168.10.2', end '192.168.10.254', gateway '192.168.10.1', mask '255.255.255.0', domain 'test.org', dns1 '172.24.10.10', dns2 '172.25.5.1' and dns3 '213.154.124.1' then save" do
      ensure_show_advanced_is_open
      enable_dhcp_heading_text = @browser.execute_script('return $("span:contains(\'Enable DHCP Pool Settings?\')")')
      expect(enable_dhcp_heading_text[0].text).to eq('Enable DHCP Pool Settings?')
      enable_dhcp_pool_switch = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_label')
      enable_dhcp_pool_switch.click
      sleep 1
      nat_switch = enable_dhcp_heading_text[0].parent.element(css: '.togglebox_contents.active .field .switch .switch_label')
      nat_switch.click
      sleep 1
      nat_switch_switch = enable_dhcp_heading_text[0].parent.element(css: '.togglebox_contents.active .field .switch .switch_checkbox')
      nat_switch_switch_id = nat_switch_switch.id
      expect(@ui.get(:checkbox , {id: nat_switch_switch_id}).set?).to eq(false)
      sleep 1
      @ui.set_input_val('#pcn-dhcp-lease', "4000")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-ipstart', "192.168.10.2")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-ipend', "192.168.10.254")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-gateway', "192.168.10.1")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-subnet', "255.255.255.0")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-domain', "test.org")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-primary', "172.24.10.10")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-secondary', "172.25.5.1")
      sleep 1
      @ui.set_input_val('#pcn-dhcp-tertiary', "213.154.124.1")
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.6
      expect(@ui.get(:checkbox , {id: nat_switch_switch_id}).set?).to eq(false)
      expect(@ui.get(:input  , {id: "pcn-dhcp-lease"}).value).to eq("4000")
      expect(@ui.get(:input  , {id: "pcn-dhcp-ipstart"}).value).to eq("192.168.10.2")
      expect(@ui.get(:input  , {id: "pcn-dhcp-ipend"}).value).to eq("192.168.10.254")
      expect(@ui.get(:input  , {id: "pcn-dhcp-gateway"}).value).to eq("192.168.10.1")
      expect(@ui.get(:input  , {id: "pcn-dhcp-subnet"}).value).to eq("255.255.255.0")
      expect(@ui.get(:input  , {id: "pcn-dhcp-domain"}).value).to eq("test.org")
      expect(@ui.get(:input  , {id: "pcn-dhcp-primary"}).value).to eq("172.24.10.10")
      expect(@ui.get(:input  , {id: "pcn-dhcp-secondary"}).value).to eq("172.25.5.1")
      expect(@ui.get(:input  , {id: "pcn-dhcp-tertiary"}).value).to eq("213.154.124.1")
    end
    it "Set DHCP Pool to 'No' then save" do
      ensure_show_advanced_is_open
      enable_dhcp_heading_text = @browser.execute_script('return $("span:contains(\'Enable DHCP Pool Settings?\')")')
      expect(enable_dhcp_heading_text[0].text).to eq('Enable DHCP Pool Settings?')
      enable_dhcp_pool_switch = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_label')
      enable_dhcp_pool_switch.click
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 0.8
      expect(@ui.css(".error")).not_to be_present
      sleep 1.6
      enable_dhcp_pool_switch_id = enable_dhcp_heading_text[0].parent.element(css: '.fl_right.switch .switch_checkbox').id
      expect(@ui.get(:checkbox , {id: enable_dhcp_pool_switch_id}).set?).to eq(false)
    end
    it "Set 'Auto Negotiate' to 'No', duplex to 'Half' and speed to '10 Megabit' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_ethernet_autonegotiate .switch_label')
      @ui.click('#profile_config_network_ethernet_duplex .switch_label')
      @ui.set_dropdown_entry('profile_config_networks_ethernetspeed', '100 Megabit')
      sleep 1
      @ui.set_dropdown_entry('profile_config_networks_ethernetspeed', '10 Megabit')
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_autonegotiate_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_duplex_switch"}).set?).to eq(false)
      expect(@ui.css('#profile_config_networks_ethernetspeed .ko_dropdownlist_button .text').text).to eq('10 Megabit')
    end
    it "Set ''Auto Negotiate' to 'Yes' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_ethernet_autonegotiate .switch_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
       expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_autonegotiate_switch"}).set?).to eq(true)
    end
    it "Update MTU to '1600' bytes and save" do
      ensure_show_advanced_is_open
      @ui.set_input_val('#profile_config_network_mtu', '1600')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:input, {css: '#profile_config_network_mtu'}).value).to eq("1600")
    end
    it "Set the Authentication method for XR-320 Switch Configuration to 'Radius MAC' and open the secondary server also" do
      ensure_show_advanced_is_open
      expect(@ui.css('#profile_config_network_authtype')).to be_visible
      expect(@ui.css('.togglebox.noscroll .togglebox_contents.active .togglebox_heading.full span:first-child').text).to eq("What type of authentication would you like to use?")
      expect(@ui.css('.togglebox.noscroll .togglebox_contents.active .togglebox_heading.full span:nth-child(2)').text).to eq("Enabling Radius MAC authentication will allow you to authenticate devices connected to the wire port via a radius server.")
      @ui.css('#profile_config_network_authtype .switch_label').click
      sleep 1
      @ui.click('#ssid_modal_addsecnd_sec_btn')
    end
    it "Set the RADIUS MAC Server's values" do
      @ui.set_input_val('#host', '1.2.3.4')
      @ui.set_input_val('#port', '111')
      @ui.set_input_val('#share', '12345678')
      @ui.set_input_val('#share_confirm', '12345678')
    end
    it "Set the Secondary RADIUS MAC Server's values" do
      @ui.set_input_val('#secondary_host', '2.2.3.4')
      @ui.set_input_val('#secondary_port', '211')
      @ui.set_input_val('#secondary_share', '22345678')
      @ui.set_input_val('#secondary_share_confirm', '22345678')
    end
    it "Save the profile and verify that the RADIUS MAC input fields have the proper values" do
       save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
       sleep 2
       host = @ui.css('#host')
       port = @ui.css('#port')
       share = @ui.css('#share')
       secondary_host = @ui.css('#secondary_host')
       secondary_port = @ui.css('#secondary_port')
       secondary_share = @ui.css('#secondary_share')
       expect(@ui.get(:input, {css: '#host'}).value).to eq('1.2.3.4')
       expect(@ui.get(:input, {css: '#port'}).value).to eq('111')
       expect(@ui.get(:input, {css: '#share'}).value).to eq('--------')
       expect(@ui.get(:input, {css: '#secondary_host'}).value).to eq('2.2.3.4')
       expect(@ui.get(:input, {css: '#secondary_port'}).value).to eq('211')
       expect(@ui.get(:input, {css: '#secondary_share'}).value).to eq('--------')
    end
    it "Set the Authentication method for XR-320 Switch Configuration to 'Open' and verify the controls are properly hidden" do
      @ui.css('#profile_config_network_authtype .switch_label').click
      sleep 1
      expect(@ui.css('#profile_config_network_authtype')).to be_visible
    end
    it "Set the 'Uplink Port Config -> Native VLAN' to 'Yes', then change VLAD ID to '2' and add VLAN Override 'Test <-> 22' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_xr320uplink .switch_label')
      sleep 1
      @ui.set_input_val('#profile_config_xr320vlanid', "2")
      sleep 0.5
      @ui.get(:text_field , {css: '#profile_config_network_xr320_override_tag_input .ko_dropdownlist_combo_input'}).set "Test"
      #@ui.set_input_val('#profile_config_network_xr320_override_tag_input .ko_dropdownlist_combo_input', "Test")
      @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
      sleep 2
      @ui.set_input_val('#profile_config_network_xr320_override_vlan_input', "22")
      sleep 1
      @ui.click('#profile_config_network_xr320_override_add')
      sleep 1
      @ui.click('.commonTitle span')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      expect(@ui.get(:checkbox, {id: "profile_config_network_xr320uplink_switch"}).set?).to eq(true)
      expect(@ui.get(:input , {id: 'profile_config_xr320vlanid'}).value).to eq("2")
      expect(@ui.css('#profile_config_network_xr320_overrides_list .override_list .tag .text')).to be_present
      expect(@ui.css('#profile_config_network_xr320_overrides_list .override_list .tag .text').text).to eq("Test (VLAN 22)")
    end
    it "Set the 'Uplink Port Config -> Native VLAN' to 'No' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_xr320uplink .switch_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      expect(@ui.get(:checkbox, {id: "profile_config_network_xr320uplink_switch"}).set?).to eq(false)
      expect(@ui.css('#profile_config_network_xr320_overrides_list .override_list .tag .text')).not_to be_present
    end
    it "Set the 'XR-320 Switch Config' to 'Yes' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_xr320vlan .switch_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      for i in 1..4
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320enablelan#{i}_switch"}).set?).to eq(true)
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320portmode#{i}_switch"}).set?).to eq(true)
        expect(@ui.get(:input, {id: "profile_config_xr320pvid#{i}"}).value).to eq("1")
      end
    end
    it "Set the first and third LAN ports to enabled 'No'" do
      for i in [1, 3]
        @ui.click("#profile_config_network_xr320enablelan#{i} .switch_label")
      end
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      for i in [1, 3]
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320portmode#{i}_switch"})).not_to be_present
      end
    end
    it "Set the LAN port 2 to PVID '2', tag name 'Test2' and value '222' and save" do
      @ui.set_input_val('#profile_config_xr320pvid2', "2")
      sleep 0.5
      @ui.get(:text_field , {css: '#profile_config_network_xr320_override_tag_input2 .ko_dropdownlist_combo_input'}).set "Test2"
      @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
      sleep 2
      @ui.set_input_val('#profile_config_network_xr320_override_pvid_input2', "222")
      sleep 1
      @ui.click('#profile_config_network_xr320_override_tag_add2')
      sleep 1
      @ui.click('.commonTitle span')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      expect(@ui.get(:input , {id: 'profile_config_xr320pvid2'}).value).to eq("2")
      expect(@ui.css('#profile_config_network_xr320_pvidoverrides_list2 .override_list .tag .text')).to be_present
      expect(@ui.css('#profile_config_network_xr320_pvidoverrides_list2 .override_list .tag .text').text).to eq("Test2 (VLAN 222)")
    end
    it "Set the LAN port 4 to TRUNK then PVID '4', tag name 'Test4' and value '44', VID '444', Allowed VLAN Overrides tag name 'Test4_2' and '4049' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_xr320portmode4')
      sleep 1
      @ui.set_input_val('#profile_config_xr320pvid4', "4")
      sleep 0.5
      @ui.get(:text_field , {css: '#profile_config_network_xr320_override_tag_input4 .ko_dropdownlist_combo_input'}).set "Test4"
      @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
      sleep 2
      @ui.set_input_val('#profile_config_network_xr320_override_pvid_input4', "44")
      sleep 1
      @ui.click('#profile_config_network_xr320_override_tag_add4')
      sleep 1
      @ui.set_input_val('#profile_config_xr320vid4', "444")
      sleep 0.5
      @ui.click('#profile_config_xr320vid_add4')
      sleep 0.5
      @ui.get(:text_field , {css: '#profile_config_network_xr320_override_tag_allowed_input4 .ko_dropdownlist_combo_input'}).set "Test44"
      @browser.execute_script('$("#ko_dropdownlist_overlay").hide()')
      sleep 2
      @ui.set_input_val('#profile_config_network_xr320_override_tag_allowed_input_val4', "4049")
      sleep 1
      @ui.click('#profile_config_network_xr320_override_allowed_add4')
      sleep 1
      @ui.click('.commonTitle span')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      expect(@ui.get(:input , {id: 'profile_config_xr320pvid4'}).value).to eq("4")
      expect(@ui.css('#profile_config_network_xr320_pvidoverrides_list4 .override_list .tag .text')).to be_present
      expect(@ui.css('#profile_config_network_xr320_pvidoverrides_list4 .override_list .tag .text').text).to eq("Test4 (VLAN 44)")
      expect(@ui.css('#profile_config_xr320vid_tags4 .tag .text')).to be_present
      expect(@ui.css('#profile_config_xr320vid_tags4 .tag .text').text).to eq("444")
      expect(@ui.css('#profile_config_network_xr320_allowedoverrides_list4 .override_list .tag .text')).to be_present
      expect(@ui.css('#profile_config_network_xr320_allowedoverrides_list4 .override_list .tag .text').text).to eq("Test44 (VLAN 4049)")
    end
    it "Set the 'XR-320 Switch Config' to 'No' and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_xr320vlan .switch_label')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1.5
      ensure_show_advanced_is_open
      expect(@ui.get(:checkbox, {id: "profile_config_network_xr320vlan_switch"}).set?).to eq(false)
    end
    it "Enable VLAN support, add a vlan and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      @ui.set_input_val('#profile-config-network-vlans-input', '222')
      @ui.click('#profile-config-network-vlans-btn')
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(true)
      expect(@ui.css('.profile-config-network-vlans .tagControlContainer').spans(:class => 'tag').length).to eq(1)
    end
    it "Disable VLAN support and save" do
      ensure_show_advanced_is_open
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      @ui.confirm_dialog
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      sleep 1
      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
    end
  end
end

shared_examples "update profile LACP Support network settings" do |profile_name|
  describe "update profile LACP Support network settings" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
      sleep 4
      @ui.click('#profile_config_tab_network')
    end
    it "verify LACP Support GUI components" do
      ensure_show_advanced_is_open
      # expect(@ui.css('.profile-config-network-lacp span').text).to eq("Would you like to enable LACP on connected devices?")
      expect(@ui.get(:checkbox, {id: 'profile-config-network-lacp-switch_switch'}).set?).to eq(false)       
      expect(@ui.css('#profile-config-network-lacp-switch .switch_label .left').text).to eq("Yes")
      expect(@ui.css('#profile-config-network-lacp-switch .switch_label .right').text).to eq("No")
    end
    it "Verify LACP Support Enable" do
      @ui.css('#profile-config-network-lacp-switch').click
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      expect(@ui.get(:checkbox, {id: 'profile-config-network-lacp-switch_switch'}).set?).to eq(true)   
    end
    it "Verify LACP Support Disable" do
      @ui.css('#profile-config-network-lacp-switch').click
      sleep 1
      save_the_profile_verify_success_message_verify_no_dirty_icons_are_visible(true)
      expect(@ui.get(:checkbox, {id: 'profile-config-network-lacp-switch_switch'}).set?).to eq(false)   
    end
  end
end