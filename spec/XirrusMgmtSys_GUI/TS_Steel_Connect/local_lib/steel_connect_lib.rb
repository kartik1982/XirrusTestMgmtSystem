require_relative "../../TS_Mynetwork/local_lib/floorplans_lib.rb"
require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"

shared_examples "verify steelconnect info tooltip" do # US 5228 - Created on 25/09/2017
  describe "Verify the information icon, tooltip contents and tenant dropdown on a Steel Connect tenant" do
    it "Verify that the tenant dropdown is visible and that the 'i' icon is 'info-white.svg'" do
      verify_csss = [".tenant_scope_wrapper.steelconnect", ".tenant_scope_wrapper.steelconnect .text-icon"]
      verify_csss.each do |verify_css|
        expect(@ui.css(verify_css)).to be_visible
      end
      expect(@browser.execute_script("return $('.tenant_scope_wrapper.steelconnect .text-icon').css('background-image')")).to include("/img/info-white.svg")
    end
    it "Hover over the 'i' icon and verify the tooltip message, then close the tooltip" do
      @ui.css(".tenant_scope_wrapper.steelconnect .text-icon").hover and sleep 0.5
      @ui.css('#ko_tooltip').wait_until_present
      verify_csss = Hash["#ko_tooltip .steelconnect-tooltip span" => "This network is managed by SteelConnect Manager. Certain functions are available only through XMS-Cloud.\nFor a complete list of these functions, please click", "#ko_tooltip .steelconnect-tooltip a" => "here."]
      verify_csss.each do |key, value|
        expect(@ui.css(key).text).to eq(value)
      end
      sleep 1
      @browser.execute_script('$("#ko_tooltip").hide()')
      @ui.click('.globalTitle') and sleep 1
    end
    it "Reopen the tooltip message and verify the href link" do
      @ui.css(".tenant_scope_wrapper.steelconnect .text-icon").hover and sleep 0.5
      @ui.css('#ko_tooltip').wait_until_present
      expect(@ui.css("#ko_tooltip .steelconnect-tooltip a").attribute_value("href")).to eq("https://xcs-#{$the_environment_used}.cloud.xirrus.com/docs/help/index.html#SteelConnect")
      @ui.click('#ko_tooltip .steelconnect-tooltip a') and sleep 2
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html#SteelConnect/).wait_until_present
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html#SteelConnect/).use do
        @browser.body(:css => "body").wait_until_present
      end
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html#SteelConnect/).close
      @browser.window(:url => /https:\/\/xcs-#{$the_environment_used}.cloud.xirrus.com\/docs\/help\/index.html#SteelConnect/).wait_while_present
    end
    it "Verify the tenant dropdown background color ('rgb(147, 189, 218)')" do
      expect(@browser.execute_script("return $('#tenant_scope_options').css('background-color')")).to eq("rgb(147, 189, 218)")
    end
  end
end

shared_examples "verify steelconnect info modal" do
  describe "Verify the SteelConnect RiverBed information modal displayed when the user first logs into the application (or on a new tenant)" do
    it "Wait for the information modal to be displayed" do
      @ui.css('#steelconnect-info-dialog').wait_until_present
    end
    it "Verify the following:
          - title: 'XMS-RiverBed SteelConnect Integration'
          - body: 'Your network is integrated with riverbed SteelConnect. Certain features are available only through XMS-Cloud. Provision your network from SteelConnect Manager. Use XMS-Cloud for monitoring, reporting, and configuring EasyPass Portals. For more information click here.'
          - close button: upper-right corner 'x' and 'CLOSE' orange button bottom-right corner" do
          expect(@ui.css('#steelconnect-info-dialog xc-modal-body .message').text).to eq("Your network is integrated with Riverbed SteelConnect. Certain functions are available only through XMS-Cloud. Provision your network from SteelConnect Manager. Use XMS-Cloud for monitoring, reporting, and configuring EasyPass portals.\n\nFor more information click")
          expect(@ui.css('#steelconnect-info-dialog xc-modal-body a').text).to eq("here.")
          expect(@ui.css('#steelconnect-info-dialog .xc-modal-close')).to be_present
          expect(@ui.css('#steelconnect-info-dialog xc-modal-buttons .orange')).to be_present
          expect(@ui.css('#steelconnect-info-dialog xc-modal-buttons .orange').text).to eq("CLOSE")
    end
    it "Click the 'CLOSE' button and verify the modal is properly closed" do
      @ui.click('#steelconnect-info-dialog xc-modal-buttons .orange')
      @ui.css('#steelconnect-info-dialog').wait_while_present
    end
    it "Verify that the SteelConnect blue bubble is displayed and has the text 'This network is managed by SteelConnect Manager'" do
      @ui.css('.steelconnect-bubble.errorBubble.blue').wait_until_present
      expect(@ui.css('.steelconnect-bubble.errorBubble.blue').text).to eq('This network is managed by SteelConnect Manager')
    end
  end
end

shared_examples "directly scope to a tenant using the url input of the browser" do |tenant_id, tenant_name, area_url, area_title, error| # XMSC-281 - Created on 03/11/2017
  describe "Verify that the user is properly navigated to the scoped to tenant if the tenant id is inserted in the URL of the browser" do
    if error == true
      $it_block_string = "Set the browser URL to 'https://xcs-#{$the_environment_used}.cloud.xirrus.com/?scope=#{tenant_id}##{area_url}' and verify the UI shows a proper error message"
    else
      $it_block_string = "Set the browser URL to 'https://xcs-#{$the_environment_used}.cloud.xirrus.com/?scope=#{tenant_id}##{area_url}'"
    end
    it "#{$it_block_string}" do
      @browser.goto("https://xcs-#{$the_environment_used}.cloud.xirrus.com/?scope=#{tenant_id}##{area_url}") and @ui.css('#body').wait_until_present and sleep 2
      if error == true
        expect(@ui.css('.dialogOverlay.confirm')).to exist
        expect(@ui.css('.dialogOverlay .title span').text).to eq("Access Error")
        expect(@ui.css('.dialogOverlay .msgbody div').text).to eq("The requested domain is either invalid or you do not have access. The page will be reloaded to show the domain 'Adrian-Automation-Chrome-SteelConnect-Child-SELF-No-Profiles'.")
        @ui.click('._jq_dlg_btn')
        sleep 1
      end
    end
    it "Verify the following:
          - the URL is 'https://xcs-#{$the_environment_used}.cloud.xirrus.com/##{area_url}'
          - the tenant name is '#{tenant_name}'
          - the global title is '#{area_title}'" do
          expect(@browser.url).to eq("https://xcs-#{$the_environment_used}.cloud.xirrus.com/##{area_url}")
          if !area_url.include? "floorplans"            
            expect(@ui.css('#tenant_scope_options .text').attribute_value("title")).to eq(tenant_name)
          end              
          if area_title != "Analytics"
            expect(@ui.css('.globalTitle').text).to eq(area_title)
          end      
    end
  end
end

shared_examples "directly search for an ap using the url input of the browser" do |ap_sn, ap_name, failed_search| # US 5252 - Created on 25/09/2017
  describe "Verify that the user is properly navigated if an AP SN is inserted as the URL of the browser" do
    it "Set the browser url to 'https://www.xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{ap_sn}'" do
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{ap_sn}\")")
      #@browser.goto("https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{ap_sn}") and sleep 3
      sleep 3
    end
    it "Verify the following:
          - the location is 'My Network - APs tab - APs subtab'
          - the URL is 'https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{ap_sn}'" do
      expect(@ui.css('#arrays_grid')).to be_present
      expect(@ui.css('.commonTitle span').text).to eq("All Access Points")
      expect(@browser.url).to eq("https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps/#{ap_sn}")
      sleep 2
    end
    if failed_search == false
      it "Verify the following:
            - the grid si filtered to that one result
            - the search bubble shows '1' result
            - the details slideout is opened
            - the slideout contains the proper APs details" do
        expect(@ui.css('#arrays_grid table tbody tr .serialNumber a').text).to eq(ap_sn)
        proper_search_box = find_proper_search_box
        expect(proper_search_box.text_field(css: "input").value).to eq(ap_sn)
        expect(proper_search_box.element(css: ".bubble .count").text).to eq("1")
        expect(@ui.css('#profile_arrays_details_slideout')).to be_present
        expect(@ui.css('#profile_arrays_details_slideout .slideout_title .title').text).to eq(ap_name + " Details")
        expect(@ui.get(:input , {id: "edit_name"}).value).to eq(ap_name)
      end
      it "Close the details slideout" do
        @ui.click('#arraydetails_close_btn')
        @ui.css('#profile_arrays_details_slideout').wait_while_present
      end
    else
      it "Verify that the 'No Access Point Found' modal is displayed" do
        @ui.css('.confirm').wait_until_present
        expect(@ui.css('.confirm .title span').text).to eq("No Access Point Found")
        expect(@ui.css('.confirm .msgbody div').text).to eq("No Access Point found matching \"#{ap_sn}\"")
      end
      it "Close the modal" do
        @ui.click('#_jq_dlg_btn_0')
        @ui.css('.confirm').wait_while_present
      end
      it "Verify the following:
            - the grid shows the 'No results' search
            - the search bubble shows 0 results" do
        proper_search_box = find_proper_search_box
        expect(proper_search_box.text_field(css: "input").value).to eq(ap_sn)
        expect(proper_search_box.element(css: ".bubble .count").text).to eq("0")
        expect(@ui.css('#arrays_grid table tbody tr')).not_to exist
        expect(@ui.css('#arrays_grid .noresults')).to be_present
      end
    end
    it "Cancel the search and return the URL to the default value" do
      proper_search_box = find_proper_search_box
      find_proper_search_box.element(css: ".btn-clear").click
      find_proper_search_box.element(css: ".btn-clear").wait_while_present
      @browser.execute_script("window.location.replace(\"https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps\")")
      sleep 3
      #@browser.goto("https://xcs-#{$the_environment_used}.cloud.xirrus.com/#mynetwork/aps/aps") and sleep 2
    end
  end
