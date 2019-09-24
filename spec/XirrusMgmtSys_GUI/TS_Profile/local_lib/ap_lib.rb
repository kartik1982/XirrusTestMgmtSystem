require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"
require_relative "profile_lib.rb"

def open_slideout_container_and_go_to_radios_tab(line_number,a_or_div,name,action)
  @ui.grid_action_on_specific_line(line_number,a_or_div,name,action)
  sleep 1
  @ui.click('#arraydetails_tab_radios')
  sleep 2
end

shared_examples "add access point to profile" do |profile_name, ap_name, fake_ap|
  describe "add access point to profile" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      sleep 4
      @ui.click('#profile_tab_arrays')
    end

    it "add access point to profile" do
      @ui.css('#profile_array_add_btn').wait_until_present
      sleep 0.5
      @ui.click('#profile_array_add_btn')
      sleep 1
      list = @ui.css('#add_arrays ul')
      list.wait_until_present

      xr520 = list.li(:title => ap_name)
      xr520.wait_until_present
      xr520.click

      @ui.click('#arrays_add_modal_move_btn')
      sleep 1
      @ui.click('#arrays_add_modal_addarrays_btn')
      sleep 1

      @ui.set_input_val('#arrays_grid .push-down div:nth-child(2) .xc-search input', ap_name)
      sleep 3

      grid = @ui.css('.nssg-table')
      grid.wait_until_present
      expect(grid.trs.length).to eq(2)

       cell = @ui.css('.nssg-table tbody tr td:nth-child(3) a')
      cell.wait_until_present
      expect(cell.title).to eq(ap_name)
      @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated", fake_ap)

      sleep 2
      @ui.click('#arrays_grid .push-down div:nth-child(2) .xc-search .btn-clear')
      sleep 2
    end
  end
end

shared_examples "add access point to profile certain model" do |profile_name, ap_model1, ap_model2, fake_ap|
  describe "Add an Access Point of a certain model to the profile" do
    it "Go to the profile and then to the Access Points tab" do
      @ui.goto_profile profile_name
      sleep 4
      @ui.click('#profile_tab_arrays')
    end
    it "Open the 'Add access point to profile' modal" do
      @ui.css('#profile_array_add_btn').wait_until_present
      sleep 0.5
      @ui.click('#profile_array_add_btn')
      sleep 1
      expect(@ui.css('#array_add_modal')).to be_present
    end
    it "Find in the list an array that contains the model number '#{ap_model1}' or '#{ap_model2}' and add it to the profile" do
      list = @ui.css('#add_arrays ul').lis
      list.each do |element|
        if element.attribute_value("title").include? ap_model1 or element.attribute_value("title").include? ap_model2
          element.click
          break
        end
      end
      sleep 1
      @ui.click('#arrays_add_modal_move_btn')
      sleep 1
      @ui.click('#arrays_add_modal_addarrays_btn')
      sleep 1
    end
    it "Verify that the AP is properly added in the list" do
       cell = @ui.css('.nssg-table tbody tr td:nth-child(3) a')
      cell.wait_until_present
      if cell.title.include? ap_model1
        expect(cell.title).to include(ap_model1)
      elsif cell.title.include? ap_model2
        expect(cell.title).to include(ap_model2)
      else
        expect(not_found).to be_truty
      end
    end
  end
end

shared_examples "add access point to profile and verify name and sn" do |profile_name, ap_name, ap_sn, fake_ap|
  describe "add access point to profile" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end

    it "add access point to profile" do
      @ui.click('#profile_array_add_btn')
      sleep 1
      list = @ui.css('#add_arrays ul')
      list.wait_until_present

      xr520 = list.li(:title => ap_name)
      xr520.wait_until_present
      xr520.click

      @ui.click('#arrays_add_modal_move_btn')
      sleep 1
      @ui.click('#arrays_add_modal_addarrays_btn')
      sleep 1

       cell = @ui.css('.nssg-table tbody tr td:nth-child(3) a')
      cell.wait_until_present
      expect(cell.title).to eq(ap_name)
      cell = @ui.css('.nssg-table tbody tr td:nth-child(4) a')
      cell.wait_until_present
      expect(cell.title).to eq(ap_sn)
      @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated", fake_ap)
    end
  end
end

shared_examples "add all access points to profile" do |profile_name|
  describe "add all access points to profile" do
    it "Go to the Home page and route back to the profile" do
      @ui.click('#header_logo')
      sleep 1
      @ui.goto_profile profile_name
      sleep 2
      @ui.click('#profile_tab_arrays')
      sleep 1
      expect(@browser.url).to include('/aps')
    end
    it "Add all the available Access Points to the profile" do
      @ui.click('#profile_array_add_btn')
      sleep 1
      @ui.click('#arrays_add_modal_moveall_btn')
      sleep 1
      @ui.click('#arrays_add_modal_addarrays_btn')
      sleep 2
      grid = @ui.css('.nssg-table')
      grid.wait_until_present
      expect(grid.trs.length).to be > 1
      for i in 0..2
        sleep 5
        @browser.refresh
      end
    end
  end
end

shared_examples "unasign access points from profile" do |profile_name|
  describe "unasign access points from profile" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
    end
    it "Unasign all the Access Point(s) from the profile" do
      set_paging_view_per_grid("1000")
      sleep 1
     @ui.click('.nssg-th-select .mac_chk_label')
      sleep 1
      @ui.click('.moveto_button')
      sleep 1
      @ui.click('#arrays_moveto_00000000-0000-0000-0000-000000000000')
      sleep 1
      @ui.confirm_dialog
      sleep 4

      grid = @ui.css('.nssg-table')
      grid.wait_until_present
      expect(grid.trs.length).to eq(1)
      sleep 1
    end
  end
end

