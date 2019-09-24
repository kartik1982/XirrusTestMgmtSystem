require_relative "../../TS_SupportManagement/local_lib/support_management_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"

def go_to_my_network_arrays_tab
  # make sure it goes to the my network
  @ui.css('#header_mynetwork_link').wait_until_present
  @ui.click('#header_mynetwork_link')
  sleep 2.5
  @ui.click('#mynetwork_tab_arrays')
  sleep 2
  @ui.css("#arrays_grid").wait_until_present
  expect(@browser.url).to include("/#mynetwork/aps")
  sleep 1.5
end

def go_to_my_network_switches_tab
  # make sure it goes to the my network
  @ui.css('#header_mynetwork_link').wait_until_present
  @ui.click('#header_mynetwork_link')
  sleep 2.5
  @ui.click('#mynetwork_tab_switches')
  sleep 2
  expect(@browser.url).to include("/#mynetwork/switches")
  sleep 1.5
end

def if_not_already_present_add_certain_column(wanted_column_name)
  column_names = @ui.get(:elements, {css: ".nssg-table thead .nssg-th-text .nssg-th-text"})
  column_names.each do |column_name|
    puts column_name.text
    if column_name.text == wanted_column_name
      return true
    end
  end
  @ui.click('#mynetwork_arrays_grid_cp')
  sleep 1
  column_names = @ui.get(:elements, {css: ".lhs .select_list ul li"})
  column_names.each do |column_name|
    puts column_name.text
    if column_name.text == wanted_column_name
      column_name.click
      break
    end
  end
  @ui.click("#column_selector_modal_move_btn")
  sleep 1
  @ui.click("#column_selector_modal_save_btn")
  sleep 2
  expect(@ui.css('thead')).to be_present
  column_names = @ui.get(:elements, {css: ".nssg-table thead .nssg-th-text .nssg-th-text"})
  column_names.each do |column_name|
    puts column_name.text
    if column_name.text == wanted_column_name
      return true
    end
  end
end

shared_examples "go to mynetwork access points tab" do
  describe "Go to the Access Points tab of the My Network area" do
    it "Go to the Access Points tab of the My Network area " do
      @ui.click('#header_mynetwork_link')
      sleep 2.5
      @ui.click('#mynetwork_tab_arrays')
      sleep 1
    end
  end
end

shared_examples "change to tenant" do |tenant_name, found_tenants|
  describe "Change to the tenant named '#{tenant_name}'" do
    it "Open the tenant dropdown list" do
      expect(@ui.css('.tenant_dd')).to be_present
      @ui.click(".tenant_dd .ko_dropdownlist_button .arrow")
      sleep 1
      expect(@ui.css('.ko_dropdownlist_list.has_search.blue.active .search-input')).to be_visible
      sleep 1
      @ui.set_input_val('.ko_dropdownlist_list.has_search.blue.active .search-input', tenant_name)
    end
    it "Click on the tenant name to scope to it" do
      tenants_displayed = @ui.css('.ko_dropdownlist_list.has_search.blue.active .ko_dropdownlist_list_scroller').lis.length
      if @ui.css('.ko_dropdownlist_list.has_search.blue.active .ko_dropdownlist_list_scroller li:nth-child(1)').text == "Choose a scope..."
        found_tenants = found_tenants + 1
      end
      expect(tenants_displayed).to eq(found_tenants)
      if tenants_displayed > 1
        while tenants_displayed > 0
          if @ui.css(".ko_dropdownlist_list.has_search.blue.active .ko_dropdownlist_list_scroller li:nth-child(#{tenants_displayed}) span:first-child").text == tenant_name
            @ui.click(".ko_dropdownlist_list.has_search.blue.active .ko_dropdownlist_list_scroller li:nth-child(#{tenants_displayed})")
            break
          end
          tenants_displayed-=1
        end
      else
        @ui.click('.ko_dropdownlist_list.has_search.blue.active .ko_dropdownlist_list_scroller li:first-child')
      end
      sleep 2
    end
    it "Verify that the tenant is '#{tenant_name}'" do
      break_int = 0
      while @ui.css('.tenant_dd .ko_dropdownlist_button .text').text != tenant_name
        sleep 1
        break_int += 1
        if break_int == 30
          break
        end
      end
      expect(@ui.css('.tenant_dd .ko_dropdownlist_button .text').text).to eq(tenant_name)
    end
  end
end

shared_examples "reset grid to default view" do |which_location, profile_name|
  describe "Reset the grid to the default view options" do
    it "Go to the location '#{which_location}'" do
      @ui.click('#header_mynetwork_link')
      sleep 2
      @ui.css('#mynetwork_view .globalTitle').wait_until_present
      sleep 1
      case which_location
        when "My Network - Access Points tab"
          expect(@ui.css('#mynetwork_tab_arrays')).to be_present
          @ui.click('#mynetwork_tab_arrays')
          sleep 1
          @ui.css('.arrays_tab .commonTitle').wait_until_present
        when "Profile - Access Points tab", "Profile - Access Points tab (SteelConnect)"
          @ui.goto_profile profile_name
          sleep 4
          @ui.click('#profile_tab_arrays')
          sleep 1.5
          expect(@browser.url).to include('/#profiles/')
          expect(@browser.url).to include('/aps')
          @ui.css('#profile_arrays .commonTitle').wait_until_present
      end
    end
    it "Verify that the grid exists and has the proper features" do
      case which_location
        when "My Network - Access Points tab"
          expect(@ui.css('#mynetwork_arrays_grid_cp')).to be_present
          expect(@ui.css('.nssg-table')).to be_present
          verify_search_box(true)
          #expect(@ui.css('.xc-search')).to be_present
          expect(@ui.css('.nssg-paging-selector-container')).to be_present
          expect(@ui.css('.nssg-paging-count')).to be_present
          expect(@ui.css('.nssg-refresh')).to be_present
        when "Profile - Access Points tab", "Profile - Access Points tab (SteelConnect)"
          expect(@ui.css('#profile_arrays_grid_cp')).to be_present
          expect(@ui.css('.nssg-table')).to be_present
          if @ui.css('.nssg-table tbody').trs.length != 0
            expect(@ui.css('#arrays_grid .pull-right .clearfix search .xc-search')).to be_present  
          else
            expect(@ui.css('.xc-search')).not_to be_present
          end
          expect(@ui.css('.nssg-paging-selector-container')).to be_present
          expect(@ui.css('.nssg-paging-count')).to be_present
          expect(@ui.css('.nssg-refresh')).to be_present
      end
    end
    it "Restore the grid to 'Default' view" do
      case which_location
        when "My Network - Access Points tab"
          @ui.click('#mynetwork_arrays_grid_cp')
          sleep 1
          @ui.css('#mynetwork_arrays_grid_cp_modal').wait_until_present
        when "Profile - Access Points tab", "Profile - Access Points tab (SteelConnect)"
          @ui.click('#profile_arrays_grid_cp')
          sleep 1
          @ui.css('#profile_arrays_grid_cp_modal').wait_until_present
      end
      expect(@ui.css('#column_selector_restore_defaults')).to be_present
      @ui.click('#column_selector_restore_defaults')
      sleep 1
      @ui.click('#column_selector_modal_save_btn')
      sleep 1
      case which_location
        when "My Network - Access Points tab"
          @ui.css('#mynetwork_arrays_grid_cp_modal').wait_while_present
        when "Profile - Access Points tab", "Profile - Access Points tab (SteelConnect)"
          @ui.css('#profile_arrays_grid_cp_modal').wait_while_present
      end
    end
    it "Verify the default columns of the grid depending on the location '#{which_location}'" do
      case which_location
        when "My Network - Access Points tab"
          column_names = ["Check Box","Access Point Hostname","Serial Number","Profile","DHCP Pool","IP Address","Location","Status","Online","Expiration Date"]
          verify_existing_columns_names(column_names, 2)
        when "Profile - Access Points tab"
          column_names = ["Check Box","Access Point Hostname","Serial Number","Tags","DHCP Pool","IP Address","Location","Status","Online","Expiration Date"]
          verify_existing_columns_names(column_names, 2)
        when "Profile - Access Points tab (SteelConnect)"
          column_names = ["Check Box","Access Point Hostname","Serial Number","DHCP Pool","IP Address","Location","Status","Online","Expiration Date"]
          verify_existing_columns_names(column_names, 2)
      end
    end
  end
end

shared_examples "verify put in out of service disbaled false" do |which_location, profile_name|
  describe "Verify that the 'IN/OUT of Service' function is disabled on the location '#{which_location}' grid" do
   it "Go to the location '#{which_location}'" do
      @ui.click('#header_mynetwork_link')
      sleep 2
      @ui.css('#mynetwork_view .globalTitle').wait_until_present
      sleep 1
      case which_location
        when "My Network - Access Points tab"
          expect(@ui.css('#mynetwork_tab_arrays')).to be_present
          @ui.click('#mynetwork_tab_arrays')
          sleep 1
          @ui.css('.arrays_tab .commonTitle').wait_until_present
        when "Profile - Access Points tab"
          @ui.goto_profile profile_name
          sleep 2
          @ui.click('#profile_tab_arrays')
          sleep 1.5
          expect(@browser.url).to include('/#profiles/')
          expect(@browser.url).to include('/aps')
          @ui.css('#profile_arrays .commonTitle').wait_until_present
      end
    end
    it "Place a tick for the first array in the grid and verify the proper 'More' options" do
      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(2) .nssg-td-select input + .mac_chk_label')
      sleep 1
      expect(@ui.css('#arrays_grid .push-down .pull-left .bubble .count').text.to_i).to eq(1)
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      expect(@ui.css('#arrays-menu-reboot')).to be_present
      if @ui.css('#arrays-menu-admin-offline').visible?
        expect(@ui.css('#arrays-menu-admin-none')).not_to be_present
        expect(@ui.css('#arrays-menu-admin-offline')).to be_present
      else
        expect(@ui.css('#arrays-menu-admin-none')).to be_present
        expect(@ui.css('#arrays-menu-admin-offline')).not_to be_present
      end

    end
  end