end

shared_examples "ap slideout tag control is hidden" do |ap_sn, on_floorplans, floorplan_details| # US 5229 & 5230 - Created on 25/09/2017
  describe "Verify that on the AP with SN '#{ap_sn}', on the details slideout the Tag control is hidden and the Location control is read-only" do
    if on_floorplans == true
      go_to_floor_plans_area
      select_and_open_a_certain_buildings_editor(floorplan_details["Building Name"])
      it "Verify the AP modal features" do
        expect(@ui.css('.markerContainer .marker')).to be_present
        @ui.click('.markerContainer .marker')
        sleep 1
        expect(@ui.css('.floorplan_ap_popup.clicked')).to be_present
        verify_hash = Hash[".floorplan_ap_popup.clicked .header .title" => floorplan_details["AP Hostname"], ".floorplan_ap_popup.clicked .header .array_info" => floorplan_details["AP Model"]]
        verify_hash.keys.each do |key|
          expect(@ui.css(key).text).to eq(verify_hash[key])
        end
        verify_array = [".floorplan_ap_popup.clicked .radios .all", ".floorplan_ap_popup.clicked .radios .fiveghz", ".floorplan_ap_popup.clicked .radios .twofourghz", ".floorplan_ap_popup.clicked .settings .facedown .switch", ".floorplan_ap_popup.clicked .settings .orientation .needle", '.floorplan_ap_popup.clicked .functions .details', '.floorplan_ap_popup.clicked .functions .delete']
        verify_array.each do |css|
          expect(@ui.css(css)).to be_present
        end
      end
    end
    it "Open the slideout for the AP and , AP Location - visible but read-only" do
      if on_floorplans == true
        @ui.click('.floorplan_ap_popup.clicked .functions .details')
        sleep 2
        expect(@ui.css('.sidepanel-extension.active')).to be_present
        sleep 1
        @ui.click('#arraydetails-tab-general')
      else
        @ui.grid_action_on_specific_line("4", "a", ap_sn, "invoke")
        sleep 1
        @ui.click('#arraydetails_tab_general')
      end
      sleep 1
      expect(@ui.get(:span, {id: 'edit_profile'}).enabled?).to eq(true)
      expect(@ui.get(:text_field, { id: 'edit_name' }).enabled?).to eq(true)
    end
    it "Verify that on the AP config general page the AP tags control is HIDDEN" do
      expect(@ui.css('#profile_arrays_tags')).not_to be_present
    end
    it "Verify that on the AP config general page the AP LOCATION control is VISIBLE but READ-ONLY" do
      expect(@ui.css('xc-textinput')).to be_present
      #expect(@ui.get(:text_field, { id: 'edit_location' }).enabled?).to eq(false)
    end
    it "Close the slideout" do
      if on_floorplans == true
        @ui.click('.slideout-toggle') and @ui.css('.slideout-toggle').wait_while_present
      else
        @ui.click('#arraydetails_close_btn') and @ui.css('#arraydetails_close_btn').wait_while_present
      end
    end
  end
