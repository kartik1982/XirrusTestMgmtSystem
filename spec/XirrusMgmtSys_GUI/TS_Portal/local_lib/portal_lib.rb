def navigate_to_portals_landing_page_and_open_specific_portal(view_type,portal_name,scoped)
  if scoped == false
      @ui.click('#header_logo')
  end
  sleep 2
  @ui.click('#header_guestportals_arrow')
  sleep 1
  expect(@ui.css('#header_guestportals_arrow .guestportals_nav')).to be_visible
  sleep 0.5
  expect(@ui.css('#header_guestportals_arrow .guestportals_nav .nav_item')).to exist
  expect(@ui.css('#header_guestportals_arrow .guestportals_nav .nav_item')).to be_visible
  @ui.click('#header_guestportals_arrow .guestportals_nav #view_all_nav_item')
  sleep 3
  expect(@browser.url).to include("/#guestportals")
  sleep 2
  if view_type == "tile"
    if !@ui.css('#guestportals_tiles_view_btn').attribute_value("class").include?("selected")
      @ui.click('#guestportals_tiles_view_btn')
    end
  elsif view_type == "list"
    if !@ui.css('#guestportals_list_view_btn').attribute_value("class").include?("selected")
      @ui.click('#guestportals_list_view_btn')
    end
  end
  sleep 1
  portals_length = @ui.get(:lis , {css: "#guestportals_list .ko_container .tile"}).length
  while portals_length != 0
    if @ui.css("#guestportals_list .ko_container .tile:nth-child(#{portals_length}) a .title").text == portal_name
      if view_type == "list"
        @ui.css("#guestportals_list .ko_container .tile:nth-child(#{portals_length}) a .description").click
      else
        @ui.css("#guestportals_list .ko_container .tile:nth-child(#{portals_length}) a .title").click
      end
      @portal_found = true
      break
    end
    portals_length-=1
  end
  expect(@portal_found).not_to be_falsey
  sleep 3
  expect(@ui.css('#profile_name').text).to eq(portal_name)
end