shared_examples "verify xr320 warnings" do |profile_name, ap_name|
  describe "Verify XR320 Warnings are displayed all over the profiles section" do
    it "Go to the profile named '#{profile_name}'" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Verify XR320 Warnings on the area: 'Access Points area - Slideout - General tab'" do
      @ui.click('#profile_tab_arrays')

       cell = @ui.css('.nssg-table tbody tr td:nth-child(3) a')
      cell.wait_until_present
      cell.hover
      sleep 1
      @ui.click('.nssg-table tbody tr:nth-child(1) .nssg-action-invoke')
      sleep 1

      expect(@ui.css('.arraydetails-xr320')).to be_visible
    end

    it "Verify XR320 Warnings on the area: 'Access Points area - Slideout - Radios tab'" do

      @ui.click('#arraydetails_tab_radios')
      sleep 1

      $status_up = @ui.css('.slideout_title .online_status.UP')
      if !@ui.css('.slideout_title .online_status.DOWN').exists?
        $status_up.wait_until_present
      end

      if $status_up.exists?
        @ui.click('.radios_list .radio_item_container')
        sleep 1

        @ui.click('.arraydetails_radios .commonAdvanced')
        sleep 1

        expect(@ui.css('.arraydetails_radios .radios_list .radio_item_container .band_50ghz').attribute_value("class")).to include("disabled")
        expect(@ui.css('.arraydetails_radios .radios_list .radio_item_container .lockDdl').attribute_value("class")).to include("disabled")
        expect(@ui.css('.arraydetails_radios .radios_list .radio_item_container .monitorDdl').attribute_value("class")).to include("disabled")
      end

      @ui.click('#arraydetails_close_btn')
    end

    it "Verify XR320 Warnings on the area: 'Configurations area'" do
      @ui.click('#profile_tab_config')
      sleep 1

      expect(@ui.css('#profile_config_tab_bonjour').attribute_value("class")).to include("disabled")

      @ui.click('#profile_config_advanced')
      sleep 1

      expect(@ui.css('#profile_config_tab_services').attribute_value("class")).not_to include("disabled")
    end

    it "Verify XR320 Warnings on the area: 'Configurations area - SSIDs tab'" do
      @ui.click('#profile_config_tab_ssids')
      sleep 1

      tr = @ui.css('.nssg-table tbody tr:nth-child(1)')
      tr.wait_until_present

      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(8) div')

      dd = @ui.css('.nssg-table tbody tr:first-child td:nth-child(8) .ko_dropdownlist .ko_dropdownlist_button .text')
      dd.wait_until_present
      dd.click

      if dd.text.include?"Captive Portal"
            @ui.css('.nssg-table tbody tr:first-child td:nth-child(8) .nssg-td-action-container .button').click
      else
            #@ui.css('.nssg-table tbody tr:first-child td:nth-child(8) .ko_dropdownlist .ko_dropdownlist_button').click
            @ui.ul_list_select_by_string('.ko_dropdownlist_list.active ul',"Captive Portal")
      end
      sleep 1

      # expect(@ui.css('.profile-ssids-captive_portal-xr320-unsupported')).to be_visible
      expect(@ui.css('.CaptivePortalType_LANDING .description').text).to eq("Landing page is disabled for profiles containing XR-320/X2-120 devices.")
    end
    it "Close the Captive Portal modal" do
      @ui.click('#ssid_captiveportal_modal_closemodalbtn')
      @ui.click("#profile_config_ssids_view .commonTitle")
    end

    it "Verify XR320 Warnings on the area: 'Configurations area - Policies tab'" do

      @ui.click('#profile_config_tab_policies')
      sleep 1
      expect(@ui.css('.profile-policies-xr320limited')).to be_visible

      #@ui.click('#header_nav_mynetwork')
      #sleep 1
      #expect(@ui.css('.dashboard-xr320_limitation-overlay')).to be_visible
      #sleep 4
    end
  end
end

shared_examples "configure xr320 profile config" do |profile_name, ap_name|
  describe "configure xr320 profile config" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_config')

      @ui.click('#profile_config_tab_network')
      sleep 1
    end

    it "configure xr320 profile config tagged vlans" do
        @ui.click('#network_show_advanced')
        sleep 1
        @ui.click('#profile_config_network_xr320uplink .switch_label')
        sleep 1
        @ui.set_input_val('#profile_config_xr320vlanid','222')
        sleep 1
        @ui.set_input_val('#profile_config_network_xr320_override_tag_input input', 'TAG')
        # @ui.click('#ko_dropdownlist_overlay')
        @ui.set_input_val('#profile_config_network_xr320_override_vlan_input','111')
        @ui.click('#profile_config_network_xr320_override_add')
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 1

        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320uplink_switch"}).set?).to eq(true)
        expect(@ui.css('#profile_config_network_xr320_overrides_list .tagControlContainer .tag .text').text).to eq('TAG (VLAN 111)')

        @ui.click('#profile_config_network_xr320uplink .switch_label')
        sleep 1
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 2
        expect(@ui.css('#network_show_advanced').text).to eq('Show Advanced')
    end

    it "disable xr320 profile config lans" do
        @ui.click('#network_show_advanced')
        sleep 1

        @ui.click('#profile_config_network_xr320enablelan1 .switch_label')
        @ui.click('#profile_config_network_xr320enablelan2 .switch_label')
        @ui.click('#profile_config_network_xr320enablelan3 .switch_label')
        @ui.click('#profile_config_network_xr320enablelan4 .switch_label')
        sleep 1
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 2

        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320enablelan1_switch"}).set?).to eq(false)
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320enablelan2_switch"}).set?).to eq(false)
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320enablelan3_switch"}).set?).to eq(false)
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320enablelan4_switch"}).set?).to eq(false)
    end

    it "enable xr320 profile config vlans" do
        @ui.click('#profile_config_network_xr320vlan .switch_label')
        sleep 1
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 1
        expect(@ui.get(:checkbox, {id: "profile_config_network_xr320vlan_switch"}).set?).to eq(true)
    end

    it "configure xr320 profile config lans" do
        for i in [1,2,3,4]
            id = i.to_s
            tag = 'TAG'

            puts "Testing LAN " + id
            @ui.click('#profile_config_network_xr320enablelan'+id+' .switch_label')
            sleep 1
            @ui.click('#profile_config_network_xr320portmode'+id+' .switch_label')
            sleep 1
            @ui.set_input_val('#profile_config_xr320pvid'+id,id)

            @ui.set_input_val('#profile_config_network_xr320_override_tag_input'+id+' input', tag)
            # @ui.click('#ko_dropdownlist_overlay')
            @ui.set_input_val('#profile_config_network_xr320_override_pvid_input'+id, id)
            @ui.click('#profile_config_network_xr320_override_tag_add'+id)

            @ui.set_input_val('#profile_config_xr320vid'+id, id)
            @ui.click('#profile_config_xr320vid_add'+id)

            @ui.set_input_val('#profile_config_network_xr320_override_tag_allowed_input'+id+' input', tag)
            # @ui.click('#ko_dropdownlist_overlay')
            @ui.set_input_val('#profile_config_network_xr320_override_tag_allowed_input_val'+id, id)
            @ui.click('#profile_config_network_xr320_override_allowed_add'+id)

            # @ui.click('#profile_config_save_btn')
            press_profile_save_config_no_schedule
            sleep 2

            expect(@ui.get(:checkbox, {id: 'profile_config_network_xr320enablelan'+id+'_switch'}).set?).to eq(true)
            expect(@ui.get(:checkbox, {id: 'profile_config_network_xr320portmode'+id+'_switch'}).set?).to eq(false)
            expect(@ui.get(:text_field, { id: 'profile_config_xr320pvid'+id }).value).to eq(id)

            tag_obj = @ui.css('#profile_config_network_xr320_pvidoverrides_list'+id+' .tag .text')
            tag_obj.wait_until_present
            expect(tag_obj.text).to eq(tag + ' (VLAN ' + id + ')')

            tag_obj = @ui.css('#profile_config_xr320vid_tags' + id +' .tag .text')
            tag_obj.wait_until_present
            expect(tag_obj.text).to eq(id)

            tag_obj = @ui.css('#profile_config_network_xr320_allowedoverrides_list'+id+' .tag .text')
            tag_obj.wait_until_present
            expect(tag_obj.text).to eq(tag + ' (VLAN ' + id + ')')
        end
    end

    it "disable xr320 profile config vlans" do
        @ui.click('#profile_config_network_xr320vlan .switch_label')
        sleep 1
        # @ui.click('#profile_config_save_btn')
        press_profile_save_config_no_schedule
        sleep 2
        expect(@ui.css('#network_show_advanced').text).to eq('Show Advanced')
    end
  end