end

shared_examples "verify tags column not present in column selector" do |which_location, profile_name, what_column_missing| # US 5229 - Created on 25/09/2017
  describe "Verify that the 'Tags' column is not present in the column selector (or grid)" do
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
    it "Verify that the grid exists and has the proper features" do
      case which_location
        when "My Network - Access Points tab"
          expect(@ui.css('#mynetwork_arrays_grid_cp')).to be_present
          expect(@ui.css('.nssg-table')).to be_present
          verify_search_box(true)
          expect(@ui.css('.nssg-paging-selector-container')).to be_present
          expect(@ui.css('.nssg-paging-count')).to be_present
          expect(@ui.css('.nssg-refresh')).to be_present
        when "Profile - Access Points tab"
          expect(@ui.css('#profile_arrays_grid_cp')).to be_present
          expect(@ui.css('.nssg-table')).to be_present
          if @ui.css('.nssg-table tbody').trs.length != 0
            expect(@ui.css('.xc-search')).not_to be_present
          else
            expect(@ui.css('.xc-search')).to be_present
          end
          expect(@ui.css('.nssg-paging-selector-container')).to be_present
          expect(@ui.css('.nssg-paging-count')).to be_present
          expect(@ui.css('.nssg-refresh')).to be_present
      end
    end
    it "Verify the column picker entries" do
      case which_location
        when "My Network - Access Points tab"
          @ui.click('#mynetwork_arrays_grid_cp')
          sleep 1
          @ui.css('#mynetwork_arrays_grid_cp_modal').wait_until_present
        when "Profile - Access Points tab"
          @ui.click('#profile_arrays_grid_cp')
          sleep 1
          @ui.css('#profile_arrays_grid_cp_modal').wait_until_present
      end
      expect(@ui.css('#column_selector_restore_defaults')).to be_present
      @ui.click('#column_selector_restore_defaults')
      sleep 1
      case which_location
        when "My Network - Access Points tab"
          @ui.get(:lis , {css: '#mynetwork_arrays_grid_cp .lhs .select_list li'}).each do |li|
            expect(li.text).not_to eq(what_column_missing)
          end
          @ui.get(:lis , {css: '#mynetwork_arrays_grid_cp .rhs .select_list li'}).each do |li|
            expect(li.text).not_to eq(what_column_missing)
          end
        when "Profile - Access Points tab"
          @ui.get(:lis , {css: '#profile_arrays_grid_cp .lhs .select_list li'}).each do |li|
            expect(li.text).not_to eq(what_column_missing)
          end
          @ui.get(:lis , {css: '#profile_arrays_grid_cp .rhs .select_list li'}).each do |li|
            expect(li.text).not_to eq(what_column_missing)
          end
      end
    end
    it "Close the column picker" do
      @ui.click('#column_selector_modal_save_btn')
      sleep 1
      case which_location
        when "My Network - Access Points tab"
          @ui.css('#mynetwork_arrays_grid_cp_modal').wait_while_present
        when "Profile - Access Points tab"
          @ui.css('#profile_arrays_grid_cp_modal').wait_while_present
      end
    end
    it "Verify the default columns of the grid depending on the location '#{which_location}'" do
      case which_location
        when "My Network - Access Points tab"
          column_names = ["Check Box","Access Point Hostname","Serial Number","Profile","DHCP Pool","IP Address","Location","Status","Online","Expiration Date"]
          verify_existing_columns_names(column_names, 2)
        when "Profile - Access Points tab"
          column_names = ["Check Box","Access Point Hostname","Serial Number","DHCP Pool","IP Address","Location","Status","Online","Expiration Date"]
          verify_existing_columns_names(column_names, 2)
      end
    end
  end
