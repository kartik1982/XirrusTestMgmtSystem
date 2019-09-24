shared_examples "verify profile name and description" do |profile_name, profile_description, readonly|
  it "Go to #{profile_name} (new profile) config area and verify the name and description" do
    # wait for the profile name to appear
    pn = @ui.id("profile_name")
    pn.wait_until(&:present?)

    if (readonly)
      # readonly profiles go to arrays
      expect(@browser.url).to end_with("/arrays")
      # the readonly icon needs to be visible
      expect(@ui.css(".profile_heading .readonlyIcon")).to be_visible
      # the config tab needs to be hidden
      expect(@ui.id("profile_tab_config")).not_to exist
    else
      expect(@browser.url).to include("/config")
    end

    # check profile name and description
    expect(pn.text).to eq(profile_name)
    expect(@ui.id("profile_description").text).to eq(profile_description)
  end
end

shared_examples "add new profile modal" do |profile_name, profile_description, readonly|
  it "Create a new profile with the characteristics: name - #{profile_name} , description - #{profile_description}, readonly - #{readonly}" do
    # wait for the modal to show up
    @ui.id("profiles_new_modal").wait_until(&:present?)

    # set profile name
    pn = @ui.get(:text_field, {id: "profile_name_input"})
    pn.wait_until(&:present?)
    expect(pn.type).to eq("text")
    expect(pn.attribute_value("maxlength")).to eq("255")
    pn.set profile_name

    # set description
    @ui.set_textarea_val('.profile_description_input', profile_description)

    # if doing a read only profile click the switch
    if (readonly)
      @ui.css(".show_advanced_container > a").click
      @ui.css("#profile_readonly_switch .switch_label").click
      sleep 1
    end

    # click the create button
    @ui.get(:button, {id: "newprofile_create"}).click
  end

  it_behaves_like "verify profile name and description", profile_name, profile_description, readonly
end

shared_examples "create profile from header menu" do |profile_name, profile_description, readonly|
  describe "Create a new profile using the '+ New Profile' button from the header menu" do
    it "clicks on New Profile button in Profiles header menu" do
      # open header profile menu
      @ui.css("#header_nav_profiles > span").click
      @ui.id("header_new_profile_btn").click
    end

    it_behaves_like "add new profile modal", profile_name, profile_description, readonly
  end
end

shared_examples "create profile from tile" do |profile_name, profile_description, readonly|
  describe "Create a new profile using the '+ New Profile' tile from an empty profiles landing page"  do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
      # Searches for a string to ensure no items are displayed in the grid"
      #@ui.set_input_val('#profiles_search_input', "Ensure that the grid is empty !!!")
    end

    it "clicks New Profile tile" do
      new_profile_tile = @ui.id("new_profile_tile")
      new_profile_tile.wait_until(&:present?)

      # the "New Profile" button should  be hidden
      expect(@ui.id("new_profile_btn")).not_to be_visible

      # clicks on the + New Profile tile
      new_profile_tile.click
    end

    it_behaves_like "add new profile modal", profile_name, profile_description, readonly
  end
end

shared_examples "verify read-only icons" do |profile_name|
  it "Verify that the Read-only Profile tile has the read-only icon" do
    @ui.view_all_profiles
    pt = @ui.profile_tile_with_name profile_name
    ro_icon = pt.element(:css => ".default_static .readonlyIcon")
    expect(ro_icon).to be_visible

    ro_text = pt.element(:css => "a .readonly")
    expect(ro_text).to be_visible
  end

  it "Verify Read-only Profile in header Profiles menu has read-only icon" do
    @ui.header_profiles_link.click
    sleep 1

    pi = @ui.header_profiles_menu_item_with_name profile_name
    ro_icon = pi.element(:css => ".profile_icons .readonlyIcon")
    expect(ro_icon).to be_visible

    # close the menu with a second click
    @ui.header_profiles_link.click
  end
end

