require_relative "../../TS_Refresh_Grids/local_lib/refresh_grids_lib.rb"
require_relative "../../TS_Portal/local_lib/portal_lib.rb"

def change_input_field_value_to_new_and_back(type,field_id,new_value,click_path)
  input_field = @ui.get(type, {id: field_id})
  input_field.wait_until(&:present?)
  original_value = input_field.value

  input_field.set new_value
  sleep 0.5
  @ui.click(click_path)
  sleep 3
  expect(input_field.value).to eq(new_value)

  input_field.set original_value
  sleep 0.5
  @ui.click(click_path)
  sleep 3
  expect(input_field.value).to eq(original_value)
end

def change_carrier(country, carrier , verify_string)
  @ui.click('#settings_myaccount div:nth-child(10) div:nth-child(3) a')
  sleep 0.5
  @ui.set_dropdown_entry('myaccount_mobile_country',country)
  sleep 0.5
  @ui.set_dropdown_entry('myaccount_mobile_carrier',carrier)
  sleep 0.5
  @ui.click('#settings_myaccount div:nth-child(10) .carrier_field .carrier_edit')
  sleep 0.5
  expect(@ui.css('#settings_myaccount div:nth-child(10) .carrier_field .carrier_view').text).to eq(verify_string)
end

def place_remove_tick_from_notifications_table
  alerts_table = @ui.css('#settings_myaccount .field.alertsTable')
  check_boxes = alerts_table.labels(:css => '.mac_chk_label')
  $global_check_boxes = check_boxes
  check_boxes.each { |check_box|
      check_box.click
      sleep 2
  }
  active_check_boxes = alerts_table.checkboxes
  $checked = 0
  active_check_boxes.each { |active_check_box|
    if(active_check_box.set?)
        $checked = $checked + 1
    end
  }
end

def check_look_feel_configs_on_portals_visible(which_checkbox_id, which_page_to_open, which_path_to_verify, no_of_pages)
  if (@ui.css('#guestportal_config_lookfeel_view .innertab .preview.fullscreen').exists?)
    @ui.click('#guestportal_preview_close')
  end
  sleep 0.5
  @ui.click("#{which_checkbox_id} + .mac_chk_label")
  sleep 0.5
  @ui.save_guestportal
  sleep 0.5
  @ui.click(which_page_to_open)
  sleep 0.5
  @ui.css('.iframe_preview_overlay').hover
  sleep 0.5
  @ui.click('.fullscreen_button')
  sleep 0.5
  frame = @ui.get(:iframe, { css: '.iframe_preview' })
  expect(frame.element(:css => which_path_to_verify)).to be_visible
  @ui.click('#guestportal_preview_close')

  c = @ui.css('.page_tiles_container ul')
  c.wait_until(&:present?)
  expect(c.lis.select{|li| li.visible?}.length).to eq(no_of_pages)
end

def check_look_feel_configs_on_portals_not_visible(which_checkbox_id, which_page_to_open, which_path_to_verify, no_of_pages)
  sleep 0.5
  @ui.click("#{which_checkbox_id} + .mac_chk_label")
  sleep 0.5
  @ui.save_guestportal
  sleep 0.5
  @ui.click(which_page_to_open)
  sleep 0.5
  @ui.css('.iframe_preview_overlay').hover
  sleep 0.5
  @ui.click('.fullscreen_button')
  sleep 0.5
  frame = @ui.get(:iframe, { css: '.iframe_preview' })
  expect(frame.element(:css => which_path_to_verify)).not_to be_visible
  @ui.click('#guestportal_preview_close')

  c = @ui.css('.page_tiles_container ul')
  c.wait_until(&:present?)
  expect(c.lis.select{|li| li.visible?}.length).to eq(no_of_pages)
end