shared_examples "verify second tab general features" do |portal_type|
  describe "Verify the second tab for the portal type '#{portal_type.upcase}' - GENERAL FEATURES" do
    it "Go to the second tab" do
      @ui.click('#profile_tabs a:nth-child(2)')
      sleep 2
      expect(@browser.url).to include('/#guestportals/')
      if ["self_reg", "ambassador"].include? portal_type
        expect(@browser.url).to include("/guests")
      elsif ["onboarding"].include? portal_type
        expect(@browser.url).to include("/users")
      elsif portal_type == "personal"
        expect(@browser.url).to include("/pssids")
      else
        expect(@browser.url).to include("/#{portal_type}")
      end
    end
    if !["personal", "onboarding", "onetouch", "voucher"].include? portal_type
      it "Set the table view to default" do
        if portal_type == "self_reg" or portal_type == "ambassador"
          @ui.click('#guestportal_guests_grid_cp')
          sleep 2
          expect(@ui.css('#guestportal_guests_grid_cp_modal')).to be_visible
          expect(@ui.css('#column_selector_restore_defaults')).to be_visible
          @ui.click('#column_selector_restore_defaults')
          sleep 1
          @ui.click('#column_selector_modal_save_btn')
          sleep 2
          expect(@ui.css('#guestportal_guests_grid_cp_modal')).not_to be_visible
        else
          @ui.click('#manage_enterprise_grid_cp')
          sleep 2
          expect(@ui.css('#manage_enterprise_grid_cp_modal')).to be_visible
          expect(@ui.css('#column_selector_restore_defaults')).to be_visible
          @ui.click('#column_selector_restore_defaults')
          sleep 1
          @ui.click('#column_selector_modal_save_btn')
          sleep 2
          expect(@ui.css('#manage_enterprise_grid_cp_modal')).not_to be_visible
        end
      end
    else
      puts "Skipped 'Reverting to default view' because the grid isn't editable on '#{portal_type}'"
    end
    it "Verify the table columns" do
      case portal_type
        when "self_reg"
          columns = Hash[3 => "Guest Name", 4 => "Email", 5 => "Mobile", 6 => "Note", 7 => "Opt in", 8 => "State", 9 => "Activation", 10 => "Expiration"]
          sortable = [3,4,5,6,9,10]
        when "ambassador"
          columns = Hash[3 => "Guest Name", 4 => "Email", 5 => "Mobile", 6 => "Note", 7 => "State", 8 => "Activation", 9 => "Expiration"]
          sortable = [3,4,5,6,8,9]
        when "onetouch"
          columns = Hash[3 => "MAC Address", 4 => "Activation", 5 => "Expiration"]
          sortable = [3,4,5]
        when "onboarding"
          columns = Hash[3 => "Name", 4 => "Group", 5 => "User ID", 6 => "User-PSK", 7 => "Email", 8 =>"Note", 9 => "Registered Devices", 10 => "Activation", 11 => "Expiration"]
          sortable = [3,4,5,6,8,9,10,11]
        when "voucher"
          columns = Hash[3 => "Access Code", 4 => "State", 5 => "Registered Devices", 6 => "Activation", 7 => "Expiration"]
          sortable = [3,5]
        when "personal"
          columns = Hash[3 => "Personal SSID Name", 4 => "Access Point", 5 => "Profile", 6 => "Broadcast", 7 => "Status", 8 => "Created", 9 => "Expiration", 10 => "MAC Address", 11 => "Personal ID"]
          sortable = [3,4,6,9]
        when "google"
          columns = Hash[3 => "First Name", 4 => "Last Name", 5 => "Gender", 6 => "Age", 7 => "Locale", 8 => "Email", 9 => "Registered Devices"]
          sortable = [8,9]
        when "azure"
          columns = Hash[3 => "Email", 4 => "Registered Devices"]
          sortable = [3,4]
      end
      sleep 1
      (3..columns.length).each do |i|
        if sortable.include? i
          expect(@ui.css(".nssg-table .nssg-thead-tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-sortable")
        end
        expect(@ui.css(".nssg-table .nssg-thead-tr th:nth-child(#{i}) .nssg-th-text").text).to eq(columns[i])
      end
    end
    #if ["google", "voucher", "onetouch", "onboarding", "personal", "ambassador", "self_reg"].include? portal_type
      it "Verify that the table contains the 'Refresh' button" do
        expect(@ui.css('.nssg-refresh')).to be_present
      end
    #else
     # puts "Skipped verifing the 'Refresh' button because it does not exist on '#{portal_type}'"
    #end
  end
end

shared_examples "verify facebook portal enabled disabled" do |status|
  describe "Verify that the FACEBOOK portal type is '#{status}'" do
    it "Open the 'Add new portal' modal and verify that the FACEBOOk type tile is visible but '#{status}'" do
      @ui.click("#header_nav_guestportals > span")
      sleep 1
      @ui.click("#header_new_guestportals_btn")
      sleep 1
      expect(@ui.css('#guestportals_newportal')).to be_visible
      if status == "disabled"
        expect(@ui.css('.facebook.disabled')).to be_present
        expect(@ui.css('.facebook.disabled .icon.asteriskIcon.technology-warn')).to be_present
        sleep 0.5
        @ui.css('.facebook.disabled .icon.asteriskIcon.technology-warn').hover
        sleep 1
        expect(@ui.css('.ko_tooltip_content_template .ko_tooltip_content').text).to eq("This feature is only available on Technology firmware.\nTo enable use of Technology firmware click here to go to firmware settings.")
      elsif status == "enabled"
        expect(@ui.css('.facebook.disabled')).not_to exist
        expect(@ui.css('.facebook')).to be_present
        #expect(@ui.css('.portal_type.facebook .icon.asteriskIcon.technology-warn')).to be_present
        #sleep 0.5
        #@ui.css('.portal_type.facebook .icon.asteriskIcon.technology-warn').hover
      end
    end
    it "Close the 'Add new portal' modal" do
      @ui.click('#guestportals_newportal_closemodalbtn')
      sleep 2
      expect(@ui.css('#guestportals_newportal')).not_to be_visible
    end
  end
end