end

shared_examples "profile access point general tab perform changes" do |profile_name, access_point_sn, hostname, location, tag|
  describe "On the profile '#{profile_name}' perform changes on the AP general tab" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end
    it "Open the slideout general tab for the AP" do
      @ui.grid_action_on_specific_line("4", ".nssg-td-text", access_point_sn, "click")
      sleep 1
      @ui.click('#arraydetails_tab_general')
      sleep 1
    end
    if hostname != nil
      # TO ADD snippet for changing hostname
    end
    if location != nil
      it "Change the location to '#{location}'" do
        @ui.set_input_val('#edit_location',location)
        sleep 1
        @browser.execute_script('$("#suggestion_box").hide()')
        @ui.click('#arraydetails_save')
        sleep 1
        loc = @ui.get(:text_field, { id: 'edit_location' })
        loc.wait_until_present
        expect(loc.value).to eq(location)
      end
    end
    if tag != nil
      it "Add tags '#{tag}'" do
        @ui.click('#profile_arrays_tags .tag_button.orange')
        sleep 0.5
        @ui.set_input_val('#arrays_clients_add_tag_input', tag)
        sleep 0.5
        @ui.click('#general_add_tag_btn')
        sleep 0.5
        @ui.click('.slideout_icon')
        sleep 0.5
        @ui.click('#arraydetails_save')
        tag_name = @ui.css('#profile_arrays_tags .tagControlContainer span .text')
        tag_name.wait_until_present
        expect(tag_name.text).to eq(tag)
      end
    end
    it "Close the Slideout window" do
      if @ui.css('.confirm').exists?
        if @ui.css('.confirm').visible?
          @ui.click('#_jq_dlg_btn_0')
          sleep 2
        end
      end
      if @ui.css('#arraydetails_close_btn').exists?
        if @ui.css('#arraydetails_close_btn').visible?
          @ui.click('#arraydetails_close_btn')
          sleep 2
        end
      end
      expect(@ui.css('#arraydetails_close_btn')).not_to be_visible
    end
  end
end

shared_examples "test profile access point general tab" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - general tab settings" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end
    it "Test AP config general tab: Change location to the string 'Cluj-Napoca', save and verify the proper string is displayed" do
      @ui.grid_action_on_specific_line("3", ".nssg-td-text", ap_name, "click")
      sleep 1
      @ui.click('#arraydetails_tab_general')
      sleep 1
      @ui.set_input_val('#edit_location','Cluj-Napoca')
      sleep 1
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.click('#arraydetails_save')
      sleep 1
      loc = @ui.get(:text_field, { id: 'edit_location' })
      loc.wait_until_present
      expect(loc.value).to eq('Cluj-Napoca')
      loc.clear
      sleep 1
      @ui.click('#arraydetails_save')
      @browser.execute_script('$("#suggestion_box").show()')
      sleep 1
      @ui.click('#arraydetails_close_btn')
      sleep 1
      @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
    end
    it "Test AP config general tab: Add a tag , save and verify the a tag is displayed" do
      # @ui.grid_action_on_specific_line(3, "div", ap_name, "invoke")
      @ui.grid_action_on_specific_line("3", ".nssg-td-text", ap_name, "click")
      sleep 2
      @ui.click('#profile_arrays_tags .tag_button.orange')
      sleep 0.5
      @ui.css('#profile_arrays_tags .tag_button .tag_nav .items div:first-child .mac_chk_label').click
      sleep 0.5
      @ui.click('#general_add_tag_btn')
      sleep 0.5
      @ui.click('#arraydetails_save')
      tag_name = @ui.css('#profile_arrays_tags .tagControlContainer span .text')
      tag_name.wait_until_present
      #expect(tag_name.text).not_to eq("")
      sleep 1
      @ui.css('#profile_arrays_tags .tagControlContainer span .delete').click
      sleep 0.5
      @ui.click('#arraydetails_save')
      sleep 2
      if @ui.css('.dialogOverlay').exists? and @ui.css('#_jq_dlg_btn_1').exists?
        @ui.click('#_jq_dlg_btn_1')
      end
    end
    it "Close the Slideout window" do
      @ui.click('#arraydetails_close_btn')
      sleep 2
      expect(@ui.css('#arraydetails_close_btn')).not_to be_visible
    end
  end
end

shared_examples "test profile access point system tab" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - system tab settings" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end

    it "test ap config system" do
      if @ui.id('arraydetails_tab_system').exists?
          @ui.grid_action_on_specific_line(3, "a", ap_name, "invoke")

          sleep 1

          @ui.click('#arraydetails_tab_system')
          sleep 1

          $status_up = @ui.css('.slideout_title .online_status.UP')
          $status_up.wait_until_present

          if $status_up.exists?
            ad = @ui.css('.arraydetails_system')
            ad.wait_until_present

            block = ad.div(:css => '.info_block', :index => 1)
            block.wait_until_present

            serial = block.div(:css => '.field_wrap').span(:css => '.field_cell', :index => 2)
            serial.wait_until_present

            expect(serial.text).to eq(ap_sn)
          end
          @ui.click('#arraydetails_close_btn')

          @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      end
    end
  end
end

shared_examples "test profile access point radios tab general" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - radios tab settings (general)" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end

    it "Go to the 'Radios' tab" do

      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")

      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
    end
    it "Change the description text for the first radio, save and verify the field" do
        if $status_up.exists?
          @ui.click('.radios_list .radio_item_container .radio_item')
          sleep 1
          @ui.set_input_val('.radios_list .radio_item_container .radio_item .general input', 'DESCRIPTION')
          sleep 1
          @ui.click('.arraydetails_header .subtitle')

          @browser.execute_script('$("#suggestion_box").hide()')
          @ui.click('#arraydetails_save')
          sleep 1

#          @ui.click('.radios_list .radio_item_container .radio_item')

          desc = @ui.css('.radios_list .radio_item_container .radio_item .general .description')
          desc.wait_until_present

          expect(desc.text).to eq('DESCRIPTION')


          @ui.click('#arraydetails_close_btn')
          @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)

        else
          puts "Skipped due to the fact that the AP is OFFLINE"
        end
    end
    it "Change the description text to null for the first radio, save and verify the field" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
        if $status_up.exists?

          sleep 1
          @ui.click('.radios_list .radio_item_container .radio_item')
          sleep 1
          @ui.set_input_val('.radios_list .radio_item_container .radio_item .general input', '')
          sleep 1
          @ui.click('.arraydetails_header .subtitle')

          @ui.click('#arraydetails_save')
          sleep 1