end



shared_examples "verify certain ap is not out of service" do |serial_number|
  describe "Verify that a certain AP is not Out Of Service, if so put it back into service" do
    it "If the location isn't CommandCenter Access Points, navigate there" do
      if !@browser.url.include?("/#msp/arrays")
        @ui.click('#header_logo')
        sleep 1
        @ui.css('.globalTitle').wait_until_present
        @ui.click('#msp_tab_arrays')
        sleep 1
        @ui.css('.tabs_container .tab-item-container .commonTitle').wait_until_present
        expect(@ui.css('.tabs_container .tab-item-container .commonTitle span').text).to include("Access Points")
      end
    end
    it "Set the view per page to '1000' entries" do
      if @ui.css('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .text') != "1000"
        @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
        sleep 1
        @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "1000")
        sleep 2
      end
    end
    it "Verify that the array is not Out of Service, if it is place a tick for the line and verify the open the 'More' options and the 'Put in Service' button" do
      #@@array_sn_depending_on_browser = find_array_serial_number_depending_on_the_browser_used(serial_number)
      #@ui.find_array_depending_on_included_strings_then_return_path(serial_number, 4, "div")
      @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(serial_number, 4, "div")
      css_of_cell = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(8) div")
      @@expected_cell_string = @ui.css(css_of_cell).text
      #@ui.grid_verify_strig_value_on_specific_line("4", @@array_sn_depending_on_browser, "div", "8", "div", "Out of Service")
      if @@expected_cell_string == "Out of Service"
        tick_box = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(2) .mac_chk_label")
        @ui.click(tick_box)
        sleep 1
        more_button = @ui.css('#arrays_more_btn').parent
        expect(more_button).to be_present
        more_button.element(css: ".icon").click
        sleep 1
        expect(more_button.element(css: ".more_menu")).to be_present
        @ui.click('#msp_arrays_admin_none')
      end
    end
    it "Refresh the grid and verify the AP is not 'Out of Service'" do
      @ui.click('.nssg-refresh')
      sleep 1
      #array_sn_depending_on_browser = find_array_serial_number_depending_on_the_browser_used(serial_number)
      @path_of_line = @ui.find_array_depending_on_included_strings_then_return_path(serial_number, 4, "div")
      css_of_cell = @path_of_line.sub("td:nth-child(4) div", "td:nth-child(8) div")
      @@expected_cell_string = @ui.css(css_of_cell).text
      expect(@@expected_cell_string).to eq("")
    end
  end
end


shared_examples "put in out of service first array in grid" do
  describe "Put IN/OUT of Service the first array in the My Network - Access Points grid" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "Place a tick for the first array in the grid and verify the proper 'More' options" do
      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(2) .nssg-td-select input + .mac_chk_label')
      sleep 1
      expect(@ui.css('#arrays_grid .push-down .pull-left .bubble .count').text.to_i).to eq(1)
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      expect(@ui.css('#arrays-menu-reboot')).to be_present
      #expect(@ui.css('#arrays.menu.reset')).to exist
      @@original_status = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text
      if @@original_status == "Offline (Out of Service)"
        expect(@ui.css('#arrays-menu-admin-none')).to be_present
      else
        expect(@ui.css('#arrays-menu-admin-offline')).to be_present
      end
    end
    it "Press the 'Take Out of Service' or 'Put in Service' button and refresh the grid" do
      if @@original_status == "Offline (Out of Service)"
        @ui.click('#arrays-menu-admin-none')
      else
        @ui.click('#arrays-menu-admin-offline')
      end
      sleep 3
      @ui.click('.nssg-refresh')
      sleep 1
    end
    it "Verify that the Access Point now properly displays the correct 'Online' value" do
      if @@original_status == "Offline (Out of Service)"
        expect(["Offline","Online"]).to include(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text)
      else
        expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text).to eq('Offline (Out of Service)')
      end
    end
  end
end

shared_examples "put in out of service first array in grid profile" do |profile_name|
  describe "Put IN/OUT of Service the first array in the Profile - Access Points grid" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
    end
    it "Go to the 'Access Points' tab" do
      @ui.click('#profile_tab_arrays')
      sleep 1.5
      expect(@browser.url).to include('/#profiles/')
      expect(@browser.url).to include('/aps')
    end
    it "Place a tick for the first array in the grid and verify the proper 'More' options" do
      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(2) .nssg-td-select input + .mac_chk_label')
      sleep 1
      expect(@ui.css('#arrays_grid .push-down .pull-left .bubble .count').text.to_i).to eq(1)
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      expect(@ui.css('#arrays-menu-reboot')).to be_present
      #expect(@ui.css('#arrays.menu.reset')).to exist
      @@original_status = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text
      if @@original_status == "Offline (Out of Service)"
        expect(@ui.css('#arrays-menu-admin-none')).to be_present
      else
        expect(@ui.css('#arrays-menu-admin-offline')).to be_present
      end
    end
    it "Press the 'Take Out of Service' or 'Put in Service' button and refresh the grid" do
      if @@original_status == "Offline (Out of Service)"
        @ui.click('#arrays-menu-admin-none')
      else
        @ui.click('#arrays-menu-admin-offline')
      end
      sleep 3
      @ui.click('.nssg-refresh')
      sleep 1
    end
    it "Verify that the Access Point now properly displays the correct 'Online' value" do
      if @@original_status == "Offline (Out of Service)"
        expect(["Offline","Online"]).to include(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text)
      else
        expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(10) .nssg-td-text span:nth-child(2)').text).to eq('Offline (Out of Service)')
      end
    end
  end
end

shared_examples "put in service all arrays in grid commandcenter" do
  describe "Put 'In Service' all arrays from Command Center grid" do
    it "Go to the Access Points tab of CommandCenter Admin" do
      @ui.click('#header_logo')
      sleep 1
      @ui.css('.globalTitle').wait_until_present
      @ui.click('#msp_tab_arrays')
      sleep 1
      @ui.css('.tabs_container .tab-item-container .commonTitle').wait_until_present
      expect(@ui.css('.tabs_container .tab-item-container .commonTitle span').text).to include("Access Points")
    end
    it "Set the view per page to '1000' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      sleep 1
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "1000")
      sleep 2
    end
    it "Click the 'All Arrays' checkbox" do
      @ui.click('.nssg-table thead tr:nth-child(1) .nssg-th-select input + .mac_chk_label')
      sleep 1
      expect(@ui.css('.xc-grid-selection-bubble .count').text.to_i).to eq(@ui.css('.commonTitle.push-down span').text.to_i)
    end
    it "Open the 'More' menu and press the 'Put In Service' button (if available)" do
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      sleep 1
      if @ui.css('#msp_arrays_admin_none').present?
        @ui.click('#msp_arrays_admin_none')
        sleep 1
      end
    end
    it "Set the view per page to '10' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      sleep 1
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "10")
      sleep 2
    end
  end
end