shared_examples "verify main window components" do
  describe "Verify the main window's components after first login" do
    it "Verify that the browser url is the correct one" do
      expect(@browser.url).to include('/#guestportals')
    end
    it "Verify that the 'Xirrus Wi-Fi Networks' logo exists and is displayed" do
      expect(@ui.css('#header_logo')).to exist
      expect(@ui.css('#header_logo')).to be_visible
    end
    it "Verify that the 'Access Services' dropdown menu exists and is displayed" do
      expect(@ui.css('#header_nav_guestportals')).to exist
      expect(@ui.css('#header_nav_guestportals')).to be_visible
    end
    it "Verify that the 'Arrays' dropdown menu exists and is displayed" do
      expect(@ui.css('#header_nav_arrays')).to exist
      expect(@ui.css('#header_nav_arrays')).to be_visible
    end
    it "Verify that the 'Help' button exists and is displayed" do
      expect(@ui.css('#header_nav_help')).to exist
      expect(@ui.css('#header_nav_help')).to be_visible
    end
    it "Verify that the 'User Dropdown Menu' exists and is displayed" do
      expect(@ui.css('#header_nav_user')).to exist
      expect(@ui.css('#header_nav_user')).to be_visible
    end
    it "Open the 'User Dropdown Menu' and verify that the available options are: Support Management, Settings, Contact Us ... and Log Out" do
      @ui.click('#header_nav_user')
      expect(@ui.css('#header_backoffice_link')).to be_visible
      expect(@ui.css('#header_settings_link')).to be_visible
      expect(@ui.css('#header_contact')).to be_visible
      expect(@ui.css('#header_logout_link')).to be_visible
      @ui.click('#header_nav_user')
    end
    it "Verify that the 'Page Title' is 'EasyPass Portal' and the quick help icon is displayed" do
      if @ui.css('#guestportals_title span:nth-child(1)').text.to_i == 1
        expect(@ui.css('#guestportals_title span:nth-child(2)').text).to eq('EasyPass Portal')
      else
        expect(@ui.css('#guestportals_title span:nth-child(2)').text).to eq('EasyPass Portals')
      end
      expect(@ui.css('#guestportals_title .koHelpIcon')).to be_visible
    end
    it "Verify that the mozaic head contains the 'Search Input Box', '+New Portal' button and the 'View Toggle'" do
      expect(@ui.css('#guestportals_head')).to exist
      expect(@ui.css('#guestportals_head')).to be_visible
      expect(@ui.css('#new_guestportal_btn')).to be_visible
      expect(@ui.css('#guestportals_head .search #guestportals_search_input')).to be_visible
      expect(@ui.css('#guestportals_head .view_toggle #guestportals_tiles_view_btn')).to be_visible
      expect(@ui.css('#guestportals_head .view_toggle #guestportals_list_view_btn')).to be_visible
    end
    it "Verify that the 'Guest Portals List' exists and is displayed" do
      expect(@ui.css('#guestportals_list')).to exist
      expect(@ui.css('#guestportals_list')).to be_visible
    end
    it "Verify that the 'Main Footer' exists and that the text is 'XIRRUS BACKOFFICE'" do
      expect(@ui.css('#main_footer .appTitle').text).to eq('XIRRUS BACKOFFICE')
    end
    it "Verify that the 'Copyright' information is present, the 'Privacy & Policy' and 'Terms of use' links exist and are displayed" do
      expect(@ui.css('#main_footer #copyright').text).to eq('Copyright © 2005-2019 Xirrus, Inc. All Rights Reserved.')
      expect(@ui.css('#footer_privacy_link')).to be_visible
      expect(@ui.css('#footer_terms_link')).to be_visible
    end
    it "Verify that the 'Suggestion Drawer' exists and is displayed" do
      expect(@ui.css('#suggestion_box .suggestionContainer .suggestionTitle')).to be_visible
      @ui.click('#suggestion_box .suggestionContainer .suggestionTitle')
      sleep 1
      expect(@ui.css('#suggestion_box .suggestionContainer .suggestionContent .suggestion_types xc-big-icon-button:first-child xc-big-icon-button-container')).to be_visible
      expect(@ui.css('#suggestion_box .suggestionContainer .suggestionContent .suggestion_types xc-big-icon-button:first-child xc-big-icon-button-container .name span').text).to eq("Contact Support")
      expect(@ui.css('#suggestion_box .suggestionContainer .suggestionContent .suggestion_types xc-big-icon-button:nth-child(2) xc-big-icon-button-container')).to be_visible
      expect(@ui.css('#suggestion_box .suggestionContainer .suggestionContent .suggestion_types xc-big-icon-button:nth-child(2) xc-big-icon-button-container .name span').text).to eq("Give us Feedback")
      expect(@ui.css('#suggestion_hide')).to be_visible
      sleep 1
      @browser.execute_script('$("#suggestion_box").hide()')
    end
    it "Verify the create Access Points modal and that the available Access Points types are 'Self-Registration' and 'Guest Ambassador'" do
      @ui.click('#header_guestportals_arrow')
      sleep 0.5
      @ui.click('#header_new_guestportals_btn')
      sleep 1
      expect(@ui.css('#guestportals_newportal')).to be_visible
      expect(@ui.css('#guestportals_newportal .commonTitle').text).to eq('Choose an EasyPass™ Portal Type')
      expect(@ui.css('#guestportals_newportal .portal_group.guests .portal_group_title span').text).to eq('Guest Access')
      expect(@ui.css('#guestportals_newportal .portal_group.employee_student .portal_group_title span').text).to eq('Employee/Student Access')
      expect(@ui.css('#guestportals_newportal .content .portal_selection .self_reg')).to be_visible #div:nth-child(2)
      expect(@ui.css('#guestportals_newportal .content .portal_selection .ambassador')).to be_visible
      expect(@ui.css('#guestportals_newportal .content .portal_selection .google')).to be_visible
      expect(@ui.css('#guestportals_newportal .content .portal_selection .onboarding')).to be_visible
      expect(@ui.css('#guestportals_newportal .content .portal_selection .onetouch')).to be_visible
      expect(@ui.css('#guestportals_newportal .content .portal_selection .personal')).to be_visible
      expect(@ui.css('#guestportals_newportal .content .portal_selection .voucher')).to be_visible
      sleep 0.5
      @ui.click('#guestportals_newportal_closemodalbtn')
    end
  end