#          @ui.click('.radios_list .radio_item_container .radio_item')

          desc = @ui.css('.radios_list .radio_item_container .radio_item .general .description')
          #desc.wait_until_present

          expect(desc).not_to be_visible


          @ui.click('#arraydetails_close_btn')
          @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)

        else
          puts "Skipped due to the fact that the AP is OFFLINE"
        end
    end
  end
end

shared_examples "test profile access point radios tab advanced working" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - radios tab settings (advanced)" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end
    it "Go to the 'Radios' tab" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
    end
    it "Set Radio 1: Enabled 'True' / Unlocked 'False' / WiFi Mode 'N-Only' / Bond '40Mhz' / Monitor 'Off' / Transmit '18dBm' / Cell Size 'Manual' / Receive '-65dBm' / Channel(s) '108' / Band '5GHz" do
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # open the first radio up for editing
        @ui.click('.radios_list .radio_item_container .radio_item')
        sleep 1
        # Set the Monitor to OFF
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .monitorDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".monitorDdl ul", 0)
        sleep 1
        # Set band to 5 GHz
        @ui.click('.radios_list .radio_item_container .radio_item .band .band_50ghz')
        sleep 1
        # Transmit spinner editing
        @ui.set_val_for_input_field('.radios_list .radio_item_container .radio_item .tx .txInputContainer .spinner', '19')
        sleep 1
        @ui.click('.radios_list .radio_item_container .radio_item .tx .txInputContainer .spinner_controls .spinner_down')
        sleep 1
        # Receive spinned editing
        @ui.set_val_for_input_field('.radios_list .radio_item_container .radio_item .rx .rxInputContainer .spinner', '-65')
        sleep 1
        # Channel(s) dropdown list editing
        @ui.click('.radios_list .radio_item_container .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "108")
        sleep 1
        # Set the Locked status to TRUE
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(2) .lockDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".lockDdl ul", "Locked")
        sleep 1
        # Set the WiFi Mode to 'N-Only'
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(3) .wifiDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".wifiDdl ul", "N-Only")
        sleep 1
        # Set the Bond dropdown list to '40MHz'
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(4) .bondDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".bondDdl ul", 1)
        sleep 1
        # Navigate away from any control
        @ui.click('.arraydetails_header .subtitle')
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 2
        @ui.click('#arraydetails_close_btn')
        sleep 2
        @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end
    it "Open the Radios tab and VERIFY for Radio 1: Enabled 'True' / Unlocked 'False' / WiFi Mode 'N-Only' / Bond '40Mhz' / Monitor 'Off' / Transmit '18dBm' / Cell Size 'Manual' / Receive '-65dBm' / Channel(s) '1' / Band '5GHz" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # Verify status of Radio 1 as ENABLED TRUE
        status = @ui.css('.radios_list .radio_item_container .radio_item .information .enable')
        expect(status.text).to eq("Enabled")
        # Verify that the loc status is set to LOCKED
        lock = @ui.css('.radios_list .radio_item_container .radio_item .information .lock')
        expect(lock.text).to eq("Locked")
        # Verify that the WIFI Mode is set to N-0nly
        wifi_mode = @ui.css('.radios_list .radio_item_container .radio_item .information .wifi')
        expect(wifi_mode.text).to eq("N-Only")
        # Verify that the bond is set to 40MHz
        bond = @ui.css('.radios_list .radio_item_container .radio_item .information .bonded')
        expect(bond.text).to eq("Bonded (40MHz)")
        # Verify that the monitor is not displayed
        monitor = @ui.css('.radios_list .radio_item_container .radio_item .information .monitor')
        expect(monitor).not_to be_visible

        # Verify that the cell size is set to 'MANUAL'
        cell_size = @ui.css('.radios_list .radio_item_container .radio_item .cellSize')
        expect(cell_size.text).to eq("Manual")
        # Verify transmit is set to 18dBm
        transmit = @ui.css('.radios_list .radio_item_container .radio_item .tx.column')
        expect(transmit.text).to eq('18dBm')
        # Verify receive is set to -65dBm
        receive = @ui.css('.radios_list .radio_item_container .radio_item .rx.column')
        expect(receive.text).to eq('-65dBm')
        # Verify the channel is set to 1
        channels = @ui.css('.radios_list .radio_item_container .radio_item .channel span')
        expect(channels.text).to eq("108")
        # Verify that the radio is set to the band 5GHz
        @ui.click('.ko_slideout_content .slideout_title .title')
        small_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_24ghz')
        large_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_50ghz')
        expect(large_ghz).to be_visible
        expect(small_ghz).not_to be_visible
        sleep 2
        # close the slideout
        @ui.click('#arraydetails_close_btn')
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end

    ##### SECOND RADIO EDITING #####
    it "Go to the 'Radios' tab" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
    end
    it "Set Radio 2: Enabled 'Flase' / Unlocked 'N/A' / WiFi Mode 'BG' / Bond 'N/A' / Monitor 'On (Timeshare)' / Transmit 'N/A' / Cell Size 'Micro' / Receive 'N/A' / Channel(s) '4' / Band '2.4GHz" do
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # open the first radio up for editing
        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 1
        # Set the Monitor
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(5) .monitorDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".monitorDdl ul", 2)
        sleep 1
        # Set band to 2.4 GHz
        @ui.click('.radios_list div:nth-child(2) .radio_item .band .band_24ghz')
        sleep 1
        # Cell size list editing
        @ui.click('.radios_list div:nth-child(2) .radio_item .cellSize div:nth-child(2) .ko_dropdownlist .ko_dropdownlist_button .arrow')
        @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 0)
        # Channel(s) dropdown list editing
        @ui.click('.radios_list div:nth-child(2) .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "4")
        sleep 1
        # Set the WiFi Mode to 'BG'
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(3) .wifiDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".wifiDdl ul", "BG")
        sleep 1
        # Set the radio to disabled
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:first-child .ko_dropdownlist .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".enableDdl ul", 1)
        sleep 1
        # Navigate away from any control
        @ui.click('.arraydetails_header .subtitle')
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 2
        @ui.click('#arraydetails_close_btn')
        sleep 2
        @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Open the Radios tab and VERIFY for Radio 2: Enabled 'False' / Unlocked 'Monitor' / WiFi Mode 'BG' / Bond 'Unbonded' / Monitor 'ON Timeshare' /  Cell Size 'Manual' / Transmit '-15dBm' / Receive '-65dBm' / Channel(s) '4' / Band '2.4GHz" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # Verify status of Radio 1 as ENABLED TRUE
        status = @ui.css('.radios_list div:nth-child(2) .radio_item .information .enable')
        expect(status.text).to eq("Disabled")
        # Verify that the loc status is set to LOCKED
        lock = @ui.css('.radios_list div:nth-child(2) .radio_item .information .lock')
        expect(lock.text).to eq("Monitor")
        # Verify that the WIFI Mode is set to N-0nly
        wifi_mode = @ui.css('.radios_list div:nth-child(2) .radio_item .information .wifi')
        expect(wifi_mode.text).to eq("BG")
        # Verify that the bond is set to 40MHz
        bond = @ui.css('.radios_list div:nth-child(2) .radio_item .information .unbonded')
        expect(bond.text).to eq("Unbonded")
        # Verify that the monitor is not displayed
        monitor = @ui.css('.radios_list div:nth-child(2) .radio_item .information .monitor')
        expect(monitor).to be_visible
        expect(monitor.text).to eq('Timeshare Monitor')

        # Verify that the cell size is set to 'MANUAL'
        cell_size = @ui.css('.radios_list div:nth-child(2) .radio_item .cellSize')
        expect(cell_size.text).to eq("Manual")
        # Verify transmit is set to 18dBm
        transmit = @ui.css('.radios_list div:nth-child(2) .radio_item .tx.column')
        expect(transmit.text).to eq('-15dBm')
        # Verify receive is set to -65dBm
        receive = @ui.css('.radios_list div:nth-child(2) .radio_item .rx.column')
        expect(receive.text).to eq('-65dBm')
        # Verify the channel is set to 1
        channels = @ui.css('.radios_list div:nth-child(2) .radio_item .channel span')
        expect(channels.text).to eq("4")
        # Verify that the radio is set to the band 5GHz
        @ui.click('.ko_slideout_content .slideout_title .title')
        small_ghz = @ui.css('.radios_list div:nth-child(2) .radio_item .band .band_24ghz')
        large_ghz = @ui.css('.radios_list div:nth-child(2) .radio_item .band .band_50ghz')
        expect(small_ghz).to be_visible
        expect(large_ghz).not_to be_visible
        sleep 2
        # close the slideout
        @ui.click('#arraydetails_close_btn')
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end

    ##### REVERT RADIO CHANGES #####
    it "Go to the 'Radios' tab" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
    end
    it "Set Radio 1: Enabled 'True' / Unlocked 'N/A' / WiFi Mode 'BGN' / Bond 'Unbonded' / Monitor 'ON (Timeshare)' / Cell Size 'Max' /  Transmit '20dBm' / Receive '-90dBm' / Channel(s) '6' / Band '2,4GHz " do
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # open the first radio up for editing
        @ui.click('.radios_list .radio_item_container .radio_item')
        sleep 1
        # Set the radio to enabled
        @ui.click('.radios_list .radio_item_container .radio_item .information div:first-child .ko_dropdownlist .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".enableDdl ul", 0)
        sleep 1
        # Set the Monitor
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .monitorDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".monitorDdl ul", 2)
        sleep 1
        # Set band to 5 GHz
        @ui.click('.radios_list .radio_item_container .radio_item .band .band_24ghz')
        sleep 1
        # Cell size list editing
        @ui.click('.radios_list .radio_item_container .radio_item .cellSize div:nth-child(2) .ko_dropdownlist .ko_dropdownlist_button .arrow')
        @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 4)
        # Channel(s) dropdown list editing
        @ui.click('.radios_list .radio_item_container .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "6")
        sleep 1
        # Set the WiFi Mode to 'BGN'
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(3) .wifiDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".wifiDdl ul", "BGN")
        sleep 1
        # Set the Bond dropdown list to '40MHz'
        @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(4) .bondDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".bondDdl ul", 0)
        sleep 1
        # Navigate away from any control
        @ui.click('.arraydetails_header .subtitle')
        sleep 1
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end

    ### RADIO 2 ###
    it "Set Radio 2: Set Radio 2: Enabled 'True' / Unlocked 'True' / WiFi Mode 'AN' / Bond 'Bonded 40MHz' / Monitor 'Off' / Cell Size 'Max' /  Transmit '20dBm' / Receive '-90dBm' / Channel(s) '36' / Band '5GHz" do
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # open the first radio up for editing
        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 1
        # Set the radio to enabled
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:first-child .ko_dropdownlist .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".enableDdl ul", 0)
        sleep 1
        # Set the Monitor
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(5) .monitorDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".monitorDdl ul", 0)
        sleep 1
        # Set band to 5 GHz
        @ui.click('.radios_list div:nth-child(2) .radio_item .band .band_50ghz')
        sleep 1
        # Cell size list editing
        @ui.click('.radios_list div:nth-child(2) .radio_item .cellSize div:nth-child(2) .ko_dropdownlist .ko_dropdownlist_button .arrow')
        @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 4)
        # Channel(s) dropdown list editing
        @ui.click('.radios_list div:nth-child(2) .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "36")
        sleep 1
        # Set the WiFi Mode to 'AN'
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(3) .wifiDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string(".wifiDdl ul", "AN")
        sleep 1
        # Set the Bond dropdown list to '40MHz'
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(4) .bondDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".bondDdl ul", 1)
        sleep 1
        # Navigate away from any control
        @ui.click('.arraydetails_header .subtitle')
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 2
        @ui.click('#arraydetails_close_btn')
        sleep 2
        @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end

    it "Open the Radios tab and VERIFY for Radio 1: Enabled 'True' / Unlocked 'Monitor' / WiFi Mode 'BGN' / Bond 'Unbonded' / Monitor 'ON Timeshare' /  Cell Size 'Max' / Transmit '20dBm' / Receive '-90dBm' / Channel(s) '6' / Band '2.4GHz" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # Verify status of Radio 1 as ENABLED TRUE
        status = @ui.css('.radios_list .radio_item_container .radio_item .information .enable')
        expect(status.text).to eq("Enabled")
        # Verify that the loc status is set to LOCKED
        lock = @ui.css('.radios_list .radio_item_container .radio_item .information .lock')
        expect(lock.text).to eq("Monitor")
        # Verify that the WIFI Mode is set to N-0nly
        wifi_mode = @ui.css('.radios_list .radio_item_container .radio_item .information .wifi')
        expect(wifi_mode.text).to eq("BGN")
        # Verify that the bond is set to 40MHz
        bond = @ui.css('.radios_list .radio_item_container .radio_item .information .unbonded')
        expect(bond.text).to eq("Unbonded")
        # Verify that the monitor is not displayed
        monitor = @ui.css('.radios_list .radio_item_container .radio_item .information .monitor')
        expect(monitor).to be_visible
        expect(monitor.text).to eq('Timeshare Monitor')

        # Verify that the cell size is set to 'MANUAL'
        cell_size = @ui.css('.radios_list .radio_item_container .radio_item .cellSize')
        expect(cell_size.text).to eq("Max")
        # Verify transmit is set to 18dBm
        transmit = @ui.css('.radios_list .radio_item_container .radio_item .tx.column')
        expect(transmit.text).to eq('20dBm')
        # Verify receive is set to -65dBm
        receive = @ui.css('.radios_list .radio_item_container .radio_item .rx.column')
        expect(receive.text).to eq('-90dBm')
        # Verify the channel is set to 1
        channels = @ui.css('.radios_list .radio_item_container .radio_item .channel span')
        expect(channels.text).to eq("6")
        # Verify that the radio is set to the band 5GHz
        @ui.click('.ko_slideout_content .slideout_title .title')
        small_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_24ghz')
        large_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_50ghz')
        expect(small_ghz).to be_visible
        expect(large_ghz).not_to be_visible
        sleep 2
        # close the slideout
        @ui.click('#arraydetails_close_btn')
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end

    it "Open the Radios tab and VERIFY for Radio 2: Enabled 'True' / Unlocked 'True' / WiFi Mode 'AN' / Bond 'Bonded (40Mhz)' / Monitor 'OFF' /  Cell Size 'Max' / Transmit '20dBm' / Receive '-90dBm' / Channel(s) '36' / Band '5GHz" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
      if $status_up.exists?
        # open the full view of the slideout
        @ui.click('#arraydetails_togglefull')
        sleep 1
        # open the advanced options
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        # Verify status of Radio 1 as ENABLED TRUE
        status = @ui.css('.radios_list div:nth-child(2) .radio_item .information .enable')
        expect(status.text).to eq("Enabled")
        # Verify that the loc status is set to LOCKED
        lock = @ui.css('.radios_list div:nth-child(2) .radio_item .information .lock')
        expect(lock.text).to eq("Unlocked")
        # Verify that the WIFI Mode is set to N-0nly
        wifi_mode = @ui.css('.radios_list div:nth-child(2) .radio_item .information .wifi')
        expect(wifi_mode.text).to eq("AN")
        # Verify that the bond is set to 40MHz
        bond = @ui.css('.radios_list div:nth-child(2) .radio_item .information .bonded')
        expect(bond.text).to eq("Bonded (40MHz)")
        # Verify that the monitor is not displayed
        monitor = @ui.css('.radios_list div:nth-child(2) .radio_item .information .monitor')
        expect(monitor).not_to be_visible

        # Verify that the cell size is set to 'MANUAL'
        cell_size = @ui.css('.radios_list div:nth-child(2) .radio_item .cellSize')
        expect(cell_size.text).to eq("Max")
        # Verify transmit is set to 18dBm
        transmit = @ui.css('.radios_list div:nth-child(2) .radio_item .tx.column')
        expect(transmit.text).to eq('20dBm')
        # Verify receive is set to -65dBm
        receive = @ui.css('.radios_list div:nth-child(2) .radio_item .rx.column')
        expect(receive.text).to eq('-90dBm')
        # Verify the channel is set to 1
        channels = @ui.css('.radios_list div:nth-child(2) .radio_item .channel span:first-child')
        expect(channels.text).to eq("36")
        # Verify that the radio is set to the band 5GHz
        @ui.click('.ko_slideout_content .slideout_title .title')
        small_ghz = @ui.css('.radios_list div:nth-child(2) .radio_item .band .band_24ghz')
        large_ghz = @ui.css('.radios_list div:nth-child(2) .radio_item .band .band_50ghz')
        expect(small_ghz).not_to be_visible
        expect(large_ghz).to be_visible
        sleep 2
        # close the slideout
        @ui.click('#arraydetails_close_btn')
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
        @ui.click('#arraydetails_close_btn')
      end
    end
  end