shared_examples "create read-only profile from header menu" do |profile_name, profile_description|
  describe "Create Read-only Profile from header menu " do
    it_behaves_like "create profile from header menu", profile_name, profile_description, true
    it_behaves_like "verify read-only icons", profile_name
  end
end

shared_examples "create profile from new profile button" do |profile_name, profile_description, readonly|
  describe "Create Profile from New Profile button" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
    end

    it "Create Profile from New Profile button (Profiles View)" do
      # click the "New Profile" button
      new_profile_btn = @ui.id("new_profile_btn")
      new_profile_btn.wait_until(&:present?)
      new_profile_btn.click
    end

    it_behaves_like "add new profile modal", profile_name, profile_description, readonly
  end
end

shared_examples "delete profile tile" do |profile_name|
  describe "Delete Profile tile" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
      @profile_tile = @ui.profile_tile_with_name profile_name
    end

    it "Hover over profile tile to reveal overlay buttons" do
      # hover to cause the overlay buttons to appear
      if !["firefox", "edge"].include? @browser_name.to_s
        @profile_tile.hover
      else
        @overlay_content = @ui.profile_tile_with_name_new(profile_name) + " .overlay"
        @browser.execute_script("$(\"#{@overlay_content}\").show()")
      end
      sleep 1
    end

    it "Click delete icon on Profile tile" do
      # find th delete button and click, make sure it's visible
      delete_btn = @profile_tile.element(:css => ".overlay .deleteIcon")
      expect(delete_btn).to be_visible
      delete_btn.click
      sleep 1
    end

    it "Confirm the deletion" do
      @ui.confirm_dialog

      # make sure it gets removed
      @profile_tile.wait_while_present
    end
  end
end

shared_examples "delete profile from profile menu" do |profile_name|
  describe "Delete Profile from Profile Menu" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Click delete in Profile menu" do
      @ui.delete_profile
    end

    it "Route back to Profiles List View" do
      Watir::Wait.until { @browser.url.end_with? "#profiles" }
    end

    it "Profile removed from list" do
      pn = @ui.css("#profiles_list .tile span[title='#{profile_name}']")
      pn.wait_while_present
    end
  end
end

shared_examples "duplicate profile tile" do |profile_name, profile_description, readonly|
  describe "Duplicate Profile tile" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
      @profile_tile = @ui.profile_tile_with_name profile_name
    end

    it "Hover over profile tile to reveal overlay buttons" do
      # hover to cause the overlay buttons to appear
      if !["firefox", "edge"].include? @browser_name.to_s
        @profile_tile.hover
      else
        @overlay_content = @ui.profile_tile_with_name_new(profile_name) + " .overlay"
        @browser.execute_script("$(\"#{@overlay_content}\").show()")
      end
      sleep 1
    end

    it "Click duplicate icon on Profile tile" do
      # find th duplicate button and click, make sure it's visible
      dup_btn = @profile_tile.element(:css => ".overlay .duplicateIcon")
      expect(dup_btn).to be_visible
      dup_btn.click
      sleep 1
    end

    it "Confirm dialog to go to duplicate profile" do
      @ui.confirm_dialog
    end

    it_behaves_like "verify profile name and description", "Copy of " + profile_name, profile_description, readonly
  end
end

shared_examples "duplicate profile from profile menu" do |profile_name, profile_description, readonly|
  describe "Duplicate Profile from Profile Menu" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end
    it "Click duplicate in Profile menu" do
      @ui.duplicate_profile
      sleep 1
    end
    it_behaves_like "verify profile name and description", "Copy of " + profile_name, profile_description, readonly
  end
end

shared_examples "duplicate read-only profile tile" do |profile_name, profile_description|
  describe "Duplicate Read-only Profile tile" do
    it_behaves_like "duplicate profile tile", profile_name, profile_description, true
  end
end