shared_examples "put in out of service first array in grid commandcenter" do
  describe "Put IN/OUT of Service the first array in the Command Center - Access Points grid" do
    it "Go to the Access Points tab of CommandCenter Admin" do
      @ui.click('#header_logo')
      sleep 1
      @ui.css('.globalTitle').wait_until_present
      @ui.click('#msp_tab_arrays')
      sleep 1
      @ui.css('.tabs_container .tab-item-container .commonTitle').wait_until_present
      expect(@ui.css('.tabs_container .tab-item-container .commonTitle span').text).to include("Access Points")
    end
    it "Place a tick for the first array in the grid and verify the proper 'More' options" do
      @ui.click('.nssg-table tbody tr:nth-child(1) td:nth-child(2) input + .mac_chk_label')
      sleep 1
      expect(@ui.css('.xc-grid-selection-bubble .count').text.to_i).to eq(1)
      more_button = @ui.css('#arrays_more_btn').parent
      expect(more_button).to be_present
      more_button.element(css: ".icon").click
      sleep 1
      expect(more_button.element(css: ".more_menu")).to be_present
      @@original_status = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) .nssg-td-text').text
      if @@original_status == "Out of Service"
        expect(@ui.css('#msp_arrays_admin_none')).to be_present
      else
        expect(@ui.css('#msp_arrays_admin_offline')).to be_present
      end
    end
    it "Press the 'Take Out of Service' or 'Put in Service' button and refresh the grid" do
      if @@original_status == "Out of Service"
        @ui.click('#msp_arrays_admin_none')
      else
        @ui.click('#msp_arrays_admin_offline')
      end
      sleep 3
      @ui.click('.nssg-refresh')
      sleep 1
    end
    it "Verify that the Access Point now properly displays the correct 'Online' value" do
      if @@original_status == "Out of Service"
        expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) .nssg-td-text').text).to eq("")
      else
        expect(@ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(8) .nssg-td-text').text).to eq('Out of Service')
      end
    end
  end
end

shared_examples "assign all available aps to a profile" do |profile_name|
  describe "Assign all the available APs to the profile named '#{profile_name}'" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "Select All APs and move to the profile '#{profile_name}'" do
      @ui.css(".nssg-table thead tr:nth-child(1) th:nth-child(2) .mac_chk_label").click and @ui.css('.moveto_button').wait_until_present
      @ui.click('.moveto_button')
      sleep 1
      items = @ui.css('.move_to_nav .items')
      items.wait_until_present
      item = items.a(:text => profile_name)
      item.wait_until_present
      item.click
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect that the Profile cell properly shows the '#{profile_name}' value" do
      @ui.get(:elements , {css: ".nssg-table tbody tr .hostName div"}).each do |ap_hostname|
        expect(@ui.grid_verify_strig_value_on_specific_line("3", ap_hostname.text, "div", "5", "a", profile_name)).to eq(profile_name)
      end
    end
  end
end

shared_examples "assign first access point to profile" do |profile_name|
  describe "Assign the first Access Point in the My Network - Access Points tab to the profile named #{profile_name}" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "assign an accees point to the #{profile_name} profile" do
      $added_first_access_point_name = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(3) .nssg-td-text").text
      $added_first_access_point_sn = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(4) .nssg-td-text").text
      @ui.grid_tick_on_specific_line("3", $added_first_access_point_name, "a")
      sleep 1
      @ui.click('.moveto_button')
      sleep 1
      items = @ui.css('.move_to_nav .items')
      items.wait_until_present
      item = items.a(:text => profile_name)
      item.wait_until_present
      item.click
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect the Profile cell to have the value #{profile_name}" do
      expect(@ui.grid_verify_strig_value_on_specific_line("3", $added_first_access_point_name, "a", "5", "a", profile_name)).to eq(profile_name)
    end
  end
end

shared_examples "unasign access point based on profile search" do |profile_name|
  describe "Unasign the access point asigned to a specific profile ('#{profile_name}')" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "unasign access point(s) from profile" do
      @ui.grid_tick_on_specific_line("5", profile_name, "a")
      sleep 1
      @ui.click('.moveto_button')
      sleep 1
      @ui.click('#arrays_moveto_00000000-0000-0000-0000-000000000000')
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect the Profile cell to not have any value (be unassigned)" do
      @ui.grid_verify_strig_value_on_specific_line("5", profile_name, "a", "5", "a", "")
      expect($search_failed_booleand).to eq(false)
    end
  end
end

shared_examples "unasign access points from profile" do |profile_name, access_point_name|
  describe "unasign access points from profile" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "unasign access point(s) from profile" do
      @ui.grid_tick_on_specific_line("3", access_point_name, "div")
      sleep 1
      @ui.click('.moveto_button')
      sleep 1
      @ui.click('#arrays_moveto_00000000-0000-0000-0000-000000000000')
      sleep 1
      @ui.confirm_dialog
    end
    it "Expect the Profile cell to not have any value (be unassigned)" do
      expect(@ui.grid_verify_strig_value_on_specific_line("3", access_point_name, "div", "5", "a", "")).to eq("")
    end
  end
end

shared_examples "find accees point by grid position" do |grid_position|
  describe "Test an AP on the My Network area by using it's grid position ('#{grid_position}')" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "Find the necessary HostName and Serial Number AP for the grid position: '#{grid_position}'" do
      $access_point_name = @ui.css(".nssg-table tbody tr:nth-child(#{grid_position}) td:nth-child(3) .nssg-td-text").text
      $access_point_sn = @ui.css(".nssg-table tbody tr:nth-child(#{grid_position}) td:nth-child(4) .nssg-td-text").text
      puts $access_point_name
      puts $access_point_sn
    end
  end
end

shared_examples "perform tests on my network area access point" do |grid_position, location, tag_id|
  context "Find Access Point using it's grid position" do
    it_behaves_like "find accees point by grid position", grid_position
    it_behaves_like "test my network access point", "from_grid_position", "from_grid_position", location, tag_id
  end
end

shared_examples "test my network access point" do |ap_name, access_point_sn, location, tag_id|
  describe "test my network access point" do
    before :all do
      go_to_my_network_arrays_tab
    end
    it "test ap config general" do
      if ap_name == "from_grid_position" and access_point_sn == "from_grid_position"
        ap_name = $access_point_name
        access_point_sn = $access_point_sn
      end
      sleep 1
      @ui.grid_action_on_specific_line("4", ".nssg-td-text", access_point_sn, "click")
      sleep 1
      @ui.click('#arraydetails_tab_general')
      sleep 1
      @ui.set_input_val('#edit_location',location)
      sleep 2
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.click('#arraydetails_save')
      sleep 1

      loc = @ui.get(:text_field, { id: 'edit_location' })
      loc.wait_until_present
      expect(loc.value).to eq(location)

      loc.clear
      @ui.click('#arraydetails_save')
      sleep 1

      @ui.click('#arrays_tag_btn')
      sleep 1
      @ui.set_input_val('#arrays_clients_add_tag_input', tag_id)
      sleep 1
      @ui.click('#general_add_tag_btn')
      sleep 1
      @ui.click('#arrays_tag_btn')
      sleep 1
      @ui.click('#arraydetails_save')
      sleep 1
      @ui.click('.tagControlContainer .delete')
      sleep 1
      @ui.click('#arraydetails_save')
      sleep 1
      @browser.execute_script('$("#suggestion_box").show()')
      @ui.click('#arraydetails_close_btn')
    end

    it "test ap config system" do
      sleep 1
      @ui.grid_action_on_specific_line("3", ".nssg-td-text", ap_name, "click")
      sleep 1

      $status_up = @ui.css('.slideout_title .online_status.UP')

      if $status_up.exists?
          @ui.click('#arraydetails_tab_system')
          sleep 1
          ad = @ui.css('.arraydetails_system')
          ad.wait_until_present

          block = ad.div(:css => '.info_block', :index => 1)
          block.wait_until_present

          serial = block.div(:css => '.field_wrap').span(:css => '.field_cell', :index => 2)
          serial.wait_until_present

          expect(serial.text).to eq(access_point_sn)
      else
        puts "Access Point is offline !"
      end

      @ui.click('#arraydetails_close_btn')
    end

    it "test ap config radios" do
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
      sleep 1

      @ui.click('#arraydetails_tab_radios')
      sleep 1


      if $status_up.exists?
        @ui.click('.radios_list .radio_item_container .radio_item')
        sleep 1
        @ui.set_input_val('.radios_list .radio_item_container .radio_item .general input', 'DESCRIPTION')
        sleep 1
        @ui.click('.arraydetails_header .subtitle')

        @browser.execute_script('$("#suggestion_box").hide()')
        @ui.click('#arraydetails_save')
        sleep 1

        desc = @ui.css('.radios_list .radio_item_container .radio_item .general .description')
        desc.wait_until_present

        expect(desc.text).to eq('DESCRIPTION')

        @ui.click('.radios_list .radio_item_container .radio_item')
        sleep 1
        @ui.set_input_val('.radios_list .radio_item_container .radio_item .general input', '')
        sleep 1
        @ui.click('.arraydetails_header .subtitle')

        @ui.click('#arraydetails_save')
        @browser.execute_script('$("#suggestion_box").show()')
        sleep 1
      else
        puts "Access Point is offline !"
      end

      @ui.click('#arraydetails_close_btn')
    end

    it "test ap config cli" do
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
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
      else
        puts "Access Point is offline !"
      end

      @ui.click('#arraydetails_close_btn')
    end
  end
end

shared_examples "run cli command on certain ap" do |access_point_sn, ap_name, run_command, expected_value|
  describe "Run the Command Line Interface command '#{run_command}' on the AP '#{access_point_sn}'" do
    it "Run a CLI command on a certain AP" do
      go_to_my_network_arrays_tab
      sleep 3
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
      sleep 1
      status_up = @ui.css('.slideout_title .online_status.UP')
      sleep 2
      @ui.click('#arraydetails_tab_cli')
      sleep 1
      if status_up.exists?
          @ui.click('.array-details-cli-agreement-btn')
          cli = @ui.get(:textarea, {id: 'array-details-cli-commands-input'})
          cli.wait_until_present
          @ui.set_textarea_val("#array-details-cli-commands-input", run_command)
          sleep 2
          @ui.click('#array-details-cli-submit')
          sleep 10
          resp = @ui.get(:textarea, { css: '.array-details-cli-results-response' })
          resp.wait_until_present
          expect(resp.value).to include(expected_value)
      else
        ap_offline == true
        puts "Access Point is offline !"
        expect(ap_offline).to eq(false)
      end

      @ui.click('#arraydetails_close_btn')
    end
  end
end

shared_examples "verify readonly on my network area access point" do |grid_position|
  context "Find Access Point using it's grid position" do
    it_behaves_like "find accees point by grid position", grid_position
    it_behaves_like "test my network access point read only", "from_grid_position", "from_grid_position"
  end
end

shared_examples "test my network access point read only" do |ap_name, access_point_sn|
  describe "Open the array named #{ap_name} and test that it is read only (location: my network access points grid)" do
    before :all do
      go_to_my_network_arrays_tab
    end

    it "Open the slideout for the AP and verify that the ap config general page is disabled except from the 'Profile' dropdown list" do
      if ap_name == "from_grid_position" and access_point_sn == "from_grid_position"
        ap_name = $access_point_name
        access_point_sn = $access_point_sn
      end
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
      sleep 1

      @ui.click('#arraydetails_tab_general')
      sleep 1

      loc = @ui.get(:text_field, { id: 'edit_location' })
      expect(loc.enabled?).to eq(false)

      name = @ui.get(:text_field, { id: 'edit_name' })
      expect(name.enabled?).to eq(false)

      sleep 1
      @ui.click('#arraydetails_close_btn')
    end

    it "Open the slideout for the AP and verify that the AP config radios page is disabled but has all the proper features present" do
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
      sleep 1

      @ui.click('#arraydetails_tab_radios')
      sleep 1

      $status_up = @ui.css('.slideout_title .online_status.UP')

      if $status_up.exists?
          expect(@ui.css('.readonly_indicator')).to be_visible
          expect(@ui.css('.readonly_indicator').text).to eq('This Access Point is assigned to a read-only profile. You cannot edit the radio settings.')
          expect(@ui.css('.radios_list div:nth-child(1) .radio_item')).to be_visible
          expect(@ui.css('.radios_list div:nth-child(1) .radio_item')).to be_visible
      end

      @ui.click('#arraydetails_close_btn')
    end
    it "Open the slideout for the AP and verify that the 'Factory Reset' function is disabled" do
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", access_point_sn, "invoke")
      sleep 1

      @ui.click('.ko_slideout_content .top .buttons.align_right .lightgrey.button.drop_menu')

      factory_reset_path = @ui.css('.ko_slideout_content .top .buttons.align_right .lightgrey.button.drop_menu .more_menu.drop_menu_nav.active .items a:nth-child(2)')
      factory_reset_class =  factory_reset_path.attribute_value("class")
      expect(factory_reset_class).to include("disabled")

      @ui.click('#arraydetails_close_btn')
    end
  end
end

shared_examples "test my network access point list" do |ap_name, column_name|
  describe "test my network access point list" do
    before :all do
     sleep 1
    end
    it "Go to the Mynetwork / Access Points tab" do
       # make sure it goes to the my network
      @ui.click('#header_mynetwork_link')
      sleep 0.5
      @ui.click('#mynetwork_tab_arrays')
      sleep 0.5
      @ui.get_grid_header_count
    end

    it "Add the column named '#{column_name}' to the grid" do
      cp = @ui.css('.columnPickerIcon').parent
      cp.wait_until_present
      cp.click
      sleep 1

      list = @ui.css('.column_selector_modal .lhs ul')
      list.wait_until_present

      col = list.li(:text => column_name)
      col.wait_until_present
      col.click
      sleep 1

      @ui.click('#column_selector_modal_move_btn')
      sleep 1
      @ui.click('#column_selector_modal_save_btn')
      sleep 1

      cell = @ui.css('.nssg-table thead tr th:nth-child(12)')
      cell.wait_until_present
      expect(cell.text).to eq("Model")
    end

    it "Remove the column named #{column_name} from the grid" do
      cp = @ui.css('.columnPickerIcon').parent
      cp.wait_until_present
      cp.click
      sleep 1

      list = @ui.css('.column_selector_modal .rhs ul')
      list.wait_until_present

      col = list.li(:text => column_name)
      col.wait_until_present
      col.click
      sleep 1

      @ui.click('#column_selector_modal_remove_btn')
      sleep 1
      @ui.click('#column_selector_modal_save_btn')
      sleep 1

      tr = @ui.css('.nssg-table thead tr')
      tr.wait_until_present
      expect(tr.ths.length).to eq(11)
    end

    it "Seach for the array that has the name: '#{ap_name}' ensure that lines are displayed in the grid" do
        @ui.set_input_val('.pull-right .xc-search input', ap_name)
        sleep 1
        grid = @ui.css('.nssg-table')
        grid.wait_until_present
        expect(grid.trs.length > 1).to eq(true)
        cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
        cell.wait_until_present
        expect(cell.title).to include(ap_name)
        sleep 1
        @ui.click('.pull-right .xc-search .btn-clear')
    end
    it "Verify that clicking on a column header sorts the grid" do
      cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
      cell.wait_until_present
      first_cell = cell.title

      @ui.click('.nssg-table thead th:nth-child(3)')
      sleep 1

      cell = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) a')
      cell.wait_until_present
      expect(cell.title).to_not eq(first_cell)

      @ui.click('.nssg-table thead th:nth-child(3)')
    end
  end