end


shared_examples "test profile access point radios tab advanced" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - radios tab settings (advanced)" do
    it "Go to the profile named '#{profile_name}' then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end
    it "Go to the 'Radios' tab" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      $status_up = @ui.css('.slideout_title .online_status.UP')
      $status_up.wait_until_present
    end
    it "Change Transmit to 18 dBm and set channel to 1, save then wait for the Access Point to have the status 'Activated'" do
        if $status_up.exists?

          sleep 1

          sleep 1
          @ui.click('.radios_list .radio_item_container .radio_item')
          sleep 1

          sleep 1
          @ui.click('.arraydetails_header .subtitle')
          sleep 1
          @ui.click('#arraydetails_save')
          sleep 1
          @ui.click('#arraydetails_close_btn')
          sleep 1

          sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
          #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
        else
          puts "Skipped due to the fact that the AP is OFFLINE"
        end
    end
    it "Verify cellSize is Manual, channel is 1" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")

      @ui.click('#arraydetails_togglefull')
      sleep 1
      @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')

      channels = @ui.css('.radios_list .radio_item_container .radio_item .channel span')
      @ui.click('.radios_list .radio_item_container .radio_item')
      cell_size = @ui.css('.radios_list .radio_item_container .radio_item .cellSize .ko_dropdownlist_button .text')
      expect(channels.text).to eq("1")
      expect(cell_size.text).to eq("Manual")
    end
    it "Select all radios, disable them, save then wait for the Access Point to have the status 'Activated'" do
      if $status_up.exists?
         @ui.click('.radios_list_top .select_all_radios')
         sleep 1
         @ui.click('#profile_arrays_details_slideout .tab_contents .arraydetails_radios_list .radios_actions_container .blue')
         sleep 2
         @ui.click('#arraydetails_save')
         sleep 2
         @ui.click('#arraydetails_close_btn')
         sleep 1
         sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
         #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the radios are disabled" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      status = @ui.css('.radios_list .radio_item_container .radio_item .information .enable')
      expect(status.text).to eq("Disabled")
    end
    it "Select all radios, enable, save and verify radios are enabled" do
      if $status_up.exists?
        sleep 1
        @ui.click('.radios_list_top .select_all_radios')
        sleep 1
        @ui.click('#profile_arrays_details_slideout .tab_contents .arraydetails_radios_list .radios_actions_container .blue')
        sleep 2
        @ui.click('#arraydetails_save')
        sleep 2
        @ui.click('#arraydetails_close_btn')
        sleep 1
        sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
        #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the radios are enabled" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      status = @ui.css('.radios_list .radio_item_container .radio_item .information .enable')
      expect(status.text).to eq("Enabled")
    end
    it "Edit all radios, set on band 5 GHz, set Bond Mode to 'Bond (40MHz)' apply, save and verify that the bond is 40MHz and that the 50GHz band is selected" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        @ui.click('.radios_list_top .select_all_radios')
        sleep 1
        @ui.click('#profile_arrays_details_slideout .tab_contents .arraydetails_radios_list .radios_actions_container div:nth-child(2)')
        sleep 1
        @ui.click('.radios_multiEdit .radio_item .band .band_50ghz')
        sleep 1
        @ui.click('.radios_multiEdit .radio_item .information div:nth-child(4) .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".bondDdl ul", 1)
        sleep 1
        @ui.click('.radios_multiEdit .buttons .orange')
        sleep 1
        @ui.click('#arraydetails_save')
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the application displays an error message" do
      if $status_up.exists?
        expect(@ui.css('.radios_errors_container .radios_errors .radios_errors_title').text).to eq('1 Error to review:')
        expect(@ui.css('.radios_errors_container .radios_errors ul li .radios_error .radios_error_name').text).to eq('Radio 2')
        expect(@ui.css('.radios_errors_container .radios_errors .radios_error_desc').text).to eq('40Mhz bonding not supported on Channel 165')
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Correct the error by changing Radio 2's channel to '64' (18)" do
      if $status_up.exists?
        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 18)
        sleep 1
        @ui.click('.arraydetails_header .subtitle')
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 1
        @ui.click('#arraydetails_close_btn')
        sleep 1
        sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
        #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the radios are on the band '50GHz', that the bond is set to '40MHz' and that the second radio has the channel set to '64'" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        @ui.click('.ko_slideout_content .slideout_title .title')
        sleep 0.5
        small_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_24ghz')
        large_ghz = @ui.css('.radios_list .radio_item_container .radio_item .band .band_50ghz')
        expect(large_ghz).to be_visible
        expect(small_ghz).not_to be_visible

        @ui.click('.radios_list .radio_item_container .radio_item')
        sleep 0.5
        bond = @ui.css('.radios_list .radio_item_container .radio_item .information div:nth-child(4) .bondDdl a span')
        expect(bond.text).to eq("Bond (40MHz)")
        sleep 1
        @ui.click('.arraydetails_header .subtitle')

        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 0.5
        channel = @ui.css('.radios_list div:nth-child(2) .radio_item .channel span')
        expect(channel.text).to eq("64")
      else
          puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Select all radios, remove radio 1 and set the lock option to 'Locked', apply, save then wait for the Access Point to have the status 'Activated'" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        sleep 1
        @ui.click('.radios_list_top .select_all_radios')
        sleep 1
        @ui.click('#profile_arrays_details_slideout .tab_contents .arraydetails_radios_list .radios_actions_container div:nth-child(2)')
        sleep 1
        @ui.click('.radios_multiEdit .header .tags span:first-child .delete')
        sleep 1
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        @ui.click('.radios_multiEdit .radio_item .information div:nth-child(2) .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".lockDdl ul", 0)
        sleep 1
        @ui.click('.radios_multiEdit .buttons .orange')
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 1
        @ui.click('#arraydetails_close_btn')
        sleep 1
        sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
        #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the second radio's locked option is set to 'Locked'" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        lock = @ui.css('.radios_list div:nth-child(2) .radio_item .information .lock')
        expect(lock.text).to eq("Locked")
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Select radio 2 and set the wifi mode to 'N-Only', apply, save then wait for the Access Point to have the status 'Activated'" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item .information .lock')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(3) .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".wifiDdl ul", 10)
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 1
        @ui.click('#arraydetails_close_btn')
      sleep 1
      sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
      #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the second radio's wifi mode is set to 'N-Only" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        wifi_mode = @ui.css('.radios_list div:nth-child(2) .radio_item .information .wifi')
        expect(wifi_mode.text).to eq("N-Only")
        lock = @ui.css('.radios_list div:nth-child(2) .radio_item .information .lock')
        expect(lock.text).to eq("Locked")
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Hide advanced, make the slideout small, disable the second radio, save then wait for the Access Point to have the status 'Activated'" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
        sleep 1
        @ui.click('#arraydetails_togglefull')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(1) .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".enableDdl ul", 1)
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 1
        @ui.click('#arraydetails_close_btn')
        sleep 1
        sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
        #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the second radio's status is 'Disabled'" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        enable_radio = @ui.css('.radios_list div:nth-child(2) .radio_item .information .enable')
        expect(enable_radio.text).to eq("Disabled")
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end

    it "Show advanced, enable the second radio, save then wait for the Access Point to have the status 'Activated'" do
      #open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
        @ui.click('.arraydetails_radios .commonAdvanced')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item')
        sleep 1
        @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(1) .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_index(".enableDdl ul", 0)
        sleep 1
        @ui.click('#arraydetails_save')
        sleep 1
        @ui.click('#arraydetails_close_btn')
        sleep 1
        sleep 6
          for i in 0..10
            @ui.css('.nssg-paging .nssg-refresh').click
            sleep 1.5
          end
        #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
      else
        puts "Skipped due to the fact that the AP is OFFLINE"
      end
    end
    it "Verify that the second radio's status is 'Enabled'" do
      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
      if $status_up.exists?
          enable_radio2 = @ui.css('.radios_list div:nth-child(2) .radio_item .information .enable')
          expect(enable_radio2.text).to eq("Enabled")
        else
          puts "Skipped due to the fact that the AP is OFFLINE"
        end
    end
