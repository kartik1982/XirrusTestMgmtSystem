require_relative "../../TS_Portal/local_lib/portal_lib.rb"

def navigate_to_the_portals_landing_page # Created on 15.05.2017
  it "Navigate to the Portals landing page" do # make sure it goes to the guestportals view
    # @ui.click('#header_logo') # click the header logo to navigate to the home screen
    sleep 2
    @ui.goto_all_guestportals_view #go to the portals landing page
  end
end

shared_examples "verify portal list view tile view toggle" do
  describe "Verify the portals landing page - List view / Tile view - toggle" do
    navigate_to_the_portals_landing_page
    it "Verify that the toggle button for the list view works properly" do
      plv = @ui.click('#guestportals_list_view_btn')
      pl = @ui.id('guestportals_list')
      pl.wait_until_present
      expect(pl.attribute_value("class")).to include("list")
    end
    it "Verify that the toggle button for the tile view works properly" do
      plv = @ui.click('#guestportals_tiles_view_btn')

      pl = @ui.id('guestportals_list')
      pl.wait_until_present
      expect(pl.attribute_value("class")).to include("tile")
    end
    it "Delete all the available portals from the grid" do
       a = @ui.css('#new_guestportal_tile')
       until (a.present?) do
          if !["firefox", "edge"].include? @browser_name.to_s
            @ui.css("#guestportals_list .tile #guestportals_tile_item_0").hover
          else
            #@ui.hover("#profiles_list .tile #profiles_tile_item_0")
            @ui.show_needed_control("#guestportals_list .tile:nth-child(1) .overlay")
          end
         sleep 1
         @ui.click('.overlay .deleteIcon')
         sleep 1
         @ui.click('#_jq_dlg_btn_1')
         sleep 1.5
         rescue_counter = 0
         if @ui.css('.error').exists?
          rescue_counter = rescue_counter+=1
          @browser.refresh
          sleep 1
          @ui.css('#guestportals_list').wait_until_present
          if rescue_counter == 5
            expect(rescue_counter).not_to eq(5)
          end
         end
       end
    end
  end
end

shared_examples "verify portal name, type and description" do |portal_name, portal_description, portal_type|
  it "goes to new portal config and has portal name and description" do
    # wait for the portal name to appear
    sleep 1
    pn = @ui.id("profile_name")
    pn.wait_until_present
    pt = @ui.css('#guestportal_config_general_view .innertab .title')
    pt.wait_until_present
  end
  it "Verifies that the browser url includes the string '/config'" do
    sleep 5
    expect(@browser.url).to include("/config")
  end
  it "Verifies that the portal name, portal description and portal type have the correct values" do
    portal_type_str = ""
    case portal_type
      when "onetouch"
         portal_type_str = "One-Click Access"
      when "self_reg"
         portal_type_str = "Self-Registration"
      when "ambassador"
         portal_type_str = "Guest Ambassador"
      when "onboarding"
         portal_type_str = "EasyPass Onboarding"
      when "voucher"
         portal_type_str = "EasyPass Voucher"
      when "personal"
         portal_type_str = "EasyPass Personal Wi-Fi"
      when "google"
         portal_type_str = "EasyPass Google"
      when "azure"
        portal_type_str = "Microsoft Azure"
      when "facebook"
        portal_type_str = "Facebook Wi-Fi"
      when "mega"
        portal_type_str = "Two-Way Portal"
    end
    pn = @ui.id("profile_name")
    pn.wait_until_present
    pt = @ui.css('#guestportal_config_general_view .innertab .title')
    pt.wait_until_present
    sleep 1
    # check portal name, type and description
    expect(pn.text).to eq(portal_name)
    expect(@ui.id("profile_description").text).to eq(portal_description)
    expect(pt.text).to eq(portal_type_str)
  end
end

shared_examples "add new portal modal" do |portal_name, portal_description, portal_type|
################### CAROUSEL PORTAL CREATION ###################
#  it "Presses the 'Next' button abd verify that the 'New Portal' page is displayed and that the portal carousel is visible" do
#    # press the 'Next' button
#    @ui.click('#newportal_next')
#    sleep 1
#    # expect the browser url to include the path 'newportal'
#    expect(@browser.url).to include('#guestportals/newportal')
#    sleep 0.5
#    expect(@ui.css('#guestportal_container .portal_carousel')).to exist
#    expect(@ui.css('#guestportal_container .portal_carousel')).to be_visible
#    sleep 1
#  end
################### CAROUSEL PORTAL CREATION ###################
  it "Presses the #{portal_type} tile to create the portal" do
    expect(@ui.css('#guestportals_newportal')).to be_visible
    sleep 0.5
    if portal_type != "mega"
      #@ui.css('#guestportals_newportal .portal_type.' + portal_type).wait_until_present
      @ui.css('#guestportals_newportal .' + portal_type).wait_until_present
      sleep 1
      #@ui.css('#guestportals_newportal .portal_type.' + portal_type).click
      @ui.css('#guestportals_newportal .' + portal_type).click
    else
      @ui.click('.mega_portal_selection button')
    end
    sleep 0.5
    expect(@ui.css('.portal_details.show')).to be_visible