end

shared_examples "verify sorting" do
  describe "Verify the sorting features on the Access Points tab" do
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Access Point Hostname"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Serial Number"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Profile"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "IP Address"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Location"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Status"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Online"
    it_behaves_like "verify descending ascending sorting firmware", "Access Points - My Network", "Expiration Date"
  end
end

shared_examples "test exports" do |access_point_sn, radio_not_included_value|
  describe "Test the exporting of 'All Radio Configurations' and 'All Access Points'" do
     it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Choose to export 'All Access Points' into .csv file and verify that the file contains the #{access_point_sn} entries" do
      sleep 4
      @ui.click('#mn-cl-export-btn-mnu')
      sleep 2
      @ui.click('.drop_menu_nav .items a:nth-child(1)')
      sleep 3
      fname = @download + "/AccessPoints-All-" + (Date.today.to_s) + ".csv"
      puts fname
      sleep 1
      file = File.open(fname, "r")
      sleep 1
      data = file.read
      sleep 1
      file.close
      sleep 1
      puts data
      expect(data.include?(access_point_sn)).to eq(true)
      sleep 1
      File.delete(@download + "/AccessPoints-All-" + (Date.today.to_s) + ".csv")
    end
    it "Choose to export 'All Radio Configurations' into .csv file and verify the file contains the Canada radios and does not contain the #{access_point_sn} entries" do
      sleep 4
      @ui.click('#mn-cl-export-btn-mnu')
      sleep 2
      @ui.click('.drop_menu_nav .items a:nth-child(2)')
      sleep 3
      fname = @download + "/Radios-All-" + (Date.today.to_s) + ".csv"
      puts fname
      sleep 1
      file = File.open(fname, "r")
      sleep 1
      data = file.read
      sleep 1
      file.close
      sleep 1
      puts data
      expect(data.include?(radio_not_included_value)).to eq(false)
      expect(data.include?(access_point_sn)).to eq(true)
      sleep 1
      File.delete(@download + "/Radios-All-" + (Date.today.to_s) + ".csv")
    end
  end
end

def verify_proper_controls_exists_when_grid_entry_is_ticked
  expect(@ui.css('#arrays_grid .push-down .pull-left')).to be_visible
  expect(@ui.css('#mynetwork_arrays_moveto_btn')).to be_present
  expect(@ui.css('.groups_button.lightgrey.drop_menu')).to be_present
  expect(@ui.css('xc-arrays-menu-optimize-arrays .optimize_button.lightgrey.drop_menu')).to be_present
  expect(@ui.css('#arrays_more_btn')).to exist
  expect(@ui.css('#arrays_more_btn')).to be_visible
end

def press_optimize_button_and_verify_dropdown_list_content
  @ui.click('xc-arrays-menu-optimize-arrays .optimize_button.lightgrey.drop_menu span')
  sleep 1
  expect(@ui.css('.opt_menu.drop_menu_nav.active')).to exist
  expect(@ui.css('#arrays_optimization_chk_channels')).to exist
  expect(@ui.css('#arrays_optimization_chk_channels').attribute_value("value")).to eq("channels")
  expect(@ui.css('#arrays_optimization_chk_power')).to exist
  expect(@ui.css('#arrays_optimization_chk_power').attribute_value("value")).to eq("power")
  expect(@ui.css('#arrays_optimization_chk_radios')).to exist
  expect(@ui.css('#arrays_optimization_chk_radios').attribute_value("value")).to eq("radios")
  expect(@ui.css('#mynetwork_arrays_optimize')).to be_present
end

def verify_optimize_prompt_modal_contents(what_optimization)
  @ui.css('.optimizeprompt.modal').wait_until_present
  expect(@ui.css('.optimizeprompt.modal')).to be_visible
  expect(@ui.css('.optimizeprompt .commonTitle').text).to eq("Optimize Access Point(s)")
  expect(@ui.css('.optimizeprompt .content_body .message').text).to eq('Would you like to optimize the selected Access Point(s)?')
  expect(@ui.css('.optimizeprompt .content_body .warning').text).to eq('WARNING - Clients will experience brief interruptions in Wi-Fi service over the next 5 minutes.')
  if what_optimization == "Power"
      expect(@ui.css('#optimizeprompt-showadvanced')).to be_present
      expect(@ui.css('.optimizeprompt-advanced-content')).to exist
      if @ui.css("#optimizeprompt-showadvanced").text == "Hide Advanced"
        @ui.click('#optimizeprompt-showadvanced')
        sleep 0.5
      end
      expect(@ui.css('.optimizeprompt-advanced-content')).not_to be_visible
      sleep 0.5
      @ui.click('#optimizeprompt-showadvanced')
      sleep 0.5
      expect(@ui.css('.optimizeprompt-advanced-content .message').text).to eq("These settings apply to Power Optimization only.")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(2)').text).to eq("Minimum transmit power that the AP can assign to a radio when adjusting automatic cell sizes.")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(3)').attribute_value("class")).to eq("xc-field")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(3) label').text).to eq("Minimum Power:")
      expect(@ui.get(:input, { css: '.optimizeprompt-advanced-content div:nth-child(3) #optimizeprompt-minpower-range'}).value).to eq("10")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(4)').text).to eq("Cell overlap that will be allowed when the AP is determining automatic cell sizes. For maximum overlap, the power is adjusted such that neighboring APs that hear each other best will hear each other at the maximum power level. For minimum overlap, APs will hear each other at minimum power level.")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(5)').attribute_value("class")).to eq("xc-field")
      expect(@ui.css('.optimizeprompt-advanced-content div:nth-child(5) label').text).to eq("Cell Size Overlap:")
      expect(@ui.get(:input, { css: '.optimizeprompt-advanced-content div:nth-child(5) #optimizeprompt-celloverlap-range'}).value).to eq("50")
  end