#    it "Set the monitor to On(Dedicated), save and verify the monitor status" do
#        open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
#        if $status_up.exists?
#
#          @ui.click('#arraydetails_tab_radios')
#          sleep 4
#          @ui.click('#arraydetails_togglefull')
#          sleep 1
#          @ui.click('.arraydetails_radios .commonAdvanced')
#          sleep 1
#          @ui.click('.arraydetails_header .subtitle')
#          sleep 1
#          @ui.css('.radios_list .radio_item_container .radio_item .general .iapName').hover
#          sleep 1
#          @ui.click('.radios_list .radio_item_container .editIcon .icon')
#          sleep 1
#          @ui.click('.radios_list .radio_item_container .radio_item .radio_checkbox .mac_chk_label')
#          sleep 1
#          @ui.click('.radios_list .radio_item_container .radio_item')
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .ko_dropdownlist_button .arrow')
#          sleep 1
#          @ui.ul_list_select_by_index(".monitorDdl ul", 1)
#          sleep 1
#          @ui.click('#arraydetails_save')
#          sleep 1
#
#          monitor1 = @ui.css('.radios_list div:first-child .radio_item .information .monitor')
#
#          expect(monitor1.text).to eq("Dedicated Monitor")
#
#
#          @ui.click('#arraydetails_close_btn')
#         @browser.refresh
          #@ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