################### ORIGINAL PORTAL CREATION ###################
#     get the type of the portal
#    if(portal_type == 'self_reg' || portal_type == 'ambassador' || portal_type == 'onetouch')
#      ph = @ui.css('#guestportals_newportal .portal_type.guest')
#      ph.hover
#      sleep 1
#    end
#    @ui.click('#guestportals_newportal .portal_type.' + portal_type)
################### ORIGINAL PORTAL CREATION ###################

################### CAROUSEL PORTAL CREATION ###################
#    carousel_entries = @ui.css("#guestportal_container .portal_carousel .slick-list .slick-track")
#    carousel_entries.wait_until_present
#    carousel_lenght = carousel_entries.divs.length
#    carousel_entry = 1
#
#    while (carousel_entry != carousel_lenght)
#      if (@ui.css('#guestportal_container .portal_carousel .slick-list .slick-track .slick-center .portal_type.' + portal_type).exists?)
#        sleep 0.5
#        if (portal_type == 'google')
#          @ui.css('#guestportal_container .portal_carousel .slick-list .slick-track div:nth-child(11) a').hover
#          sleep 0.5
#          @ui.css('#guestportal_container .portal_carousel .slick-list .slick-track div:nth-child(11) a').click
#        else
#          @ui.css('#guestportal_container .portal_carousel .slick-list .slick-track .slick-center .portal_type.' + portal_type).hover
#          sleep 0.5
#          @ui.css('#guestportal_container .portal_carousel .slick-list .slick-track .slick-center .portal_type.' + portal_type).click
#        end
#        break
#      end
#      @ui.css('#guestportal_container .portal_carousel .slick-next').click
#      carousel_entry += 1
#      sleep 2
#    end
################### CAROUSEL PORTAL CREATION ###################
  end
  it "Sets the value #{portal_name} in the Portal Name input box" do
    # wait for the modal to show up
    @ui.id("guestportals_newportal").wait_until_present
    sleep 0.5
    # set portal name
    expect(@ui.css('#guestportal_new_name_input')).to be_visible
    @ui.set_input_val("#guestportal_new_name_input", portal_name)
    sleep 0.5
  end
  it "Sets the value #{portal_description} in the Portal Description input box" do
    # set description
    expect(@ui.css('#guestportal_new_description_input')).to be_visible
    @ui.set_input_val('#guestportal_new_description_input', portal_description)
    sleep 0.5
  end
  it "Presses the 'Create' button" do
    sleep 0.5
    @ui.click('#newportal_next')
    sleep 2
    @ui.css('#guestportals_newportal').wait_while_present
    expect(@ui.css('#guestportals_newportal')).not_to be_visible
  end
  it_behaves_like "verify portal name, type and description", portal_name, portal_description, portal_type
end

shared_examples "create portal from tile" do |portal_name, portal_description, portal_type|
  describe "Create portal from New portal tile" do
    navigate_to_the_portals_landing_page
    it "Clicks on the New portal tile" do
      expect(@ui.id("new_guestportal_btn")).not_to be_visible # the "New portal" button should be hidden
      sleep 1
      @ui.click("#new_guestportal_tile")
    end
    it_behaves_like "add new portal modal", portal_name, portal_description, portal_type
  end
end

shared_examples "create portal from header menu" do |portal_name, portal_description, portal_type|
  describe "Create portal from header menu : #{portal_name}" do
    it "clicks on New portal button in portals header menu" do
      # open header portal menu
      sleep 1
      @ui.click("#header_nav_guestportals > span")
      sleep 1
      @ui.click("#header_new_guestportals_btn")
      sleep 1
    end

    it_behaves_like "add new portal modal", portal_name, portal_description, portal_type
  end
end

shared_examples "create portal from new portal button" do |portal_name, portal_description, portal_type|
  describe "Create portal from New portal button" do
    navigate_to_the_portals_landing_page
    it "Create portal from New portal button (portals View)" do
      @ui.click('#new_guestportal_btn') and sleep 2# click the "New portal" button
    end
    it_behaves_like "add new portal modal", portal_name, portal_description, portal_type
  end
end