end

shared_examples "new profile button hidden for steel connect domains" do # US 5231 - Created on 26/09/2017
  describe "For STEEL CONNECT domains the '+ New Profile' button is hidden" do
    it "Click on the Profiles header to open the Profiles DropDown list" do
      @ui.css("#header_nav_profiles").click and @ui.css("#view_all_nav_item").wait_until_present
    end
    it "Click on the View All Profiles hyperlink " do
      @ui.click("#view_all_nav_item") and @ui.css("#profiles_tiles_view_btn").wait_until_present
    end
    it "Ensure that the View Type is set to Tile" do
      @ui.click("#profiles_tiles_view_btn") and sleep 1
    end
    it "Expect that the '+ New Profile' button above the grid isn't visible" do
      expect(@ui.id('new_profile_btn')).not_to be_present
    end
    it "Click on the Profiles header to open the Profiles DropDown list and expect that the '+ New Profile' button on the drop menu isn't visible" do
      @ui.css("#header_nav_profiles").click and @ui.css("#view_all_nav_item").wait_until_present
      expect(@ui.id('header_new_profile_btn')).not_to be_present
    end
    it "Expect that the '+ New Profile' button above the grid isn't visible" do
      #### TO BE REMOVED ONCE THE US IS PROPERLY INTEGRATED ####
        @ui.click("#view_all_nav_item") and @ui.css("#profiles_tiles_view_btn").wait_until_present
      #### TO BE REMOVED ONCE THE US IS PROPERLY INTEGRATED ####
      expect(@ui.id('new_profile_tile')).not_to be_present
    end
  end