end

def tick_certain_optimizations_option_and_press_the_optimize_button(what_optimization)
  if what_optimization == "Channel"
    @ui.click('.opt_menu.drop_menu_nav.active li:first-child label')
  elsif what_optimization == "Power"
    @ui.click('.opt_menu.drop_menu_nav.active li:nth-child(2) label')
  elsif what_optimization == "Band"
    @ui.click('.opt_menu.drop_menu_nav.active li:nth-child(3) label')
  end
  sleep 1
  @ui.click('#mynetwork_arrays_optimize')
end

def submit_the_optimizations_and_verify_the_optimizations_message(what_optimization)
  if ["Channel", "Power", "Band"].include? what_optimization
    @ui.css('#optimize_prompt_submit').click
    sleep 0.2
    if @ui.css('.optimizeprompt').exists? and @ui.css('.optimizeprompt').visible?
      sleep 0.5
       @ui.css('#optimize_prompt_submit').click
     end
    @ui.css('.msgbody').wait_until_present
    expect(@ui.css('.msgbody div').text).to eq('Optimizations will complete in 5 minutes. Please do not make further changes to radio settings during this time.')
  elsif what_optimization == "Read-Only"
    @ui.css('#optimize_prompt_submit').click
    @ui.css('.error').wait_until_present and expect(@ui.css('.error .title').text).to eq("403 Forbidden") and expect(@ui.css('.error .msgbody div').text).to eq("You don’t have permission to perform this operation")
  end
end

def find_certain_ap_in_the_grid_and_set_the_monitor_option_to_on_off(ap_sn, on_off)
  if ap_sn != nil
    @ui.grid_action_on_specific_line($header_count, "a", ap_sn, "invoke")
    sleep 1
    @ui.click('#arraydetails_tab_radios')
    @browser.execute_script('$("#suggestion_box").hide()')
    sleep 1
    @ui.click('#arraydetails_togglefull')
    sleep 1
    @ui.click('.arraydetails_radios .commonAdvanced')
    sleep 0.5
    @ui.click('.arraydetails_header .subtitle')
    sleep 0.5
    @ui.css('.radios_list .radio_item_container .radio_item .general .iapName').hover
    sleep 0.5
    @ui.click('.radios_list .radio_item_container .editIcon .icon')
    sleep 0.5
    @ui.click('.radios_list .radio_item_container .radio_item .radio_checkbox .mac_chk_label')
    sleep 0.5
    @ui.click('.radios_list .radio_item_container .radio_item')
    @ui.click('.radios_list .radio_item_container .radio_item .information div:nth-child(5) .ko_dropdownlist_button .arrow')
    sleep 0.5
    if on_off == "off"
      @ui.css(".monitorDdl ul li:nth-child(1)").click
    elsif on_off == "on (dedicated)"
      @ui.css(".monitorDdl ul li:nth-child(2)").click
    elsif on_off == "on (timeshare)"
      @ui.css(".monitorDdl ul li:nth-child(3)").click
    end
    sleep 0.5
    @ui.click('#arraydetails_save')
    sleep 3
    monitor1 = @ui.css('.radios_list div:first-child .radio_item .information .monitor')
    if on_off == "off"
      expect(monitor1.text).to eq("")
    elsif on_off == "on (dedicated)"
      expect(monitor1.text).to eq("Dedicated Monitor")
    elsif on_off == "on (timeshare)"
      expect(monitor1.text).to eq("Timeshare Monitor")
    end
    sleep 0.5
    @ui.click('#arraydetails_close_btn')
  end
end

def verify_all_features_of_the_run_optimize_modal
  expect(@ui.css('.optimizeprompt.modal.autochannel .commonTitle').text).to eq('Run Optimize')
  expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .message').text).to eq('To achieve optimal results when running auto-power, Monitor needs to be enabled on devices in the vicinity of the selected APs.')
  expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .arrays_text').text).to eq('The following devices do not have Monitor enabled:')
  expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .action_text').text).to eq('How would you like to proceed?')
  expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .desc').text).to eq('Turn on Timeshare Monitor on the above devices. To complete the auto-power operation, you will need to run auto-power in 4 hours. No optimizations will run at this time')
end

shared_examples "ap monitor configurations" do |ap_sn, monitor_state|
  describe "Verifies that the configurations on AP monitors can be performed" do
    it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Find an #{ap_sn} AP and set the monitor state to '#{monitor_state}'" do
      css_value = @ui.grid_verify_strig_value_on_specific_line_by_column_name("Serial Number",ap_sn,"a","4","a",ap_sn)
      expect(css_value).not_to eq(nil)
      find_certain_ap_in_the_grid_and_set_the_monitor_option_to_on_off(ap_sn, monitor_state)
    end
  end
end

shared_examples "verify optimizations channel" do |ap_hostname, ap_sn|
  describe "Verifies that the optimizations on AP's can be performed" do
    it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Place a tick for the Access Point line with the serial number of '#{ap_sn}'" do
      css_path = @ui.grid_tick_on_specific_line("4", ap_sn, "a")
      expect(css_path).not_to eq(nil)
    end
    it "Expect that the 'ColumnPicker', 'Move To', 'Optimize' and 'More' buttons are properly displayed" do
      verify_proper_controls_exists_when_grid_entry_is_ticked
    end
    it "Press the 'Optimize' button and ensure the dropdown list is properly displayed and has the options: 'Channel' , 'Power' and 'Band' " do
      press_optimize_button_and_verify_dropdown_list_content
    end
    it "Place a tick in the 'Channel' check box and press the 'Optimize' button " do
      tick_certain_optimizations_option_and_press_the_optimize_button("Channel")
    end
    it "Expect the 'Optimize Access Point(s)' modal to be displayed" do
      verify_optimize_prompt_modal_contents("Channel")
    end
    it "Press the 'Optimize Now' button and verify that the proper message is displayed" do
      submit_the_optimizations_and_verify_the_optimizations_message("Channel")
    end
  end
end

shared_examples "verify optimizations band" do |ap_hostname, ap_sn|
  describe "Verifies that the optimizations on AP's can be performed" do
    it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Place a tick for the Access Point line with the serial number of '#{ap_sn}'" do
      css_path = @ui.grid_tick_on_specific_line("4", ap_sn, "a")
      expect(css_path).not_to eq(nil)
      verify_proper_controls_exists_when_grid_entry_is_ticked
    end
    it "Press the 'Optimize' button and place a tick in the 'Band' checkbox then press the 'Optimize' button" do
      press_optimize_button_and_verify_dropdown_list_content
      sleep 1
      tick_certain_optimizations_option_and_press_the_optimize_button("Band")
    end
    it "Expect the 'Optimize Access Point(s)' modal to be displayed" do
      verify_optimize_prompt_modal_contents("Band")
    end
    it "Press the 'Optimize Now' button and verify that the proper message is displayed" do
      submit_the_optimizations_and_verify_the_optimizations_message("Band")
    end
  end
end

shared_examples "verify optimizations power" do |ap_hostname, ap_sn|
  describe "Verifies that the optimizations on AP's can be performed" do
    it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Place a tick for the Access Point line with the serial number of '#{ap_sn}'" do
      css_path = @ui.grid_tick_on_specific_line("4", ap_sn, "a")
      expect(css_path).not_to eq(nil)
      verify_proper_controls_exists_when_grid_entry_is_ticked
    end
    it "Press the 'Optimize' button and place a tick in the 'Power' checkbox then press the 'Optimize' button" do
      press_optimize_button_and_verify_dropdown_list_content
      sleep 1
      tick_certain_optimizations_option_and_press_the_optimize_button("Power")
    end
    it "Expect the 'Optimize Access Point(s)' modal to be displayed" do
      verify_optimize_prompt_modal_contents("Power")
    end
    it "Press the 'Optimize Now' button and verify that the proper message is displayed" do
      submit_the_optimizations_and_verify_the_optimizations_message("Power")
    end
  end
end