shared_examples "duplicate portal from tile" do |portal_name, portal_description, portal_type|
  describe "Duplicate portal from tile" do
    before :all do
      # make sure it goes to the portals view
      @ui.goto_all_guestportals_view
      @portal_tile = @ui.guestportal_tile_with_name portal_name
    end
    it "Hover / Focus over portal tile to reveal overlay buttons" do
      if !["firefox", "edge"].include? @browser_name.to_s
        @portal_tile.hover # hover to cause the overlay buttons to appear
        @portal_tile.focus
      end
      @overlay_content = @ui.guestportal_tile_with_name_new(portal_name) + " .overlay"
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      sleep 1
    end
    it "Click duplicate icon on portal tile for #{portal_name}" do
      dup_btn = @portal_tile.element(:css => ".overlay .duplicateIcon") # find the duplicate button and click, make sure it's visible
      expect(dup_btn).to be_visible
      dup_btn.click
      sleep 1
    end
    it "Confirm dialog to go to duplicate portal" do
      @ui.confirm_dialog
    end
    it_behaves_like "verify portal name, type and description", "Copy of " + portal_name, portal_description, portal_type
  end
end

shared_examples "duplicate portal from portal menu" do |portal_name, portal_description, portal_type|
  describe "Duplicate portal from portal Menu" do
    before :all do
      navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,false) # make sure it goes to the portal
    end
    it "Click duplicate in portal menu for #{portal_name}" do
      @ui.click('#profile_menu_btn')
      @ui.click('#guestportal_duplicate_btn')
      @ui.confirm_dialog
    end
    it_behaves_like "verify portal name, type and description", "Copy of " + portal_name, portal_description, portal_type
  end
end

shared_examples "search for portal" do |portal_name|
  describe "Search for a portal" do
    before :all do
      # make sure it goes to the portals view
      @ui.goto_all_guestportals_view
    end
    it "Search for a portal named #{portal_name} and ensure it is contained in the results" do
      @ui.set_input_val("#guestportals_search_input", portal_name) # enter portal name in search box
      sleep 1
      portal_tiles = @ui.get(:elements, {css: "#guestportals_list .ui-sortable .tile"})
      portal_tiles.each {|tile|
          name = tile.element(:css => ".title").attribute_value("title")
          description = tile.element(:css => ".description").attribute_value("title")
          expect(name + "\n" + description).to include(portal_name)
      }
      @ui.set_input_val("#guestportals_search_input", "")
      sleep 1
    end
  end
end

shared_examples "delete portal from tile" do |portal_name|
  describe "Delete portal from tile" do
    before :all do
      @ui.goto_all_guestportals_view # make sure it goes to the portals view
      @portal_tile = @ui.guestportal_tile_with_name portal_name
    end
    it "Hover over portal tile to reveal overlay buttons for #{portal_name}" do
      if !["firefox", "edge"].include? @browser_name.to_s
        @portal_tile.hover  # hover to cause the overlay buttons to appear
        @portal_tile.focus
      end
      @overlay_content = @ui.guestportal_tile_with_name_new(portal_name) + " .overlay"
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      sleep 1
    end
    it "Click delete icon on portal tile" do
      delete_btn = @portal_tile.element(:css => ".overlay .deleteIcon") # find the delete button
      expect(delete_btn).to be_visible # make sure it's visible
      delete_btn.click # click the delete button
      sleep 1
    end
    it "Confirm the deletion" do
      @ui.confirm_dialog # confirm the deletion prompt
      @portal_tile.wait_while_present # make sure the portal is removed
    end
  end
end

shared_examples "delete portal from portal menu" do |portal_name|
  describe "Delete the portal named #{portal_name} from the portal Menu" do
    it "Navigate to the portal named : #{portal_name}" do
      navigate_to_portals_landing_page_and_open_specific_portal("tile",portal_name,false) # make sure it goes to the portal
    end
    it "Click delete in portal menu" do
      @ui.click('#profile_menu_btn')
      @ui.click('#guestportal_delete_btn')
      sleep 1
      @ui.confirm_dialog
    end
    it "Route back to portals List View" do
      Watir::Wait.until { @browser.url.end_with? "#guestportals" }
    end
    it "Verify that the portal #{portal_name} was removed from list" do
      pn = @ui.css("#portals_list .tile span[title='#{portal_name}']")
      pn.wait_while_present
    end
  end
end

shared_examples "verify limited time offer on portals" do
  describe "Verify the 'Limited Time Offer' for EasyPass Portals received on first login" do
   it "logout and login current user for first login" do
     @ui.logout()
     sleep 1
     @ui.login_without_url(@username, @password)
     sleep 2
     if @browser.elements(:css, "#toast-container .toast-warning").count >1
        @browser.element(:css, "#toast-container .toast-warning button").click
        sleep 1
      end
      expect(@ui.css('#toast-container .toast-warning')).to be_present
      expect(@ui.css('#toast-container .toast-warning .toast-title').text).to eq("EasyPass Expiration")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("Your EasyPass license is about to expire.")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("Your current license includes free Self-Registration, Ambassador and all other EasyPass portals until")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("only Self-Registration and Ambassador will remain available")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("To find out more about EasyPass licensing, contact Riverbed or visit us at")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("https://www.riverbed.com/products/xirrus/easy-pass-access.html")
      @ui.click("#toast-container .toast-warning button")
      sleep 1
      @ui.css('#toast-container .toast-warning').wait_while_present
    end
  end