end

shared_examples "profile landing page overlay for entries is disabled" do
  describe "Verify that on the Profiles landing page, hovering over any entry available will NOT show the options overlay" do
    it "Go to the profiles landing page" do
      @ui.view_all_profiles
    end
    it "For all available entries hover over and verify that the edit buttons overlay is not displayed" do
      @ui.css("#profiles_list").wait_until_present
      @ui.get(:elements , {css: '#profiles_list .ko_container .tile a'}).each do |tile|
        tile.hover
        sleep 1
        expect(@ui.css('.overlay')).not_to be_visible
      end
    end
  end
end

shared_examples "profile settings should be read only for steel connect domains general tab" do |profile_name| # US 5232 - Created on 26/09/2017
  describe "For STEEL CONNECT domains several profile settings are read-only" do
    it "Go to the profile named '#{profile_name}'" do
       @ui.goto_profile(profile_name)
    end
    it "Ensure you are on the 'GENERAL' tab and open the 'Show Advanced' settings" do
      go_to_profile_tab("general") and sleep 1
      if @ui.css('#general_show_advanced').text != "Hide Advanced"
        @ui.click('#general_show_advanced') and sleep 1
      end
    end
    verify_controls_hash = Hash["Network Time Protocol" => "#has_NTPswitch", "Active Directory" => "#has_ADswitch", "Profile Name" => "#general_ntp_toggle .field:nth-of-type(1) xc-textinput", "Profile Description" => "#general_ntp_toggle .field:nth-of-type(2) xc-textinput", "Profile Country" => ".togglebox.nobg.full .field:nth-of-type(1) xc-dropdownlist", "Profile Timezone" => ".togglebox.nobg.full .field:nth-of-type(1) xc-dropdownlist", "NTP Basic Primary Server" => "#profile_config_basic_primaryserver", "NTP Basic Primary Authentication" => "#profile_config_basic_primaryauthentication a", "NTP Basic Primary Authentication KeyID" => "#profile_config_basic_primaryauthenticationkeyid", "NTP Basic Primary Authentication Key" => "#profile_config_basic_primaryauthenticationkey", "NTP Basic secondary Server" => "#profile_config_basic_secondaryserver", "NTP Basic secondary Authentication" => "#profile_config_basic_secondaryauthentication a", "NTP Basic secondary Authentication KeyID" => "#profile_config_basic_secondaryauthenticationkeyid", "NTP Basic secondary Authentication Key" => "#profile_config_basic_secondaryauthenticationkey", "Domain Administrator" => "#profile_config_basic_domain_administrator", "AD Domain Password" => "Domain Password:", "AD Domain Controller" => "Domain Controller (in FQDN format):", "AD Workgroup/Domain" => "Workgroup/Domain:", "AD Realm" => "Realm:"]
    verify_controls_hash.each do |key, value|
      it "Verify that the '#{key}' control is read-only" do
        if ["Profile Name", "Profile Description"].include? key
          expect(@ui.css(value + " span").attribute_value("class")).to include("xc-textinput-readonly")
        elsif ["Profile Country", "Profile Timezone"].include? key
          expect(@ui.css(value + " span").attribute_value("class")).to include("xc-dropdownlist-readonly")
        elsif key.include? "AD"
          expect(@ui.span(:text => value).parent.element(css: "input").attribute_value("readonly")).to eq("true")
        else
          expect(@ui.css(value).attribute_value("readonly")).to eq("true")
        end
      end
    end
  end