#
#        else
#          puts "Skipped due to the fact that the AP is OFFLINE"
#        end
#    end
#    it "Set the monitor to Monitor Off, save and verify the monitor status" do
#      open_slideout_container_and_go_to_radios_tab(3, "div", ap_name, "invoke")
#        if $status_up.exists?
#
#          sleep 1
#          @ui.click('.radios_list .radio_item_container .radio_item')
#          sleep 1
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .ko_dropdownlist_button .arrow')
#          sleep 1
#          @ui.ul_list_select_by_index(".monitorDdl ul", 0)
#          sleep 1
#          @ui.click('#arraydetails_save')
#          sleep 1
#
#          monitor2 = @ui.css('.radios_list div:nth-child(2) .radio_item .information .monitor')
#
#          expect(monitor2).not_to be_visible
#
#
#          @ui.click('#arraydetails_close_btn')
#          @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
#
#        else
#          puts "Skipped due to the fact that the AP is OFFLINE"
#        end
#    end
#
#
#    it "return AP config radios to default values" do
#
#        @ui.grid_action_on_specific_line(3, "div", ap_name, "invoke")
#        sleep 1
#        @ui.click('#arraydetails_tab_radios')
#        sleep 2
#        if $status_up.exists?
#          @ui.click('#arraydetails_togglefull')
#          sleep 1
#          @ui.click('.arraydetails_radios .subtitleContainer .commonAdvanced')
#          sleep 1
#          ################################ TO EDIT #############################################
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item')
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(1) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".enableDdl ul", 0)
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".monitorDdl ul", 2)
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(3) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".wifiDdl ul", 5)
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(4) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".bondDdl ul", 0)
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 11)
#          #sleep 0.5
#          #@ui.click('.radios_list .radio_item_container .radio_item .cellSize .channelDdl .ko_dropdownlist_button .arrow')
#          #sleep 0.2
#          #@ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 4)
#          sleep 0.5
#          @ui.click('.radios_list .radio_item_container .radio_item .band .band_24ghz')
#          sleep 0.5
#          @ui.click('#arraydetails_save')
#
#          sleep 0.5
#          @ui.click('.radios_list div:nth-child(2) .radio_item')
#          @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(1) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".enableDdl ul", 0)
#          sleep 0.5
#          @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(2) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".lockDdl ul", 0)
#          sleep 0.5
#          @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(3) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".wifiDdl ul", 4)
#          sleep 0.5
#          @ui.click('.radios_list div:nth-child(2) .radio_item .information div:nth-child(4) .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".bondDdl ul", 1)
#          sleep 0.5
#          @ui.click('.radios_list div:nth-child(2) .radio_item .channel .channelDdl .ko_dropdownlist_button .arrow')
#          sleep 0.2
#          @ui.ul_list_select_by_index(".ko_dropdownlist_list.active ul", 0)
#          sleep 0.5
#          @ui.click('#arraydetails_save')
#
#          ################################ TO EDIT #############################################
#        else
#          puts "The radio configurations are not displayed due to the fact that the AP is OFFLINE !"
#        end
#        sleep 2
#        @ui.click('#arraydetails_close_btn')
#
#        @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)
#
#    end
  end