shared_examples "verify optimizations power monitor" do |ap_hostname, ap_sn|
  describe "Verifies that the optimizations on AP's can be performed" do
    it "Ensure that you are on the Access Points tab from My Network" do
      go_to_my_network_arrays_tab
    end
    it "Search trough the Access Points grid and verify that there is at least one AP ONLINE then open the Online AP's Radio Configurations are set the Monitor option to 'OFF' (if not already turned off)" do
      css_value = @ui.grid_verify_strig_value_on_specific_line_by_column_name("Online","Online","div span:nth-child(2)","10","div span:nth-child(2)","Online")
      expect(css_value).not_to eq(nil)
      find_certain_ap_in_the_grid_and_set_the_monitor_option_to_on_off(css_value, "off")
    end
    it "Press the refresh grid button several times and wait until the AP is ACTIVATED" do
      @ui.get_cell_text_on_ap_grid(ap_hostname,"Status","Activated", false)
      @ui.grid_tick_on_specific_line("4", ap_sn, "div")
    end
    it "Press the 'Optimize' button and place a tick in the 'Power' checkbox then press the 'Optimize' button" do
      press_optimize_button_and_verify_dropdown_list_content
      sleep 1
      tick_certain_optimizations_option_and_press_the_optimize_button("Power")
    end
    it "Expect the 'Optimize Access Point(s)' modal to be displayed" do
      verify_optimize_prompt_modal_contents("Power")
    end
    it "Press the 'Optimize Now' button and verify that 'Run Optimize' modal is displayed and all the features are correct" do
      @ui.css('#optimize_prompt_submit').click
      sleep 0.5
      if @ui.css(@ui.css('.optimizeprompt.modal.autochannel .commonTitle').text).exists?
        verify_all_features_of_the_run_optimize_modal
      end
    end
    it "Change the switch to 'Complete the operation(s)' and verify the description text" do
      if @ui.css(@ui.css('.optimizeprompt.modal.autochannel .commonTitle').text).exists?
        @ui.click('.optimizeprompt.modal.autochannel .content_body .optimize_switch div label')
        #@ui.css('optimizeprompt.modal.autochannel .content_body .optimize_switch div label div:nth-child') #
        sleep 1
        expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .desc').text).to eq('Complete the requested operation(s) without turning on Monitor.')
      end
    end
    it "Press the 'Cancel' button and verify that no message related to Optimizations started is displayed" do
      if @ui.css(@ui.css('.optimizeprompt.modal.autochannel .commonTitle').text).exists?
        @ui.click('#optimize_prompt_cancel')
        sleep 0.5
        expect(@ui.css('.msgbody div')).not_to exist
      end
    end
    it "Go back to the 'Run Optimize' modal" do
     press_optimize_button_and_verify_dropdown_list_content
     sleep 1
     tick_certain_optimizations_option_and_press_the_optimize_button("Power")
     sleep 1
     @ui.css('#optimize_prompt_submit').click
     sleep 1
     verify_all_features_of_the_run_optimize_modal
    end
    it "Change the switch to 'Complete the operation(s)', press the 'OK' button and verify that the proper message is displayed" do
      @ui.click('.optimizeprompt.modal.autochannel .content_body .optimize_switch div label')
      sleep 1
      expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .desc').text).to eq('Complete the requested operation(s) without turning on Monitor.')
      sleep 1
      submit_the_optimizations_and_verify_the_optimizations_message("Power")
    end
    it "Refresh the browser and wait until the AP has the Status ACTIVATED" do
      @ui.get_cell_text_on_ap_grid(ap_hostname,"Status","Activated", false)
    end
     it "Search trough the Access Points grid and verify that there is at least one AP ONLINE then open the Online AP's Radio Configurations are set the Monitor option to 'OFF' (if not already turned off)" do
      css_value = @ui.grid_verify_strig_value_on_specific_line_by_column_name("Online","Online","div span:nth-child(2)","10","div span:nth-child(2)","Online")
      expect(css_value).not_to eq(nil)
      find_certain_ap_in_the_grid_and_set_the_monitor_option_to_on_off(css_value, "off")
    end
    it "Press the refresh grid button several times and wait until the AP is ACTIVATED" do
      @ui.get_cell_text_on_ap_grid(ap_hostname,"Status","Activated", false)
      @ui.grid_tick_on_specific_line("4", ap_sn, "div")
    end
    it "Go back to the 'Run Optimize' modal" do
      if @ui.css('#profile_arrays_details_slideout').visible? and @ui.css('#arraydetails_close_btn').visible?
        @ui.click('#arraydetails_close_btn')
      end
      press_optimize_button_and_verify_dropdown_list_content
      sleep 1
      tick_certain_optimizations_option_and_press_the_optimize_button("Power")
      sleep 1
      verify_all_features_of_the_run_optimize_modal
      sleep 1
      @ui.css('#optimize_prompt_submit').click
      sleep 1
      expect(@ui.css('.optimizeprompt.modal.autochannel .commonTitle').text).to eq('Run Optimize')
    end
    it "Leave the switch to 'Turn on Timeshare Monitor', press the 'OK' button and verify that the proper message is displayed" do
      expect(@ui.css('.optimizeprompt.modal.autochannel .content_body .desc').text).to eq('Turn on Timeshare Monitor on the above devices. To complete the auto-power operation, you will need to run auto-power in 4 hours. No optimizations will run at this time')
      sleep 0.5
      @ui.click('#optimize_prompt_submit')
      sleep 0.5
      expect(@ui.css('.msgbody div').text).to eq('Timeshare monitor has been turned on for all devices. Please re-run auto-power in 4 hours')
    end
    it "Refresh the browser and wait around 60 seconds" do
      sleep 10
      (0..8).each do
        @ui.css('#arrays_grid .push-down .pull-right .nssg-paging .nssg-refresh').click
        sleep 3
      end
      (0..4).each do
        @browser.refresh
        sleep 5
      end
    end
    it "Search trough the Access Points grid and verify that there is at least one AP ONLINE" do
      @ui.grid_verify_strig_value_on_specific_line_by_column_name("Online","Online","div span:nth-child(2)","10","div span:nth-child(2)","Online")
      expect($search_failed_booleand).to eq(nil)
    end
    it "Open the Online AP's Radio Configurations and verify that the Monitor option is set to 'Timeshare Monitor'" do
      if ($search_failed_booleand == nil)
        @ui.grid_action_on_specific_line($header_count, "div span:nth-child(2)", "Online", "invoke")
        sleep 1
        @ui.click('#arraydetails_tab_radios')
        @browser.execute_script('$("#suggestion_box").hide()')
        sleep 1
        @ui.click('#arraydetails_togglefull')
        sleep 1
        @ui.click('.arraydetails_radios .commonAdvanced')
        sleep 0.5
        monitor1 = @ui.css('.radios_list div:first-child .radio_item .information .monitor')
        expect(monitor1.text).to eq("Timeshare Monitor")
        sleep 0.5
        @ui.click('#arraydetails_close_btn')
      else
        expect($search_failed_booleand).to eq(nil)
      end
    end
  end
end

shared_examples "verify grid column" do |view_number, location, ap_host_name, which_column, icon_class_name, what_text, second_icon_class_name, info_message| #, greybox_exists, info_message_greybox|
  describe "Verifies the grid column entry '#{ap_host_name}' from the location '#{location}' has the proper icon, text and info tooltip" do
    it "Go to the #{location} tab" do
      case location
      when "My Network / Access Points"
        if (@browser.url.include?('#mynetwork/aps'))
          puts "already on my network / AP tab"
        else
          @ui.click('#header_mynetwork_link')
          sleep 1
          @ui.click('#mynetwork_tab_arrays')
          sleep 1
          expect(@browser.url).to include('#mynetwork/aps')
        end
      when "Profile / Access Points"

      when "Support Management / Access Points"
        if (@browser.url.include?('#backoffice/arrays'))
          puts "already on support management / Access Points"
        else
          @ui.click('#header_nav_user')
          sleep 0.5
          @ui.click('#header_backoffice_link')
          sleep 1
          @ui.click('#backoffice_tab_arrays')
          sleep 1
          expect(@browser.url).to include('#backoffice/arrays')
        end
      when "Support Management / Customers / Browsing Tenant: 1-Macadamian Child XR-620-Auto"
        if (@browser.url.include?('#backoffice/customers/'))
          puts "already on support management / Access Points"
        else
          @ui.click('#header_nav_user')
          sleep 0.5
          @ui.click('#header_backoffice_link')
          sleep 1
          @ui.click('#backoffice_tab_customers')
          sleep 5
          @ui.set_input_val("#backoffice-customers .xc-search input", "1-Macadamian Child XR-620-Auto")
          sleep 3
          @ui.grid_click_on_specific_line("3", "1-Macadamian Child XR-620-Auto", "a")
          sleep 1
          expect(@browser.url).to include('#backoffice/customers/')
        end
      when "Support Management / Customers / Browsing Tenant: 1-Macadamian Child - Self Owned"
          @ui.click('#header_nav_user')
          sleep 0.5
          @ui.click('#header_backoffice_link')
          sleep 1
          @ui.click('#backoffice_tab_customers')
          sleep 5
          @ui.set_input_val("#backoffice-customers .xc-search input", "1-Macadamian Child - Self Owned")
          sleep 3
          @ui.grid_click_on_specific_line("3", "1-Macadamian Child - Self Owned", "a")
          sleep 1
          expect(@browser.url).to include('#backoffice/customers/')
      end
    end
    it "Set the view to #{view_number} items per page" do
       @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", view_number)
    end
    it "Find the line with the #{ap_host_name} in the grid" do
        if (location == "Support Management / Customers / Browsing Tenant: 1-Macadamian Child XR-620-Auto") or (location == "Support Management / Customers / Browsing Tenant: 1-Macadamian Child - Self Owned")
          puts @ui.grid_verify_text_and_icons("3", "div", ap_host_name, which_column, "div", icon_class_name, second_icon_class_name)
        else
          puts @ui.grid_verify_text_and_icons("4", "div", ap_host_name, which_column, "div", icon_class_name, second_icon_class_name)
        end
        expect($verify_text_entry).to eq(ap_host_name)
     end
     it "Expect the icon to be '#{icon_class_name}' " do
       expect($icon_span).to exist
     end
     it "Expect the text to be '#{what_text}'" do
       expect($text_span.text).to eq(what_text)
     end
     it "Expect the info icon to be visible" do
        if (second_icon_class_name == "")
          puts "No info icon visible on this column ..."
          $info_bool = false
        else
         expect($info_span).to be_visible
        end
    end
    it "Open the information tooltip" do
      if ($info_bool == false)
        puts "The tool tip cannot be showed due to the fact that the info icon does not exist."
      else
        $info_span.hover
        sleep 0.5
      end
    end
    it "Verify that the text displayed is '#{info_message}' " do
      if ($info_bool == false)
        puts "The tool tip message cannot be verified due to the fact that the info icon does not exist."
      else
        expect(@ui.css('#ko_tooltip .status_tooltip div:nth-child(2) div .subtitle').text).to eq(info_message)
      end
    end
    #it "Does the tooltip greybox exist? #{greybox_exists} , if true -> Verify that the text displayed in the greybox is #{info_message_greybox}" do
    #  if (greybox_exists == true)
    #    expect(@ui.css('#ko_tooltip .status_tooltip div:nth-child(2) div div:nth-child(2)').text).to eq(info_message_greybox)
    #  else
    #    puts "The tooltip greybox does not exist."
    #  end
    #end
  end