end
shared_examples "verify contact us tab" do
  describe "Verify 'Contact us' open new tab and redirect to riverbed contact page" do
    it "Verify  'Contact us' open new tab" do 
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_contact')
      sleep 1
      browser_url = find_new_browser_tab_and_verify_contact
      expect(browser_url).to include("https://www.cambiumnetworks.com/support/contact-support/")
    end
    it "Close the 'Contact us' tab" do
        @browser.window(:url => /https:\/\/www.cambiumnetworks.com\/support\/contact-support/).close
    end
  end
end

def find_new_browser_tab_and_verify_contact
  @browser.window(:url => /https:\/\/www.cambiumnetworks.com\/support\/contact-support/).wait_until(&:present?)
  @browser.window(:url => /https:\/\/www.cambiumnetworks.com\/support\/contact-support/).use do
    @browser.body(:css => "body").wait_until(&:present?)
    sleep 1.5
    return @browser.url
  end
end
shared_examples "verify contact us" do
  describe "Verify that the 'Contact us' page is accessible and displays the proper information" do
    it "Go to the 'Contact Us' area" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_contact')
      sleep 1
    end
    it "Verify that the title of the page is 'Contact'" do
      expect(@ui.css('.globalTitle').text).to eq("Contact")
    end
    it "Verify that the contents of the page are properly displayed" do
      expect(@ui.css('#contactView .contents .title').text).to eq('Xirrus Inc')

      expect(@ui.css('#contactView .contents .topSection ul li:first-child .title').text).to eq('Corporate Office')
      expect(@ui.css('#contactView .contents .topSection ul li:first-child .address').text).to eq('2101 Corporate Center Drive Thousand Oaks, CA 91320')
      expect(@ui.css('#contactView .contents .topSection ul li:first-child ul li:first-child').text).to eq('1.800.947.7871 Toll Free US')
      expect(@ui.css('#contactView .contents .topSection ul li:first-child ul li:nth-child(2)').text).to eq('1.805.262.1600 International')
      expect(@ui.css('#contactView .contents .topSection ul li:first-child ul li:nth-child(3)').text).to eq('1.805.262.1601 Fax')

      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(2) .title').text).to eq('Northern California Office')
      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(2) .address').text).to eq('525 Almanor Ave, 5th floor Sunnyvale, CA 94085')

      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(3) .title').text).to eq('EMEA Office')
      expect(@ui.css('#contactView .contents .topSection ul li:nth-child(3) .address').text).to eq('55 Old Broad St, London, EC2M 1RX. UK')

      expect(@ui.css('#contactView .contents .bottomSection .additional').text).to eq('For additional information, you may contact us using the following:')

      expect(@ui.css('#contactView .contents .bottomSection .infoList li:first-child .title').text).to eq('General Company Information')
      expect(@ui.css('#contactView .contents .bottomSection .infoList li:first-child .emails li a').text).to eq('info@xirrus.com')
      expect(@ui.css('#contactView .contents .bottomSection .infoList li:first-child .phones li').text).to eq('1.805.262.1600')

      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(2) .title').text).to eq('Employment Opportunities')
      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(2) .emails li a').text).to eq('resumes@xirrus.com')

      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(3) .title').text).to eq('Press Relations')
      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(3) .emails li a').text).to eq('press@xirrus.com')

      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(4) .title').text).to eq('Webmaster')
      expect(@ui.css('#contactView .contents .bottomSection .infoList li:nth-child(4) .emails li a').text).to eq('webmaster@xirrus.com')

      expect(@ui.css('#contactView .contents .bottomSection .opsList li:first-child .title').text).to eq('North American Operations')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:first-child .emails li:first-child a').text).to eq('sales@xirrus.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:first-child .emails li:nth-child(2) a').text).to eq('support@riverbed.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:first-child .phone').text).to eq('1.805.262.1600')

      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(2) .title').text).to eq('Asia Pacific and Japan Operations')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(2) .emails li:first-child a').text).to eq('sales@xirrus.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(2) .emails li:nth-child(2) a').text).to eq('support@riverbed.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(2) .phones li:first-child').text).to eq('+61.2.8006.0622')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(2) .phones li:nth-child(2)').text).to eq('Australia: 1300.947.787')

      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(3) .title').text).to eq('Europe, Middle East, and Africa Operations')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(3) .emails li:first-child a').text).to eq('sales-emea@xirrus.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(3) .emails li:nth-child(2) a').text).to eq('support@riverbed.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(3) .phones li:first-child').text).to eq('UK: +44 203 239 8644')

      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(4) .title').text).to eq('Central and South America Operations')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(4) .emails li:first-child a').text).to eq('sales@xirrus.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(4) .emails li:nth-child(2) a').text).to eq('support@riverbed.com')
      expect(@ui.css('#contactView .contents .bottomSection .opsList li:nth-child(4) .phones li').text).to eq('1.805.262.1600')
    end
  end