shared_examples "verify default profile" do |profile_name|
  before :all do
    # make sure it goes to the profiles view
    @ui.view_all_profiles
  end

  it "Verify first Profile tile as default" do
    @ui.clear_hover
    sleep 3 #give some time for tiles to reshuffle

    pt = @ui.first_profile_tile
    name = pt.element(:css => ".title").attribute_value("title")
    expect(name).to eq(profile_name)

    default_icon = pt.element(:css => ".default_static .defaultIcon")
    expect(default_icon).to be_visible
  end

  it "Verify first item in header Profiles menu as default" do
    @ui.header_profiles_link.click
    sleep 1

    pi = @ui.id("profiles_ddl_item_0")
    pi.wait_until(&:present?)

    name = pi.element(:css => ".title")
    expect(name.text).to eq(profile_name)

    default_icon = pi.element(:css => ".profile_icons .defaultIcon")
    expect(default_icon).to be_visible

    # close the menu with a second click
    @ui.header_profiles_link.click
  end
end

shared_examples "set default from profile tile" do |profile_name|
  describe "Set Default Profile tile" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
      @profile_tile = @ui.profile_tile_with_name profile_name
    end

    it "Hover over profile tile to reveal overlay buttons" do
      # hover to cause the overlay buttons to appear
      if !["firefox", "edge"].include? @browser_name.to_s
        @profile_tile.hover
      else
        @overlay_content = @ui.profile_tile_with_name_new(profile_name) + " .overlay"
        @browser.execute_script("$(\"#{@overlay_content}\").show()")
      end
      sleep 1
    end

    it "Click default icon on Profile tile" do
      # find th default button and click, make sure it's visible
      dup_btn = @profile_tile.element(:css => ".overlay .defaultIcon")
      expect(dup_btn).to be_visible
      dup_btn.click
      sleep 1
      @ui.confirm_dialog
      sleep 1
    end

    it_behaves_like "verify default profile", profile_name
  end
end


shared_examples "verify profile list view tile view toggle" do
  describe "Verify profile list view tile view toggle" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
    end

    it "Verify list view toggle" do
      plv = @ui.id('profiles_list_view_btn')
      plv.wait_until(&:present?)
      plv.click
      sleep 1
      pl = @ui.id('profiles_list')
      pl.wait_until(&:present?)
      expect(pl.attribute_value("class")).to include("list")
    end

    it "Verify tile view toggle" do
      plv = @ui.id('profiles_tiles_view_btn')
      plv.wait_until(&:present?)
      plv.click
      sleep 1
      pl = @ui.id('profiles_list')
      pl.wait_until(&:present?)
      expect(pl.attribute_value("class")).to include("tile")
    end
  end
end

shared_examples "set default profile from profile menu" do |profile_name|
  describe "Set Default Profile from Profile Menu" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Click default in Profile menu" do
      @ui.assign_as_default
      sleep 1
      @ui.confirm_dialog
    end

    it_behaves_like "verify default profile", profile_name
  end
end

shared_examples "verify not default profile" do |profile_name|
  before :all do
    # make sure it goes to the profiles view
    @ui.view_all_profiles
  end

  it "Verify the profile tile is not default" do
    @ui.clear_hover
    sleep 3 #give some time for tiles to reshuffle

    pt = @ui.profile_tile_with_name profile_name
    default_icon = pt.element(:css => ".default_static .defaultIcon")
    expect(default_icon).not_to be_visible
  end

  it "Verify the Profile is not default in header Profiles menu" do
      @ui.header_profiles_link.click
      sleep 1

      pi = @ui.id("profiles_ddl_item_0")
      pi.wait_until(&:present?)

      default_icon = pi.element(:css => ".profile_icons .defaultIcon")
      default_icon.wait_while_present

      # close the menu with a second click
      @ui.header_profiles_link.click
  end
end