end

shared_examples "verify my network all access points tab general features" do
  describe "Verify the general features of the 'All Access Points' tab on the 'My Network' area" do
    it "Go to the 'Access Points' tab" do
      go_to_my_network_arrays_tab
    end
    it "Verify the common title, the subtitle and available controls" do
      expect(@ui.css('#mynetwork_general_container .arrays_tab .commonTitle').text).to eq('All Access Points')
      expect(@ui.css('#mynetwork_general_container .arrays_tab .commonSubtitle').text).to eq('Manage your Access Points by editing them and assigning them to profiles.')
      expect(@ui.css('#mn-cl-export-btn-mnu')).to be_visible
      expect(@ui.css('#arrays_grid')).to be_visible
      expect(@ui.css('#mynetwork_arrays_grid_cp')).to be_visible
      expect(@ui.css('#arrays_grid .push-down .pull-right .clearfix search')).to be_visible
      expect(@ui.css('#arrays_grid .push-down .pull-right .nssg-paging .nssg-paging-selector-container'))
      expect(@ui.css('#arrays_grid .push-down .pull-right .nssg-paging .nssg-paging-count'))
      expect(@ui.css('#arrays_grid .push-down .pull-right .nssg-paging .nssg-paging-controls'))
      expect(@ui.css('#arrays_grid .push-down .pull-right .nssg-paging .nssg-refresh'))
    end
    it "Verify that the 'Default Columns' are: 'Access Points Hostname', 'Serial Number', 'Profile', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
      @ui.click('#mynetwork_arrays_grid_cp')
      sleep 1
      expect(@ui.css('#mynetwork_arrays_grid_cp_modal')).to be_visible
      sleep 1
      @ui.click('#column_selector_restore_defaults')
      sleep 1
      selected_items_list = @ui.css('#rhs_selector ul')
      list_length = selected_items_list.lis.length
      expect(list_length).to eq(9)
      column_names = ["Access Point Hostname (required)", "Serial Number", "Profile", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
        begin
          list_length-=1
          li = selected_items_list.lis.select{|li| li.visible?}[list_length]
          column_name = column_names[list_length]
          puts li.text + " - should equal - " + column_name
          expect(li.text).to eq(column_name)
        end while (list_length > 0)
    end
    it "Close the 'Select Columns' modal and verify that the grid has the following columns: 'Access Points Hostname', 'Serial Number', 'Profile', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
      @ui.click('#column_selector_modal_save_btn')
      sleep 2
      @ui.click('.nssg-refresh')
      sleep 1
      column_names = ["Check Box", "Access Point Hostname", "Serial Number", "Profile", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
      verify_existing_columns_names(column_names, 2)
    end
  end
end

shared_examples "verify my network all access points tab general features on new domain" do
  describe "Verify the general features of the 'All Access Points' tab on the 'My Network' area" do
    it "Go to the 'Access Points' tab" do
      go_to_my_network_arrays_tab
    end
    it "Verify the common title, the subtitle and available controls" do
      expect(@ui.css('#mynetwork_general_container .arrays_tab .commonTitle').text).to eq('All Access Points')
      expect(@ui.css('#mynetwork_general_container .arrays_tab .commonSubtitle').text).to eq('Manage your Access Points by editing them and assigning them to profiles.')
      expect(@ui.css('#arrays_grid')).to be_visible
      expect(@ui.css('#mynetwork_arrays_grid_cp')).to be_visible
      if @ui.css('#arrays_grid tbody').trs.length > 0
        expect(@ui.css('#arrays_grid .push-down .pull-right .clearfix search')).to be_visible
      else
        expect(@ui.css('#arrays_grid .push-down .pull-right .clearfix search')).not_to be_visible
      end
    end
    it "Verify that the grid has the following columns: 'Access Points Hostname', 'Serial Number', 'Profile', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
      column_names = ["Check Box", "Access Point Hostname", "Serial Number", "Profile", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
      verify_existing_columns_names(column_names, 2)
    end
  end
end

shared_examples "verify my network all access points tab general features on new profile" do |profile_name, steelconnect|
  describe "Verify the general features of the 'All Access Points' tab on the 'PROFILE' area" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
    end
    it "Go to the 'Access Points' tab" do
      @ui.click('#profile_tab_arrays')
      sleep 1.5
      expect(@browser.url).to include('/#profiles/')
      expect(@browser.url).to include('/aps')
    end
    it "Verify the common title, the subtitle and available controls" do
      expect(@ui.css('#profile_arrays .commonTitle').text).to eq('All Access Points')
      expect(@ui.css('#profile_arrays .commonSubtitle').text).to eq('Manage your Access Points by editing them and assigning them to profiles.')
      if steelconnect == true
        expect(@ui.css('#profile_array_add_btn')).not_to be_visible
      else
        expect(@ui.css('#profile_array_add_btn')).to be_visible
      end
      expect(@ui.css('#arrays_grid')).to be_visible
      expect(@ui.css('#profile_arrays_grid_cp')).to be_visible
      if @ui.css('#arrays_grid tbody').trs.length > 0
        expect(@ui.css('#arrays_grid .push-down .pull-right .clearfix search')).to be_visible
      else
        expect(@ui.css('#arrays_grid .push-down .pull-right .clearfix search')).not_to be_visible
      end
    end
    if steelconnect == true
      it "Verify that the grid has the following columns: 'Access Points Hostname', 'Serial Number', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
        column_names = ["Check Box", "Access Point Hostname", "Serial Number", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
        verify_existing_columns_names(column_names, 2)
      end
    else
      it "Verify that the grid has the following columns: 'Access Points Hostname', 'Serial Number', 'Tags', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
        column_names = ["Check Box", "Access Point Hostname", "Serial Number", "Tags", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
        verify_existing_columns_names(column_names, 2)
      end
    end
  end
end

shared_examples "restore view to default" do |what_area|
  if what_area == "Groups"
    describe "Restore the Group tab's view to 'Default'" do
      it "Verify that the 'Default Columns' are: 'Group name', 'Access Point Count', 'Description', 'Status'" do
        @ui.click('xc-grid columnpicker .blue')
        sleep 1
        expect(@ui.css('.column_selector_modal')).to be_visible
        sleep 1
        @ui.click('#column_selector_restore_defaults')
        sleep 1
        selected_items_list = @ui.css('#rhs_selector ul')
        original_list_length = selected_items_list.lis.length
        list_length = original_list_length # solved list_length issue
        if list_length == 0
          @ui.click('#column_selector_modal_cancel_btn')
        else
          column_names = ["Group Name", "Access Point Count", "Description", "Status"]
            begin
              list_length-=1
              li = selected_items_list.lis.select{|li| li.visible?}[list_length]
              column_name = column_names[list_length]
              puts li.text + " - should equal - " + column_name
              expect(li.text).to eq(column_name)
            end while (list_length > 0)
          sleep 1
          @ui.click('#column_selector_modal_save_btn')
        end
        expect{expect(original_list_length).to eq(4)}.not_to raise_error#(RSpec::Expectations::ExpectationNotMetError)
      end
    end
  elsif what_area == "Access Points"
    describe "Restore the AP tab's view to 'Default'" do
      it "Verify that the 'Default Columns' are: 'Access Points Hostname', 'Serial Number', 'Profile', 'DHCP Pool', 'IP Address', 'Location', 'Status', 'Online' and 'Expiration Date'" do
        @ui.click('#mynetwork_arrays_grid_cp')
        sleep 1
        expect(@ui.css('#mynetwork_arrays_grid_cp_modal')).to be_visible
        sleep 1
        @ui.click('#column_selector_restore_defaults')
        sleep 1
        selected_items_list = @ui.css('#rhs_selector ul')
        list_length = selected_items_list.lis.length
        expect(list_length).to eq(9)
        column_names = ["Access Point Hostname (required)", "Serial Number", "Profile", "DHCP Pool", "IP Address", "Location", "Status", "Online" , "Expiration Date"]
          begin
            list_length-=1
            li = selected_items_list.lis.select{|li| li.visible?}[list_length]
            column_name = column_names[list_length]
            puts li.text + " - should equal - " + column_name
            expect(li.text).to eq(column_name)
          end while (list_length > 0)
        sleep 1
        @ui.click('#column_selector_modal_save_btn')
      end
    end
  end
end

################################################### US5127 AOS Only | Allow reset while preserving connectivity ###################################################

shared_examples "reset an ap" do |connectivity, profile_name|
  describe "Go to the profile '#{profile_name}' and to the AP tab" do
    it "Go to the profile named '#{profile_name}'" do
      @ui.goto_profile profile_name
    end
    it "Go to the 'Access Points' tab" do
      @ui.click('#profile_tab_arrays')
      sleep 1.5
      expect(@browser.url).to include('/#profiles/')
      expect(@browser.url).to include('/aps')
      @@access_point_sn = @ui.css('table tbody tr .serialNumber .nssg-td-text').text
    end
  end
  describe "Reset the AP " do
    it "Open the slideout for the AP and verify that the 'Factory Reset' function is properly named, not disabled and can be clicked" do
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", @@access_point_sn, "invoke")
      sleep 1
      @ui.click('.ko_slideout_content .top .buttons.align_right .lightgrey.button.drop_menu')
      factory_reset_path = @ui.css('.ko_slideout_content .top .buttons.align_right .lightgrey.button.drop_menu .more_menu.drop_menu_nav.active .items a:nth-child(2)')
      factory_reset_class =  factory_reset_path.attribute_value("class")
      expect(factory_reset_class).not_to include("disabled")
      expect(factory_reset_path.text).to eq("Reset")
      factory_reset_path.click
    end
    it "Verify that the 'Reset Access Point(s)' modal is displayed and has all proper features" do
      expect(@ui.css('xc-modal-container')).to be_present
      expect(@ui.css('xc-modal-container xc-modal-title').text).to eq("Reset Access Point(s)")
      #expect(@ui.css('xc-modal-container xc-modal-body div:first-child .warning').text).to eq("This will reset all settings to factory defaults, including the IP address.")
      expect(@ui.css('xc-modal-container xc-modal-body div:first-child p').text).to eq("Are you sure you would like to reset the selected Access Point(s) to their original factory settings?")
      expect(@ui.css('xc-modal-container xc-modal-body div:first-child .note').text).to eq("Note: If the Access Point is allocated to a Profile prior to the reset, it will be unassigned.")
      expect(@ui.css('xc-modal-container xc-modal-body div:nth-child(2) span').text).to eq("Reset while preserving connectivity?")
      expect(@ui.css('xc-modal-container xc-modal-body div:nth-child(2) + .note').text).to eq("Preserving connectivity will keep your IP and proxy settings")
      expect(@ui.css('xc-modal-container xc-modal-body div:nth-child(2) .switch input')).to exist
      expect(@ui.get(:checkbox , {css: 'xc-modal-container xc-modal-body div:nth-child(2) .switch input'}).set?).to eq(false)
      expect(@ui.css('xc-modal-container xc-modal-buttons .button')).to exist
      expect(@ui.css('xc-modal-container xc-modal-buttons .button.orange')).to exist
      expect(@ui.css('xc-modal-container xc-modal-buttons .button.orange').text).to eq("YES, RESET THE ACCESS POINT")
    end
    if connectivity == "Yes"
      it "Set the 'Reset while preserving connectivity' switch to 'true (Yes)'" do
        @ui.click('xc-modal-container xc-modal-body div:nth-child(2) .switch .switch_label')
        sleep 2
        expect(@ui.get(:checkbox , {css: 'xc-modal-container xc-modal-body div:nth-child(2) .switch input'}).set?).to eq(true)
      end
    end
    it "Reset the AP, verify the proper message," do
      @ui.click('xc-modal-container xc-modal-buttons .button.orange')
      sleep 0.5
      @ui.css('.dialogOverlay .success').wait_until_present
      expect(@ui.css('.dialogOverlay .success .msgbody div').text).to eq("Factory Settings Reset\nChanges will take effect momentarily")
    end
    it "Refresh the browser and verify the entry isn't visible in the profile grid anymore" do
      @browser.refresh
      @ui.css('table thead').wait_until_present
      sleep 1
      expect(@ui.css('table tbody').trs.length).to eq(0)
    end
  end
  describe "Go back to the AP grid (My network) and verify the AP properly exists" do
    it "Go to My Network -> AP tab" do
      @ui.click('#header_mynetwork_link')
      sleep 2.5
      @ui.click('#mynetwork_tab_arrays')
      sleep 1
    end
    it "Verify that the AP properly exists" do
      @ui.grid_action_on_specific_line("4", "a", @@access_point_sn, "invoke")
      sleep 2
      expect(@ui.css('#profile_arrays_details_slideout')).to be_present
      expect(@ui.get(:input , {id: 'edit_name'}).value).to eq(@@access_point_sn)
    end
  end
end

shared_examples "verify clients tab in access point details slideout panel" do |client_hostname, client_mac|
  describe "verify clients tab in access point details slideout panel for #{client_hostname}" do
    ap_hostname=nil
    context "General method - Go to Clients Tab (My Network)" do
      it_behaves_like "go to mynetwork clients tab"
    end
    context "Open the client '#{client_hostname}' and verify the slideout tab's content" do
      it "Find the client and open the slideout tab" do
        @ui.grid_action_on_specific_line(3, "a", client_hostname, "invoke") and sleep 2
        @ui.css('client-details .ko_slideout_content xc-slideout-content').wait_until_present
      end
      it "get accesspoint hostname where client #{client_hostname} connected" do
        ap_hostname = @ui.css(".client-health-info .first-row span:nth-child(3)").text
      end  
    end
   context "verify clients tab in access point details slideout panel for #{client_hostname}" do
     it "Go to the 'Access Points' tab" do
        go_to_my_network_arrays_tab
      end
     it "Open the slideout for the AP with hostname '#{ap_hostname}' and click clients" do
      @browser.execute_script('$("#suggestion_box").hide()')
      sleep 1
      @ui.grid_action_on_specific_line("3", "a", ap_hostname, "invoke")
      sleep 2
      expect(@ui.css('#profile_arrays_details_slideout')).to be_present
      @ui.css("#arraydetails_tab_clients").click
    end
    it "verify all columns are present" do
      expect(@ui.css("#clientTable .nssg-thead-tr th:nth-child(1)").text).to eq("Client Hostname")
      expect(@ui.css("#clientTable .nssg-thead-tr th:nth-child(2)").text).to eq("SSID")
      expect(@ui.css("#clientTable .nssg-thead-tr th:nth-child(3)").text).to eq("Radio")
      expect(@ui.css("#clientTable .nssg-thead-tr th:nth-child(4)").text).to eq("Connected Time")
    end
    it "Open client link and verify redirect to clients troubleshooting panel with mac id #{client_mac}" do
      clients = @browser.elements(:css, "#clientTable .device_list .nssg-tbody tr")
      clients.each do |client|
        if client.element(:css, "td:nth-child(1)").text == client_hostname
          client.element(:css, "a").click
          break
        end
      end 
      expect(@browser.url).to include("#mynetwork/clients/#{client_mac}")  
    end
   end   
  end #describe
end #shared_examples

shared_examples "change the hostname value" do |ap_sn, ap_hostname|
  describe "Change the Hostname value to '#{ap_hostname}' for the AP with the Serial Number '#{ap_sn}'" do
    it "Open the slideout for the AP with Serial Number '#{ap_sn}', if needed, change the Hostname to the value '#{ap_hostname}'" do
      @browser.execute_script('$("#suggestion_box").hide()')
      sleep 1
      @ui.grid_action_on_specific_line("4", "a", ap_sn, "invoke")
      sleep 2
      expect(@ui.css('#profile_arrays_details_slideout')).to be_present
      if @ui.get(:input , {id: 'edit_name'}).value != ap_hostname
        @ui.set_input_val('#edit_name', ap_hostname)
      end
      sleep 2
      if @ui.css('#edit_profile .text').text != "Unassigned Access Points"
        @ui.set_dropdown_entry('edit_profile', "Unassigned Access Points")
      end
      sleep 2
      @ui.click('#arraydetails_save')
      sleep 2
      @ui.click('#arraydetails_close_btn')
      @ui.css('#profile_arrays_details_slideout').wait_while_present
    end
    it "Reopen the slideout and verify the proper value is displayed" do
      @ui.grid_action_on_specific_line("4", "a", ap_sn, "invoke")
      sleep 2
      expect(@ui.css('#profile_arrays_details_slideout')).to be_present
      expect(@ui.get(:input , {id: 'edit_name'}).value).to eq(ap_hostname)
      expect(@ui.css('#edit_profile .text').text).to eq("Unassigned Access Points")
    end
    it "Close the AP slideut window" do
      @ui.click('#arraydetails_close_btn')
      sleep 2
      @ui.css('#profile_arrays_details_slideout').wait_while_present
    end
  end
end

RSpec::Matchers.define :custom_verify_value_data_type do |expected|
  match do |actual|
    actual === expected
  end
  description do
    "Am zis ca '#{actual}' tre sa fie acceasi tip de data si sa aiba aceeasi valoare ca si '#{expected}'"
  end
end