end

shared_examples "test profile access point cli tab" do |profile_name, ap_name, ap_sn|
  describe "Test the access point '#{ap_name}' - command line interface tab settings" do
    it "Go to the profile named #{profile_name} then on to the Access Points tab" do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
      sleep 2
    end
    it "Test the AP Command Line Interface: Send the 'show iaps' command and verify that the console output has the 'hostname #{ap_name}' value " do
      @ui.grid_action_on_specific_line(3, "div", ap_name, "invoke")

      #@ui.click('.nssg-action-invoke')
      sleep 1

      @ui.click('#arraydetails_tab_cli')
      sleep 1

      if $status_up.exists?
          @ui.click('.array-details-cli-agreement-btn')
          cli = @ui.get(:textarea, {id: 'array-details-cli-commands-input'})
          cli.wait_until_present
          cli.send_keys 'show'
          cli.send_keys :enter
          cli.send_keys 'iaps'

          @ui.click('#array-details-cli-submit')
          sleep 10

          resp = @ui.get(:textarea, { css: '.array-details-cli-results-response' })
          resp.wait_until_present

          expect(resp.value).to include('hostname ' + ap_name)

          sleep 3


          @ui.click('#arraydetails_close_btn')
          @ui.get_cell_text_on_ap_grid(ap_name,"Status","Activated",true)

      else
          expect(@ui.css('#profile_arrays_details_slideout .tab_contents .nodata span').text).to eq('Access Point Commands are unavailable because this Access Point is offline.')
          @ui.click('#arraydetails_close_btn')
      end
    end
  end
end

shared_examples "test profile access point read only" do |profile_name, ap_name|
  describe "test profile access point read only" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_tab_arrays')
    end

    it "test ap config general is disabled" do
      @ui.grid_action_on_specific_line(3, "div", ap_name, "invoke")

      #@ui.click('.nssg-action-invoke')
      sleep 1

      @ui.click('#arraydetails_tab_general')
      sleep 1

      loc = @ui.get(:text_field, { id: 'edit_location' })
      expect(loc.enabled?).to eq(false)

      sleep 1
      @ui.click('#arraydetails_close_btn')
    end

    it "test ap config radios is disabled" do
      @ui.grid_action_on_specific_line(3, "a", ap_name, "invoke")

      #@ui.click('.nssg-action-invoke')
      sleep 1

      @ui.click('#arraydetails_tab_radios')
      sleep 1

      status = @ui.css('.slideout_title .online_status')
      status.wait_until_present

      if status=="Online"
          expect(@ui.css('.readonly_indicator')).to be_visible
      end

      @ui.click('#arraydetails_close_btn')
    end
  end
end

shared_examples "test profile access point list" do |profile_name, ap_name, default_columns_length, use_export|
  describe "test profile access point list" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name and @ui.css('#profile_tab_arrays').wait_until_present
      sleep 4
      @ui.click('#profile_tab_arrays') and @ui.css('#profile_array_add_btn').wait_until_present
    end
    it "Sort APs" do
      cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
      cell.wait_until_present
      first_cell = cell.title

      @ui.click('.nssg-table thead tr th:nth-child(3)')
      sleep 1

      cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
      cell.wait_until_present
      expect(cell.title).to_not eq(first_cell)

      @ui.click('.nssg-table thead tr th:nth-child(3)')
    end
    it "Add the 'Model' column" do
      cp = @ui.css('.columnPickerIcon').parent
      cp.wait_until_present
      cp.click
      sleep 1

      list = @ui.css('.column_selector_modal .lhs ul')
      list.wait_until_present

      col = list.li(:text => 'Model')
      col.wait_until_present
      col.click
      sleep 1

      @ui.click('#column_selector_modal_move_btn')
      sleep 1
      @ui.click('#column_selector_modal_save_btn')
      sleep 1

      cell = @ui.css(".nssg-table thead tr th:nth-child(#{default_columns_length+1})")
      cell.wait_until_present
      expect(cell.text).to eq("Model")
    end
    it "Remove the 'Model' column" do
      cp = @ui.css('.columnPickerIcon').parent
      cp.wait_until_present
      cp.click
      sleep 1

      list = @ui.css('.column_selector_modal .rhs ul')
      list.wait_until_present

      col = list.li(:text => 'Model')
      col.wait_until_present
      col.click
      sleep 1

      @ui.click('#column_selector_modal_remove_btn')
      sleep 1
      @ui.click('#column_selector_modal_save_btn')
      sleep 1

      tr = @ui.css('.nssg-table thead tr')
      tr.wait_until_present
      expect(tr.ths.length).to eq(default_columns_length)
    end
    if use_export == true
      it "export arrays" do
          @ui.click('#mn-cl-export-btn-mnu')
          sleep 1
          @ui.click('#mn-cl-export-btn-mnu .drop_menu_nav .nav_item')

          fname = @download + "/AccessPoints-" + profile_name + "-" + (Date.today.to_s) + ".csv"
          file = File.open(fname, "r")
          data = file.read
          file.close

          expect(data.include?(ap_name)).to eq(true)

          File.delete(@download +"/AccessPoints-" + profile_name + "-" + (Date.today.to_s) + ".csv")
      end
    end
    it "array search" do
        search_box_element = find_proper_search_box
        search_box_element.hover
        sleep 0.5
        search_box_element.element(css: ' input').send_keys ap_name
        #@ui.set_input_val('.xc-search input', ap_name)
        #@ui.click('.btn-search')
        sleep 1

        grid = @ui.css('.nssg-table')
        grid.wait_until_present
        expect(grid.trs.length).to eq(2)

        cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
        cell.wait_until_present
        expect(cell.title).to eq(ap_name)

        search_box_element.element(css: '.btn-clear').click
        #@ui.click('.btn-clear')
    end
  end
end