end

shared_examples "verify descending ascending sorting on xmse access points" do |column|
  describe "Verify the descending / ascending sort feature on the tab 'Access Points' and column #{column}" do
    it "Ensure you are on the 'Access Points' tab" do
      @browser.execute_script('$("#suggestion_box").hide()')
      sleep 0.5
      @ui.click('#header_logo')
      sleep 1
      @ui.click('#header_arrays_link')
      sleep 0.5
    end
    it "Arrange the column '#{column}' in ascending order and take the first 3 and last 3 values in the column" do
      @ui.find_grid_header_by_name(column)

      $column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"

      if (@ui.css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages').exists?)
        @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
        sleep 4
      end

      @ui.get_grid_length
      if $grid_length > 200
        $bool_several_entries = true
      end
      sleep 2
      if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
        sleep 1
        @ui.css("#{$column_string} .nssg-th-text").click
        if ($bool_several_entries == true)
          sleep 6
        end
        expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
        elsif (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
          (1..2).each do |i|
            @ui.css("#{$column_string} .nssg-th-text").click
            sleep 1
            if ($bool_several_entries == true)
              sleep 6
            end
          end
          expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
        else
          (1..3).each do |i|
            @ui.css("#{$column_string} .nssg-th-text").click
            sleep 1
            if ($bool_several_entries == true)
              sleep 6
            end
          end
          expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
      end
      sleep 2
      $grid_length_second_last = $grid_length - 1
      $grid_length_third_last = $grid_length - 2
      $desc_min_first_val = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text
      $desc_max_first_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text
      $desc_min_second_val = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text
      $desc_max_second_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text
      $desc_min_third_val = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text
      $desc_max_third_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text
    end

    it "Change the sort feature on the '#{column}' column to descending" do
      if (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
        @ui.css("#{$column_string} .nssg-th-text").click
        if ($bool_several_entries == true)
          sleep 6
        end
        expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to exist
        expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to be_visible
      end
    end

    it "Verify that the descending sort first value is the last value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
    end
    it "Verify that the descending sort second value is the second last value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
    end
    it "Verify that the descending sort third value is the third last value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
    end

    it "Change the sort feature on the '#{column}' column to ascending" do
      if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
        @ui.css("#{$column_string} .nssg-th-text").click
        if ($bool_several_entries == true)
          sleep 6
        end
        expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
        expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to be_visible
      end
    end

    it "Verify that the ascending sort first value is the first value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
    end
    it "Verify that the ascending sort second value is the second last value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
    end
    it "Verify that the ascending sort third value is the third last value taken from the ascending sort" do
      expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
      expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
    end
  end
end

shared_examples "verify refresh button on access points tab" do
  describe "Verify that the 'Refresh' button performs the proper action" do
    it "Ensure you are on the 'Access Points' tab" do
      @ui.click('#header_arrays_link')
      sleep 0.5
    end
    it "Set the paging display entries to '10'" do
      set_paging_view_per_grid("10")
    end
    it "Verify proper page is displayed with all elements present" do
      $eq = Hash[
        '#main_container .arrays_tab .commonTitle' => 'All Access Points'
      ]
      $is_visible = [
        '#main_container .arrays_tab grid',
        '#main_container .arrays_tab .push-down.clearfix .nssg-paging .nssg-paging-controls',
        '#main_container .arrays_tab .push-down.clearfix .nssg-paging .nssg-paging-count',
        '#main_container .arrays_tab .nssg-refresh'
      ]
      verify_page_contents($eq, $is_visible)
      $grid_length_refresh = $grid_length
    end
    it "Press the 'Refresh' button 10 times and verify that the grid has the class '.isLoading'" do
      (0..10).each do
        click_the_refresh_grid_button('#main_container .arrays_tab grid div:first-child', nil)
        sleep 0.4
      end
    end
    it "Verify that all elements are still properly displayed" do
      verify_page_contents($eq, $is_visible)
      expect($grid_length_refresh).to eq($grid_length)
    end
  end
end
#covered in portals
# shared_examples "create portal from new portal button" do |portal_name, portal_description, portal_type|
  # describe "Create a new Access Service named '#{portal_name}' of the type '#{portal_type}', from New portal button" do
    # it "Press the 'Header Logo' and then open the 'Access Services' dropdown menu" do
      # @ui.click('#header_logo')
      # sleep 0.5
      # @ui.click('#header_nav_guestportals')
      # sleep 0.5
    # end
    # it "Click the '+ New Portal' button" do
      # expect(@ui.id("header_new_guestportals_btn")).to be_visible
      # sleep 0.5
      # @ui.click("#header_new_guestportals_btn")
      # sleep 0.5
    # end
    # it "Presses the '#{portal_type.upcase}' tile to select the type of portal to be used" do
      # expect(@ui.css('#guestportals_newportal')).to be_visible
      # sleep 0.5
      # @ui.css('#guestportals_newportal .' + portal_type).hover
      # sleep 0.5
      # @ui.css('#guestportals_newportal .' + portal_type).click
      # sleep 0.5
      # expect(@ui.css('.portal_details.show')).to be_visible
    # end
    # it "Set the portal name value as '#{portal_name}'" do
      # @ui.set_input_val("#guestportal_new_name_input", portal_name)
    # end
    # it "Set the portal description value as '#{portal_description}'" do
      # @ui.set_input_val('#guestportal_new_description_input', portal_description)
    # end
    # it "Press the 'CREATE' button" do
      # @ui.click('#newportal_next')
    # end
    # it "Verify that the user is navigated to the new portal and check that the portal name, type and description are correct" do
      # # wait for the portal name to appear
      # pn = @ui.id("profile_name")
      # pn.wait_until_present
      # @browser.refresh
# 
      # pt = @ui.css('#guestportal_config_general_view .innertab .title')
      # pt.wait_until_present
      # expect(@browser.url).to include("/config")
# 
# 
      # portal_type_str = ""
      # case portal_type
        # when "onetouch"
           # portal_type_str = "One-Click Access"
        # when "self_reg"
           # portal_type_str = "Self-Registration"
        # when "ambassador"
           # portal_type_str = "Guest Ambassador"
        # when "onboarding"
           # portal_type_str = "EasyPass Onboarding"
        # when "voucher"
           # portal_type_str = "EasyPass Voucher"
        # when "personal"
           # portal_type_str = "EasyPass Personal Wi-Fi"
        # when "google"
           # portal_type_str = "EasyPass Google"
        # when "facebook"
           # portal_type_str = "Facebook Wi-Fi"
        # when "azure"
           # portal_type_str = "Microsoft Azure"
      # end
      # # check portal name, type and description
      # expect(pn.text).to eq(portal_name)
      # expect(@ui.id("profile_description").text).to eq(portal_description)
      # expect(pt.text).to eq(portal_type_str)
    # end
  # end
# end
#Covered in portals
# shared_examples "delete portal from tile" do |portal_name|
  # describe "Delete the Access Service named '#{portal_name}' using the tile controls" do
    # it "Go to the Access Services landing page" do
      # @ui.click('#header_logo')
      # sleep 1
      # @ui.goto_all_guestportals_view
      # sleep 0.5
      # @ui.click('#guestportals_title span:first-child')
    # end
    # it "Hover over the '#{portal_name}' Access Service's tile to reveal overlay buttons and press the 'Delete' button" do
      # portal_titles = @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile a span:nth-child(1)"})
      # portal_delete_icons = @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile div:first-child div a:first-child"})
      # portal_titles.each { |portal_title|
        # if portal_title.text == portal_name
          # portal_title.hover
          # sleep 0.5
          # break
        # end
      # }
      # portal_delete_icons.each { |portal_delete_icon|
        # if portal_delete_icon.visible?
          # portal_delete_icon.click
          # sleep 0.5
          # break
        # end
      # }
    # end
    # it "Confirm the deletion and verify the grid does not show the Access Service named '#{portal_name}'" do
      # @ui.confirm_dialog
      # sleep 2
      # @browser.refresh
      # sleep 3
      # portal_titles = @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile a span:nth-child(1)"})
      # portal_titles.each { |portal_title|
        # expect(portal_title.text).not_to eq(portal_name)
      # }
    # end
  # end
# end

shared_examples "policies tab test on personal wifi access service" do |portal_name, portal_type, something_else_1, something_else2|
  describe "Verify that the Personal Wi-Fi Access Service called '#{portal_name}' has the policies tab and it works as intended" do
    it "Go to the Access Service named '#{portal_name}', then to the 'Guests' tab" do
      # make sure it goes to the portal
      navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false)
    end
    it "Verify that the Access Service's configurations tabs are: 'General', 'Look & Feel', 'SSIDs' and 'Policies'" do
      config_tabs = @ui.css('#profile_config_tabs')
      config_tabs.wait_until(&:present?)
      config_tabs_length = config_tabs.lis.length

      expect(config_tabs_length).to eq(4)
      expect(@ui.css('#guestportal_config_tab_general')).to be_visible
      expect(@ui.css('#guestportal_config_tab_lookfeel')).to be_visible
      expect(@ui.css('#guestportal_config_tab_ssids')).to be_visible
      expect(@ui.css('#guestportal_config_tab_policies')).to be_visible
    end
    it "Go to the policies tab" do
      @ui.css('#guestportal_config_tab_policies').click
    end
    it "CONTINUE CREATING TESTS ONCE ISSUE PR 26779 IS FIXED" do
    end
  end
end

shared_examples "add, count & delete guests" do |portal_name, portal_type, number_of_guests|
  describe "Add, count & delete guests for the Access Service named '#{portal_name}'" do
    it "Go to the Access Service named '#{portal_name}', then to the 'Guests' tab" do
      # make sure it goes to the portal
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
      sleep 2
      @ui.click('#profile_tabs a:nth-child(2)')
    end
    it "Verify that the grid does not contain any entries" do
        expect(@ui.css('.nssg-paging-count')).not_to exist
    end
    it "Add '#{number_of_guests}' guests" do
      @browser.execute_script('$("#suggestion_box").hide()')
      sleep 1
      if portal_type == "ambassador" or portal_type == "onboarding" or portal_type == "self_reg"
        (1..number_of_guests).each do
          create_user_or_guest(portal_type)
        end

        if portal_type == "onboarding"
          body = @ui.css('.nssg-table tbody')
          body.wait_until(&:present?)
          expect(body.trs.length).to eq(number_of_guests)
        else
          body = @ui.css('#guestportal_guests_grid table tbody')
          body.wait_until(&:present?)
          expect(body.trs.length).to eq(number_of_guests)
        end
      else
        puts "For '#{portal_type}' Access Services, manually adding guests, users or vouchers is not possible. SKIPPING ...."
      end
    end

    it "Delete all the guests" do
      if portal_type == "ambassador" or portal_type == "onboarding" or portal_type == "self_reg"
        if portal_type == "onboarding"
          @ui.click('.nssg-table .nssg-th-select .mac_chk_label')
        else
          @ui.click('#guestportal_guests_grid table .nssg-th-select .mac_chk_label')
        end
        sleep 1

        @ui.click('.delete_guest_btn')
        sleep 1

        @ui.confirm_dialog
        sleep 3

        if portal_type == "onboarding"
          grid = @ui.css('.nssg-table')
        else
          grid = @ui.css('#guestportal_guests_grid table')
        end

        grid.wait_until(&:present?)
        expect(grid.trs.length).to eq(1)
      else
        puts "For '#{portal_type}' Access Services, manually adding guests, users or vouchers is not possible. SKIPPING ...."
      end
    end
  end
end

shared_examples "change settings my account tab" do
  describe "Perform changes on the 'My Account' page from Settings" do
    it "Go to the 'My Account' tab (Settings)" do
        @ui.click('#header_nav_user')
        sleep 0.5
        @ui.click('#header_settings_link')
        sleep 0.5
        expect(@browser.url).to include('/#settings/myaccount')
    end
    it "Change the 'First Name' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountfirstname', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    it "Change the 'Last Name' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountlastname', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    it "Change the 'Additional Details' value to a test value then back to the original value" do
      change_input_field_value_to_new_and_back(:textarea, 'myaccount_description', 'TEST VALUE', '#settings_myaccount .commonTitle')
    end
    #it "Change the 'Primary Email' value to a test value then back to the original value" do
    #  change_input_field_value_to_new_and_back(:text_field, 'myaccount_myaccountname', "TEST_VALUE" + XMS.ickey_shuffle(4) + "@qa.com", '#settings_myaccount .commonTitle')
    #end
    #it "Change the 'Primary Email' value to a test value then back to the original value" do
    #  change_input_field_value_to_new_and_back(:text_field, 'myaccount_mobile_number', '40730973335', '#settings_myaccount .commonTitle')
    #end
    it "Change carrier to 'Orange France' and verify it's properly displayed" do
      change_carrier("France", "Orange France" , "Orange France")
    end
    it "Change carrier to 'Spain Movistar' and verify it's properly displayed" do
      change_carrier("Spain", "Movistar" , "Movistar")
    end
    it "Change carrier to 'United States AT&T' and verify it's properly displayed" do
      change_carrier("United States", "AT&T" , "AT&T")
    end
    it "Verify the Mobile field has the quick help icon and the proper text" do
      @ui.css('#settings_myaccount div:nth-child(10) .mobile_number_info.infoBtn').hover
      sleep 0.5
      # expect(@ui.css('#settings_myaccount div:nth-child(10) .mobile_number_info.infoBtn.ko_tooltip_active')).to exist
      expect(@ui.css('#ko_tooltip')).to be_visible
      sleep 0.5
      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('Enter the phone number excluding the country code.')
    end
#    it "Verify the Notifications header title has the quick help icon and the proper text" do
#      @ui.css('#settings_myaccount div:nth-child(11) .infoBtn').hover
#      sleep 0.5
#      expect(@ui.css('#settings_myaccount div:nth-child(11) .infoBtn.ko_tooltip_active')).to exist
#      expect(@ui.css('#ko_tooltip')).to be_visible
#      sleep 0.5
#      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('If Email and/or SMS notifications are checked for a specific type of alert, a notification is sent when the alert is opened and when it is closed')
#    end
#    it "Verify the 'Alerts for Low Guest License Count' string has the quick help icon and the proper text" do
#      @ui.css('#settings_myaccount .field.alertsTable div:nth-child(2) .cell.first .infoBtn').hover
#      sleep 0.5
#      expect(@ui.css('#settings_myaccount .field.alertsTable div:nth-child(2) .cell.first .infoBtn.ko_tooltip_active')).to exist
#      expect(@ui.css('#ko_tooltip')).to be_visible
#      sleep 0.5
#      expect(@ui.css('#ko_tooltip .ko_tooltip_content').text).to eq('This alert is opened when there is less than 10% of guest licenses remaining')
#    end
#    it "Place a tick for both notifications settings types and verify it's properly set" do
#        place_remove_tick_from_notifications_table
#        expect($global_check_boxes.length).to eq($checked)
#    end
#    it "Remove the tick for both notifications settings types and verify it's properly removed" do
#        place_remove_tick_from_notifications_table
#        expect($checked).to eq(0)
#    end
    it "Click the 'Change Password' button and verify that the change passoword modal is properly displayed" do
      @ui.click('#myaccount_changepassword_btn')
      sleep 0.6
      @ui.css('.modal-change-password .ui-draggable').wait_until(&:present?)
      sleep 0.5
      @ui.click('.modal-change-password .ui-draggable .xc-modal-close')
    end
  end
end
shared_examples "change settings user accounts tab" do |number_of_users, xmsegap_priviledge, cloud_priviledge|
  describe "Perform changes on the 'My Account' page from Settings" do
    it "Go to the 'Settings' area then to the 'User Accounts' tab" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 1
      @ui.click('#settings_tab_useraccounts')
      sleep 2
    end
    it "Set the view per page to '1000' entries" do
      set_paging_view_per_grid("1000")
    end
    it "Get the grid length" do
      @ui.get_grid_length
      $grid_length_before = $grid_length
    end
    it "Create #{number_of_users} accounts" do
      @browser.execute_script('$("#suggestion_box").hide()')

      (1..number_of_users).each do
          usrFName = UTIL.ickey_shuffle(12)
          usrLName = UTIL.random_firstname.downcase
          usrDesc = UTIL.chars_255.upcase
          usrEmail = UTIL.random_email

          @ui.click('#useraccounts_newuser_btn')
          sleep 0.5
          @ui.set_input_val('#usermodal_firstname',usrFName)
          sleep 0.5
          @ui.set_input_val('#usermodal_lastname',usrLName)
          sleep 0.5
          @ui.set_input_val('#usermodal_details', usrDesc)
          sleep 0.5
          @ui.set_input_val('#usermodal_email',usrEmail)
          sleep 0.5
          @ui.set_dropdown_entry('ddl_XMSEGAP', xmsegap_priviledge)
          sleep 0.5
          if cloud_priviledge != nil
            @ui.set_dropdown_entry('ddl_BACKOFFICE', cloud_priviledge)
          end
          sleep 0.5
          @ui.click('#users_modal_save_btn')
          sleep 0.5
        end
    end
    it "Verify that the original grid length has been modified by #{number_of_users}" do
      @ui.get_grid_length
      $grid_length_after = $grid_length
      expect($grid_length_after).not_to eq($grid_length_before)
      grid_length_after_verify = $grid_length_before + number_of_users
      expect($grid_length_after).to eq(grid_length_after_verify)
    end
  end
end
shared_examples "delete all user accounts expect for those that include a certain string" do |lastname_not_to_del|
  describe "Delete all the user accounts except the ones with the last name including the string: #{lastname_not_to_del}" do
    it "Go to the 'User Accounts' page from Settings" do
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_settings_link')
      sleep 1
      @ui.click('#settings_tab_useraccounts')
      sleep 1
    end
    it "Set the view per page to '1000' entries" do
      set_paging_view_per_grid("1000")
    end
    it "Get the grid length" do
      @ui.get_grid_length
      $grid_length_before = $grid_length
    end
    it "Delete all User Accounts except from #{lastname_not_to_del} (last name)" do
        while ($grid_length != 0) do
            if @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length }) td:nth-child(5)").text.strip.include?(lastname_not_to_del)
                puts "Not deleting this account"
            else
                if @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(2) .nssg-td-select").visible? == true
                  sleep 0.5
                  @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length }) td:nth-child(3)").hover
                  sleep 0.5
                  @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length }) .nssg-actions-container .nssg-action-delete").click
                  sleep 0.5
                  @ui.click('#_jq_dlg_btn_1')
                  sleep 1
                  dialog = @ui.css('.dialogOverlay')
                  if dialog.exists? and dialog.visible?
                    dialog.wait_while_present
                  end
                  sleep 0.5
                  @ui.click('#settings_tab_useraccounts')
                else
                  puts "Can't delete this account because it is created trough CommandCenter"
                end
            end
            $grid_length-=1
        end
    end
    it "Set the view per page to '10' entries" do
      set_paging_view_per_grid("10")
    end
  end