end

shared_examples "profile settings should be read only for steel connect domains ssids tab" do |profile_name| # US 5232 - Created on 26/09/2017
  describe "For STEEL CONNECT domains several profile settings are read-only" do
    it "Go to the profile named '#{profile_name}'" do
       @ui.goto_profile(profile_name)
    end
    it "Go to the 'SSIDs' tab" do
      go_to_profile_tab("ssids") and sleep 1
    end
    verify_controls_hash = Hash["+ NEW SSID button" => "profile_ssid_addnew_btn", "Show Advanced link" => "ssids_show_advanced", "Enable VLANs link" => "toggle_vlan"]
    verify_controls_hash.each do |key, value|
      it "Verify that the '#{key}' control does not exist or is read-only" do
        if @ui.id(value).exists?
          expect(@ui.get(:a, {id: value})).not_to be_visible
        end
      end
    end
    it "Verify that the SSIDs grid has '7' column" do
      expect(@ui.css('table thead tr').ths.length).to eq(7)
    end
    it "Verify that the SSIDs grid automatically shows the 'VLANs' column" do
      expect(@ui.css('table thead tr th:nth-child(3) .nssg-th-text').text).to eq("VLAN")
    end
    it "Expect that the 'VLAN' cells are formated as simple text" do
      expect(@ui.css('table thead tr th:nth-child(3)').attribute_value("class")).to include('nssg-th-text')
      expect(@ui.css('table thead tr th:nth-child(3)').attribute_value("class")).not_to include('nssg-th-tag')
      expect(@ui.css('table tbody tr td:nth-child(3)').attribute_value("class")).to include('nssg-td-text')
      expect(@ui.css('table tbody tr td:nth-child(3)').attribute_value("class")).to include('vlanOverrides')
      expect(@ui.css('table tbody tr td:nth-child(3)').attribute_value("class")).not_to include('nssg-td-tag')
      expect(@ui.css('table tbody tr td:nth-child(3)').attribute_value("class")).not_to include('nssg-td-action')
    end
  end
end

shared_examples "profile settings should be read only for steel connect domains network tab" do |profile_name| # US 5232 - Created on 10/11/2017
  describe "For STEEL CONNECT domains several profile settings are read-only" do
    it "Go to the profile named '#{profile_name}'" do
       @ui.goto_profile(profile_name)
    end
    it "Go to the 'Network' tab" do
      go_to_profile_tab("network") and sleep 1
    end
    it "Verify that the 'VLAN support' container is not displayed" do
      expect(@ui.css('#profile_config_network_enableVLAN')).not_to exist
    end
  end
end

shared_examples "verify options dropdown tool menu on steelconnect profiles" do |profile_name|
  describe "Verify that the 'options dropdown tools menu' is not displayed on SteelConnect profiles" do
    it "Verify that the element exists but is not visible" do
      @ui.goto_profile(profile_name)
      sleep 4
      expect(@ui.css(".profile_heading .tools_menu.drop_menu")).to exist
      expect(@ui.css(".profile_heading .tools_menu.drop_menu")).not_to be_visible
    end
  end
end