end
shared_examples "verify limited time offer expired on portals" do
  describe "Verify the 'Limited Time Offer expired for EasyPass Portals received on first login" do
   it "logout and login current user for first login" do
     @ui.logout()
     sleep 1
     @ui.login_without_url(@username, @password)
     sleep 2
     if @browser.elements(:css, "#toast-container .toast-warning").count >1
        @browser.element(:css, "#toast-container .toast-warning button").click
        sleep 1
      end
      expect(@ui.css('#toast-container .toast-warning')).to be_present
      expect(@ui.css('#toast-container .toast-warning .toast-title').text).to eq("EasyPass Expiration")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("The EasyPass subscription for this account has expired.")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("Without an active subscription, users will only be able to access Self-Registration and Ambassador portals.")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("We highly recommend renewing your EasyPass subscription through your reseller to restore full access for all EasyPass portal types.")
      expect(@ui.css('#toast-container .toast-warning .toast-message').text).to include("If you have any questions for Cambium Networks, please contact our sales team at xirrusrenewals@cambiumnetworks.com.")
      @ui.click("#toast-container .toast-warning button")
      sleep 1
      @ui.css('#toast-container .toast-warning').wait_while_present
    end
  end
end
shared_examples "verify the portal creation modal" do
  describe "Verify the portal creation modal features" do
    it "Click on the '+ New portal' button in portals header menu" do
      @ui.click("#header_nav_guestportals > span")
      @ui.css("#header_new_guestportals_btn").wait_until_present
      @ui.click("#header_new_guestportals_btn")
      @ui.css('#guestportals_newportal').wait_until_present
    end
    it "Verify that the 'Self-Registration' and 'Guest Ambassador' portal tiles are accessible" do
      ["self_reg", "ambassador"].each do |portal_type|
        @ui.css('#guestportals_newportal .' + portal_type).wait_until_present
        @ui.css('#guestportals_newportal .' + portal_type).click
        @ui.css('.portal_details.show').wait_until_present
      end
    end
    it "Verify that all other portal types are 'locked' and are not accessible" do
      ["onetouch", "onboarding", "voucher", "personal", "google", "azure", "mega"].each do |portal_type|
        if portal_type != "mega"
          @ui.css('#guestportals_newportal .' + portal_type).wait_until_present
          expect(@ui.css('#guestportals_newportal .' + portal_type).parent.parent.parent.attribute_value("class")).to eq("button_container unlicensed")
          expect(@ui.css('#guestportals_newportal .' + portal_type).parent.parent.parent.element(:css => ".lock-icon")).to be_present
        else
          @ui.css('.mega_portal_selection').wait_until_present
          expect(@ui.css('.mega_portal_selection').attribute_value("class")).to eq("mega_portal_selection unlicensed")
          expect(@ui.css('.mega_portal_selection .lock-icon')).to be_present
        end
      end
    end
    it "Verify the user warning is 'Why are some of the portals locked?' and the upgrade message is 'EasyPass Guest Self-Registration and Ambassador portals are free to use. To get access to all EasyPass portals, a license is required.'" do
      expect(@ui.css("#guestportals_newportal .upgradeMessage .blue-outline-info-icon")).to be_present
      expect(@ui.css("#guestportals_newportal .upgradeMessage span").text).to eq("Why are some of the portals locked?")
      expect(@ui.css("#guestportals_newportal .upgradeMessage").attribute_value("title")).to eq("EasyPass Guest Self-Registration and Ambassador portals are free to use. To get access to all EasyPass portals, a license is required.")
    end
    it "Close the modal" do
      @ui.click('#guestportals_newportal_closemodalbtn')
      @ui.css('#guestportals_newportal').wait_while_present
    end
  end
end
shared_examples "verify the default landingpage and delete after" do |portal_name|
  describe "Verify the default landingpage is 'http://www.riverbed.com'" do
    it "The landing page should return 'http://www.riverbed.com' " do
      lp = @ui.get(:text_field, {id: "landingpage"})
        lp.wait_until_present
        expect(lp.value).to eq "http://www.riverbed.com"
     end
     it "Delete this portal '#{portal_name}'" do
      sleep 1
      @ui.delete_gap(portal_name)
     end
    end
  end 