end

shared_examples "verify look and feel settings self reg on all languages" do |portal_name, portal_type, language|
  describe "Verify the Look and Feel settings for 'Self-Registration' Access Services on all languages" do
    it "Go to the Access Service named #{portal_name} - General tab" do
      # make sure it goes to the portal
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false)
    end
    it "Update the language to: #{language}" do
      if (portal_type == "self_reg")
        if @ui.get(:checkbox, {id: "has_sponsor_switch"}).set? == true
          @ui.click('#has_sponsor .switch_label')
          sleep 0.6
          expect(@ui.get(:checkbox, {id: "has_sponsor_switch"}).set?).to eq(false)
        end
      end
      if(portal_type == "onetouch")
        puts 'Language not supported for ' + portal_type + ' skipping... '
        expect(portal_type).not_to eq("ambassador")
        expect(portal_type).not_to eq("self_reg")
        expect(portal_type).not_to eq("voucher")
      else
        @ui.set_dropdown_entry('guestportal_config_basic_language', language)
        @ui.save_guestportal
        sleep 1
        if(portal_type == 'voucher')
          # exit the generate vouchers dialog
          @ui.click('#manageguests_vouchermodal .buttons .orange')
          sleep 1
        end
        sleep 1
        @ui.click('#profile_name')
        expect(@ui.css('#guestportal_config_basic_language .ko_dropdownlist_button .text').text).to eq(language)
      end
    end
    it "Go to the Look & Feel tab" do
      @ui.click('#guestportal_config_tab_lookfeel')
    end
    it "Update the mobile collection and save" do
      check_look_feel_configs_on_portals_visible("#requireMobile", '.page_tiles_container ul li:nth-child(3)', ".mobile_required", 5)
    end
    it "Update google+ and save" do
      check_look_feel_configs_on_portals_visible("#google", '.page_tiles_container ul li:nth-child(1)', "#login_google", 5)
    end
    it "Update facebook and save" do
      check_look_feel_configs_on_portals_visible("#facebook",'.page_tiles_container ul li:nth-child(1)',"#login_facebook", 5)
    end
    it "Enable TOC and save" do
      check_look_feel_configs_on_portals_visible("#enableToU", '.page_tiles_container ul li:nth-child(3)',".terms_of_use", 6)
    end
    it "Disable data disclosure and save" do
      check_look_feel_configs_on_portals_not_visible("#requireDisclosure",'.page_tiles_container ul li:nth-child(3)', ".disclaimer", 6)
    end
    it "Revert all previous settings to default" do
      checkboxes_ids = ["#requireMobile", "#google", "#facebook", "#enableToU", "#requireDisclosure"]
      checkboxes_ids.each { |checkboxes_id|
        @ui.click("#{checkboxes_id} + .mac_chk_label")
        sleep 0.5
      }
      @ui.save_guestportal
    end
  end
end

shared_examples "confirm guest count on landing" do
  describe "confirm guest count on landing" do
    it "confirm guest count on landing" do
        @ui.click('#header_logo')
        sleep 1
        expect(@ui.css('.guestportals_guestcount')).to be_visible
    end
  end
end