shared_examples "unset default from profile tile" do |profile_name|
  describe "Unset Default Profile tile" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
      @profile_tile = @ui.profile_tile_with_name profile_name
    end

    it "Hover over profile tile to reveal overlay buttons" do
      # hover to cause the overlay buttons to appear
      if !["firefox", "edge"].include? @browser_name.to_s
        @profile_tile.hover
      else
        @overlay_content = @ui.profile_tile_with_name_new(profile_name) + " .overlay"
        @browser.execute_script("$(\"#{@overlay_content}\").show()")
      end
      sleep 1
    end

    it "Click default icon on Profile tile" do
      # find th default button and click, make sure it's visible
      default_icon = @profile_tile.element(:css => ".overlay .defaultIcon")
      expect(default_icon).to be_visible
      default_icon.click
      sleep 1
      @ui.confirm_dialog
      sleep 1
    end

    it_behaves_like "verify not default profile", profile_name
  end
end

shared_examples "unset default profile from profile menu" do |profile_name|
  describe "Unset Default Profile from Profile Menu" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Click unassign default in Profile menu" do
      @ui.assign_as_default
      sleep 1
      @ui.confirm_dialog
    end

    it_behaves_like "verify not default profile", profile_name
  end
end

shared_examples "search for profile" do |profile_name|
  describe "Search for a profile" do
    before :all do
      # make sure it goes to the profiles view
      @ui.view_all_profiles
    end

    it "Search for a profile and ensure it is contained in the results" do
      # enter profile name in search box
      ps = @ui.get(:text_field, {id: "profiles_search_input"})
      ps.wait_until(&:present?)
      ps.set profile_name
      sleep 1

      profile_tiles = @ui.get(:elements, {css: "#profiles_list .ui-sortable .tile"})
      profile_tiles.each {|tile|
          name = tile.element(:css => ".title").attribute_value("title")
          description = tile.element(:css => ".description").attribute_value("title")
          expect(name + "\n" + description).to include(profile_name)
      }

      ps.set ''
      sleep 1
    end
  end
end

shared_examples "create read-only profile from tile" do |profile_name, profile_description|
  describe " Create a read-only profile from the +New Profile tile" do
    sleep 2
    it_behaves_like "delete all profiles from the grid"
    sleep 2
    it_behaves_like "create profile from tile", profile_name, profile_description, true
    sleep 2
    it_behaves_like "verify read-only icons", profile_name
    sleep 2

  end
end

shared_examples "create read-only profile from new profile button" do |profile_name, profile_description|
  describe "Create a read-only profile from the +New Profile button" do
    sleep 2
    it_behaves_like "create profile from new profile button", profile_name, profile_description, true
    sleep 2
    it_behaves_like "verify read-only icons", profile_name
    sleep 2
    it_behaves_like "delete all profiles from the grid"
    sleep 2
  end
end

shared_examples "delete all profiles when switch present" do
  describe "delete all profile from tile when switch is present" do    
    it "Delete all entries from the grid" do
      @ui.go_to_profile_tile(true)
      sleep 1
      a = @ui.css('#new_profile_tile')
      until (a.present?) do
        if !["firefox", "edge"].include? @browser_name.to_s
          @ui.css("#profiles_list .tile #profiles_tile_item_0").hover
        end
        @ui.show_needed_control("#profiles_list .tile:nth-child(1) .overlay")
        sleep 1
        @ui.click('.overlay .deleteIcon')
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
        sleep 1.5
        if @ui.css('.error').exists?
          @browser.refresh
          sleep 1
          @ui.css("#profiles_list").wait_until(&:present?)
        end      
      end
    end
  end
end

shared_examples "Create profile from tile when switch present" do |profile_name, profile_description, readonly|
  describe "create new #{profile_name} from tile" do
  it "make sure new profile button clicked and panel present" do
    @ui.go_to_profile_tile(true)
    if @ui.css("#new_profile_tile").visible?
      @ui.css("#new_profile_tile").click
    else
      @ui.css("#new_profile_btn").click
    end
    sleep 1
  end  
  it_behaves_like "add new profile modal", profile_name, profile_description, readonly
  end 
end

  
