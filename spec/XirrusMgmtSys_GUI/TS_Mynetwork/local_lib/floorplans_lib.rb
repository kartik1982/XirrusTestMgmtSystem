def go_to_floor_plans_area
  it "(If needed) Go to the 'Floor Plans' area" do
    if @browser.url.include?("/floorplans") != true
      sleep 3
      @ui.click('#header_mynetwork_link')
      sleep 6
      @ui.click('#mynetwork_tab_locations')
      sleep 1
    else
      @browser.refresh
    end
  end
end

def select_and_open_a_certain_buildings_editor(building_name)
  it "Select and open the building editor" do
    pt = @ui.id("locations_list")
    pt.wait_until_present
    pt = pt.element(:css => ".tile span[title='" + building_name + "']")
    sleep 0.5
    tile = pt.parent.parent
    sleep 1
    tile.click
  end
end

def press_the_done_button
  it "Press the 'DONE' button" do
    @ui.click('#fp_done')
    sleep 3
    expect(@browser.url).to include("#mynetwork/floorplans")
    expect(@browser.url).not_to include("#mynetwork/floorplans/")
  end
end

def open_close_the_slideout_menu(action)
  it "Open the slideout menu" do
    if !@ui.css('.mapSlideout').attribute_value("class").include?("active")
      slideout_toggles = @ui.get(:buttons , {css: ".mapSlideout .slideout-toggle"})
      expect(slideout_toggles.length).to eq(2)
      slideout_toggles.each do |slideout_toggle|
        if slideout_toggle.visible? == true
          slideout_toggle.click
          break
        end
      end
      #@ui.click('.mapSlideout .slideout_icon')
      sleep 2
      if action == "close"
        expect(@ui.css('.mapSlideout .sidepanel').attribute_value("class")).not_to include("active")
      elsif action == "open"
        expect(@ui.css('.mapSlideout .sidepanel').attribute_value("class")).to include("active")
      end
    end
  end
end

def use_slideout_toggle
  slideout_toggles = @ui.get(:buttons , {css: ".mapSlideout .slideout-toggle"})
  expect(slideout_toggles.length).to eq(2)
  slideout_toggles.each do |slideout_toggle|
    if slideout_toggle.visible? == true
      slideout_toggle.click
      break
    end
  end
end

def slideout_menu_go_to_tab(tab)
  it "Go to the tab '#{tab}'" do
    case tab
      when "Floor Plans"
        @ui.click('#floorplan_tab_floorplans')
        sleep 2
        expect(@ui.css('#floorplan_tab_floorplans').attribute_value("class")).to include("selected")
      when "Access Points"
        @ui.click('#floorplan_tab_arrays')
        sleep 2
        expect(@ui.css('#floorplan_tab_arrays').attribute_value("class")).to include("selected")
      when "Filters"
        @ui.click('#floorplan_tab_filters')
        sleep 2
        expect(@ui.css('#floorplan_tab_filters').attribute_value("class")).to include("selected")
      when "Channels"
        @ui.click('#floorplan_tab_channels')
        sleep 2
        expect(@ui.css('#floorplan_tab_channels').attribute_value("class")).to include("selected")
    end
  end
end

def slideout_floorplans_verify_list(number)
  it "Verify Floorplans in the list (#{number})" do
    slideout_list = @ui.css('.floorplan_slideout .floorplans')
    floorplans_in_list = slideout_list.elements(:css => ".floorplan").length
    expect(floorplans_in_list).to eq(number)
  end
end

def editor_save_changes
  it "Press the 'SAVE' button and verify the values" do
    if @ui.css('#fp_save').enabled?
      @ui.click('#fp_save')
      sleep 3
      expect(@ui.css(".error")).not_to exist
    end
  end
end

shared_examples "verify floorplan list view tile view toggle" do
  describe "Verify floorplan list view tile view toggle" do
    go_to_floor_plans_area
    it "Verify the 'LIST VIEW' toggle" do
      sleep 2
      plv = @ui.click('#locations_list_view_btn')
      pl = @ui.id('locations_list')
      pl.wait_until_present
      expect(pl.attribute_value("class")).to include("list")
    end
    it "Verify the 'TILE VIEW' toggle" do
      plv = @ui.click('#locations_tiles_view_btn')
      pl = @ui.id('locations_list')
      pl.wait_until_present
      expect(pl.attribute_value("class")).to include("tile")
    end
  end
end

shared_examples "delete all floorplans from the grid" do
  describe "Delete all the Floor Plans that are present in the grid" do
    go_to_floor_plans_area
    it "Ensure that the View Type is set to Tile" do
      sleep 1
      @ui.click("#locations_tiles_view_btn")
    end
    it "Delete all entries from the grid" do
      sleep 1
      a = @ui.css('#new_location_tile')
      until (a.present?) do
        if !["firefox", "edge"].include? @browser_name.to_s
          @ui.css("#locations_list .tile .inner").hover
        #else
          #@ui.hover("#locations_list .tile #profiles_tile_item_0")
          #@ui.show_needed_control("#locations_list .tile:nth-child(1) .overlay")
        end
        @ui.show_needed_control("#locations_list .tile:nth-child(1) .overlay")
        sleep 1
        @ui.click('.overlay .deleteIcon')
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
        sleep 5
        if @ui.css('.error').exists?
          @browser.refresh
          sleep 1
          @ui.css("#locations_list").wait_until_present
        elsif @ui.css('.loading').exists?
          @ui.css(".loading").wait_while_present
        end
      end
    end
  end
end

shared_examples "create building" do |building_name, floor_name, image_name, several_floorplans, go_to_building|
  describe "create building" do
    go_to_floor_plans_area
    it "Create a building" do
      if @ui.css('#new_location_tile').visible? == false
        @ui.click('#new_location_btn')
      else
        @ui.click('#new_location_tile')
      end
      sleep 1
    end
    it "Set the building name as '#{building_name}'" do
      # set building name
      @ui.set_input_val("#newfloorplan_building_name", building_name)
      sleep 1
    end
    if several_floorplans == false
      it "Set the floor name as '#{floor_name}'" do
        @ui.set_input_val("#newfloorplan_floor_name_0","Floor 1")
        sleep 1
      end
      it "Add an image ('#{image_name}')" do
        file = Dir.pwd + image_name
        @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
        @browser.execute_script('$(\'input[type="file"]\').click()')
        sleep 1
        @browser.file_field(:css,"input[type='file']").set(file)
        sleep 1
      end
    else
      it "Create several floor plans (#{several_floorplans})" do
        several_floorplans.times do |several_floorplans_new|
          floor_name_new = floor_name + " #{several_floorplans_new.to_s}"
          if several_floorplans_new != 0
            @ui.click('#newfloorplan_add_floor')
            sleep 1
          end
          @ui.set_input_val("#newfloorplan_floor_name_" + several_floorplans_new.to_s , floor_name_new)
          sleep 1
          if several_floorplans_new == 0
            file = Dir.pwd + image_name
            @browser.execute_script('$(\'.floors .floor input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'.floors .floor input[type="file"]\').click()')
            sleep 1
            @browser.file_field(:css,".floors .floor input[type='file']").set(file)
            sleep 1
          else
            several_floorplans_new_new = several_floorplans_new + 1
            file = Dir.pwd + image_name
            @control_css = ".floors .floor:nth-child(#{several_floorplans_new_new}) input[type=\"file\"]"
            @browser.execute_script("$('#{@control_css}').css({\"opacity\":\"1\"})")
            @browser.execute_script("$('#{@control_css}').click()")
            sleep 1
            @browser.file_field(:css,".floors .floor:nth-child(#{several_floorplans_new_new}) input[type='file']").set(file)
            sleep 1
          end
        end
      end
    end
    it "Save the floorplan and go to the floorplan - '#{go_to_building}'" do
      @ui.click('#newfloorplan_done_button')
      sleep 3
      @ui.css('.dialogOverlay').wait_until_present
      sleep 3
      if go_to_building == false
        @ui.click('#_jq_dlg_btn_0')
      else
        @ui.confirm_dialog
      end
      sleep 1
    end
    if go_to_building != false
      it "Open the floor plans slideout" do
        if @ui.css('.loading').exists?
          if @ui.css('.loading').visible?
            @ui.css('.loading').wait_while_present
            sleep 2
          end
        end
        use_slideout_toggle
        #@ui.css('.mapSlideout .slideout-toggle').wait_until_present
        #sleep 1
        #@ui.click('.mapSlideout .slideout-toggle')
      end
      it "Verify the floor plan count on the slideout" do
        slideout_list = @ui.css('.mapSlideout .floorplan_slideout .floorplans')
        floorplans_in_list = slideout_list.elements(:css => ".floorplan").length
        if several_floorplans == false
          expect(floorplans_in_list).to eq(2)
        else
          expect(floorplans_in_list - 1).to eq(several_floorplans)
        end
        use_slideout_toggle
      end
      it "Verify that the floor plan image is correct" do
        expect(@ui.css('.imageContainer .floorImage').attribute_value("href")).to include($the_environment_used)
        expect(@ui.css('.imageContainer .floorImage').attribute_value("href")).not_to include("localhost")
      end
      press_the_done_button
    end
    it "Verify that the floor plan name is correct" do
      locations_list = @ui.id("locations_list")
      locations_list.wait_until_present
      locations_list = locations_list.element(:css => ".tile span[title='" + building_name + "']")
      sleep 0.5
      tile = locations_list.parent.parent
      sleep 1
      expect(tile).to be_visible
    end
    it "Verify that the floor plan count is correct" do
      locations_list = @ui.id("locations_list")
      locations_list.wait_until_present
      locations_list = locations_list.element(:css => ".tile span[title='" + building_name + "']")
      sleep 0.5
      floor_count = locations_list.parent
      if several_floorplans != false
        expect(floor_count.element(:css => ".count span:nth-child(1)").text).to eq(several_floorplans.to_s)
      else
        expect(floor_count.element(:css => ".count span:nth-child(1)").text).to eq("1")
      end
    end
    it "Verify that the floor plan image (Floor Plans landing page area) is correct" do
      locations_list = @ui.id("locations_list")
      locations_list.wait_until_present
      locations_list = locations_list.element(:css => ".tile span[title='" + building_name + "']")
      sleep 0.5
      tile = locations_list.parent.parent
      expect(tile.element(:css => '.img').attribute_value("style")).to include($the_environment_used)
      expect(tile.element(:css => '.img').attribute_value("style")).not_to include("localhost")
    end
  end
end

shared_examples "edit building" do |building_name, environment, scale_amout, scale_unit, address_search, address_verify|
  describe "Edit the building named '#{building_name}'" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    it "Edit the 'Define heading' option" do
      sleep 5
      @ui.click('.koCompass_needle')
      sleep 2
      @ui.click('.topLeft')
      sleep 2
    end
    it "Edit the 'Environment' option" do
      @ui.set_dropdown_entry('floorplan_environment_dropdown', environment)
      sleep 2
    end
    it "Edit the 'Scale' option" do
      @ui.click('.scale')
      sleep 2
      @ui.set_dropdown_entry('floorplan_distance_unit', scale_unit)
      sleep 2
      @ui.set_input_val('#floorplan_distance', scale_amout)
      sleep 2
      @ui.css('#setScale .orange').focus
      @ui.click('#setScale .orange')
      sleep 2
      @ui.click('.top_left_zoom_controls')
      sleep 2
      @ui.click('.editor')
      sleep 2
      @ui.click('.topLeft')
      sleep 2
    end
    it "Edit the 'Location' option using the search for (#{address_search})" do
      @ui.click('.address .value span')
      sleep 3
      @ui.click('.address .set')
      sleep 2
      @ui.css('.leaflet-control-mapbox-geocoder').wait_until_present
      @ui.click('.leaflet-control-mapbox-geocoder .leaflet-control-mapbox-geocoder-toggle')
      sleep 2
      @ui.set_input_val(".leaflet-control-mapbox-geocoder-form input", address_search)
      sleep 1
      @browser.send_keys :enter
      sleep 2
      @ui.click('.leaflet-control-mapbox-geocoder-results a:first-child')
      sleep 2
      @ui.click('.leaflet-control-zoom-in')
      sleep 2
      @ui.click('.leaflet-control-zoom-in')
      sleep 2
      @ui.click('.leaflet-control-zoom-in')
      sleep 2
      @ui.click('.leaflet-control-zoom-out')
      sleep 3
      @ui.click('.leaflet-draw-toolbar .leaflet-draw-draw-marker')
      sleep 2
      @ui.click('.map .leaflet-tile-container.leaflet-zoom-animated img:nth-child(3)')
      sleep 3
    end
    it "Return to the Editor and verify the address (#{address_verify})" do
      @ui.click('#fp_return')
      sleep 2
      expect(address_verify).to include(@ui.css('.address .value span').text.sub(/.*?,/, '').strip)
      #expect(@ui.css('.address .value span').text).to eq(address_verify)
    end
    it "Press the 'SAVE' button and verify the values" do
      @ui.click('#fp_save')
      sleep 2
      expect(@ui.css('.environment').text).to eq(environment)
      expect(@ui.css('.scale .mid').text).to_not eq('?')
      if scale_unit == "m"
        min = "0m"
        mid = ["0.3m","0.4m"]
        max = ["0.5m","0.6m","0.7m","0.8m"]
      elsif scale_unit == "ft"
        min = "0ft"
        mid = ["0.3ft","0.4ft", "0.6ft"]
        max = ["0.5ft", "0.6ft", "0.7ft","0.8ft", "1.1ft"]
      end
      expect(@ui.css('.scale .min').text).to eq(min)
      expect(mid).to include(@ui.css('.scale .mid').text)
      expect(max).to include(@ui.css('.scale .max').text)
#      @ui.css('.koCompass_needle').hover
      @browser.execute_script('$(".compass.koCompass").addClass("hover")')
      sleep 1
      expect(@ui.css('.koCompass_degree:last-child span:first-child').text).not_to eq("")
      sleep 2
    end
    press_the_done_button
    it "Verify the 'Location' value outside of the editor" do
      locations_list = @ui.id("locations_list")
      locations_list.wait_until_present
      locations_list = locations_list.element(:css => ".tile span[title='" + building_name + "']")
      sleep 0.5
      location_string = locations_list.parent
      expect(address_verify).to include(location_string.element(:css => ".location span:nth-child(1)").text.sub(/.*?,/, '').strip)
      #expect(location_string.element(:css => ".location span:nth-child(1)").text).to eq(address_verify)
    end
  end
end

shared_examples "edit building opacity" do |building_name|
  describe "Verify the 'Editor' map opacity options" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Filters")
    it "Go to the 'Filters' tab, change and verify filter options" do
      @ui.click("#floorplan_filters_image_chk + .mac_chk_label")
      sleep 2
      expect(@ui.css('.floorImage').attribute_value("style")).to eq("opacity: 0;")
      @ui.click("#floorplan_filters_image_chk + .mac_chk_label")
      sleep 2
      expect(@ui.css('.floorImage').attribute_value("style")).to eq("opacity: 1;")
      @ui.set_input_val(".tab_contents .row .xc-range-text-text", "50")
      sleep 2
      expect(@ui.css('.floorImage').attribute_value("style")).to eq("opacity: 0.5;")
    end
    press_the_done_button
  end
end

shared_examples "edit building heatmap" do |building_name|
  describe "Verify the 'Editor' HeatMap options" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Filters")
    it "Go to the 'Filters' tab, enable HeatMap and verify the opacity value" do
      @ui.click("#floorplan_filters_heatmap_chk + .mac_chk_label")
      sleep 2
      @ui.set_input_val(".tab_contents .heatmap .xc-range-text-text", "75")
      sleep 2
      expect(@ui.css('.floorplan_editor .attenuation')).to be_present
      expect(@ui.css('.floorplan_editor .attenuation').attribute_value("style")).to eq("opacity: 0.75;")
      @ui.click("#floorplan_filters_heatmap_chk + .mac_chk_label")
      sleep 2
      expect(@ui.css('.heatImage').attribute_value("style")).to eq("opacity: 0;")
      expect(@ui.css('.floorplan_editor .attenuation')).not_to be_visible
      expect(@ui.css('.floorplan_editor .attenuation').attribute_value("style")).to eq("opacity: 0.75; display: none;")
      @ui.set_input_val(".tab_contents .heatmap .xc-range-text-text", "50")
      sleep 2
      @ui.click("#floorplan_filters_heatmap_chk + .mac_chk_label")
      sleep 2
      expect(@ui.css('.floorplan_editor .attenuation')).to be_present
      expect(@ui.css('.floorplan_editor .attenuation').attribute_value("style")).to eq("opacity: 0.5;")
    end
    it "Change to all Bands and RSSI levels, verifying the proper image is loaded" do
      band_controls_hash = Hash["both" => "both","2dot4" => "two","5" => "five"]
      band_controls_hash.each do |band_key, band_value|
        @ui.click("#floorplan_filters_band_#{band_key}_chk + .mac_radio_label")
        sleep 1
        rssi_controls_hash = Hash["90" => "large","75" => "medium","65" => "small"]
        rssi_controls_hash.each do |key, value|
          @ui.click("#floorplan_filters_rssi_#{key}_chk + .mac_radio_label")
          sleep 2
          expect(@ui.css('.heatImage').attribute_value("href")).to include("heat-#{band_value}-#{value}")
        end
        sleep 1
      end
    end
    press_the_done_button
  end
end

shared_examples "delete first last floorplans" do |building_name, floorplans_number_before, what_order_to_delete, floorplans_number_after|
  describe "Delete the last/first floorplan assigned to a building" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Floor Plans")
    slideout_floorplans_verify_list(floorplans_number_before)
    it "Delete the available floorplans in '#{what_order_to_delete}' order" do
      floorplans_array = @ui.get(:elements, {css: ".floorplans .floorplan"})
      if what_order_to_delete == "descending"
        needed_index = floorplans_array.length-2
      elsif what_order_to_delete == "ascending"
        needed_index = 0
      end
      floorplans_array.each_with_index do |floorplan, i|
        if i == needed_index
          floorplan.hover
          sleep 2
          expect(floorplan.element(:css => '.rhsmenu .deleteIcon')).to be_present
          floorplan.element(:css => '.rhsmenu .deleteIcon').click
          sleep 3
          break
        end
      end
      sleep 3
      expect(@ui.css('.dialogOverlay.confirm')).to be_visible
      @ui.click('#_jq_dlg_btn_1')
      sleep 6
    end
    press_the_done_button
  end
end

shared_examples "edit building duplicate delete floorplan" do |building_name|
  describe "Using the 'Editor' duplicate then delete floorplans" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Floor Plans")
    slideout_floorplans_verify_list(2)
    it "Duplicate the Floor Plan" do
      @ui.click('.floorplans .floorplan.selected .rhsmenu .duplicateIcon')
      sleep 3
      expect(@ui.css('.floorplans .floorplan:nth-child(2)')).to exist
    end
    slideout_floorplans_verify_list(3)
    it "Delete the duplicated Floor Plan" do
      @ui.click('.floorplans .floorplan:nth-child(2)')
      sleep 2
      @ui.click('.floorplans .floorplan:nth-child(2) .rhsmenu .deleteIcon')
      sleep 3
      expect(@ui.css('.dialogOverlay.confirm')).to be_visible
      @ui.click('#_jq_dlg_btn_1')
      sleep 6
    end
    slideout_floorplans_verify_list(2)
    press_the_done_button
  end
end

def find_certain_array_in_list(array_name)
  arrays_list_entries = @ui.get(:elements, {css: ".geoarrays .row"})
  arrays_list_entries.each_with_index do |arrays_list_entry, i|
    i = i+1
    puts i
    if arrays_list_entry.element(:css => "label").text == array_name
      return [arrays_list_entry.element(:css => "input + .mac_chk_label"), i]
    end
  end
end

shared_examples "edit building set ap" do |building_name, array_name, ap_status|
  describe "Using the 'Editor' set an AP to the FloorPlan" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Access Points")
    it "Select the AP named '#{array_name}' in the list" do
      array_entry = find_certain_array_in_list(array_name)
      puts array_entry[0]
      puts array_entry[1]
      array_entry[0].click
      sleep 2
      @ui.mouse_down_on_element(".geoarrays .row:nth-child(#{array_entry[1]}) .mac_chk_label")
      sleep 2
      @ui.mouse_up_on_element('.floorImage')
      sleep 3
      if @ui.css('.confirm').exists? and @ui.css('.confirm').visible?
        @ui.click('#_jq_dlg_btn_0')
        sleep 3
      end
      use_slideout_toggle
      sleep 2
    end
    editor_save_changes
    it "Verify the AP status" do
      @browser.refresh
      sleep 5
      expect(@ui.css('.markerContainer .marker').attribute_value("href")).to include(ap_status)
    end
    press_the_done_button
  end
end

shared_examples "edit building delete ap" do |building_name|
  describe "Using the 'Editor' delete an AP from the FloorPlan" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    it "Select the first AP in the list" do
      @ui.click('.markerContainer .marker')
      sleep 2
      expect(@ui.css('.floorplan_ap_popup.clicked')).to be_present
      @ui.click('.floorplan_ap_popup .delete')
      sleep 3
      expect(@ui.css('.dialogOverlay')).to be_present
      @ui.click('#_jq_dlg_btn_1')
      sleep 3
      expect(@ui.css('.markerContainer')).to exist
      expect(@ui.css('.markerContainer .marker')).not_to exist
    end
    editor_save_changes
    press_the_done_button
  end
end

def rezolve_tags(new_tags)
  if new_tags.class.to_s.capitalize == "Array"
    array_of_tags = true
  else
    array_of_tags = false
  end
  if array_of_tags == true
    new_tags_new = ""
    new_tags.each do |tag|
      if new_tags.first == tag
        new_tags_new = new_tags_new.gsub!(/$/, "#{tag}")
      else
        new_tags_new = new_tags_new.gsub!(/$/, ", #{tag}")
      end
    end
  elsif array_of_tags == false
    new_tags_new = new_tags
  end
  return new_tags_new
end

shared_examples "edit building edit ap details" do |building_name, ap_hostname, model, verify, new_profile, new_hostname, new_location, new_tags, delete_tags|
  describe "Using the 'Editor' edit the AP '#{ap_hostname}' with" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    it "Verify the AP modal features" do
      expect(@ui.css('.markerContainer .marker')).to be_present
      @ui.click('.markerContainer .marker')
      sleep 1
      expect(@ui.css('.floorplan_ap_popup.clicked')).to be_present
      verify_hash = Hash[".floorplan_ap_popup.clicked .header .title" => ap_hostname, ".floorplan_ap_popup.clicked .header .array_info" => model]
      verify_hash.keys.each do |key|
        expect(@ui.css(key).text).to eq(verify_hash[key])
      end
      verify_array = [".floorplan_ap_popup.clicked .radios .all", ".floorplan_ap_popup.clicked .radios .fiveghz", ".floorplan_ap_popup.clicked .radios .twofourghz", ".floorplan_ap_popup.clicked .settings .facedown .switch", ".floorplan_ap_popup.clicked .settings .orientation .needle", '.floorplan_ap_popup.clicked .functions .details', '.floorplan_ap_popup.clicked .functions .delete']
      verify_array.each do |css|
        expect(@ui.css(css)).to be_present
      end
    end
    it "Open the AP details screen" do
      @ui.click('.floorplan_ap_popup.clicked .functions .details')
      sleep 2
      expect(@ui.css('.sidepanel-extension.active')).to be_present
    end
    if verify == false
      if new_profile != ""
        it "Change the AP to the profile '#{new_profile}'" do
          @ui.set_dropdown_entry("edit_profile", new_profile)
          sleep 1
        end
      end
      if new_hostname != ""
        it "Set the Hostname value tot '#{new_hostname}'" do
          @ui.set_input_val("#edit_name", new_hostname)
          sleep 1
        end
      end
      if new_location != nil
        it "Change the location to '#{new_location}'" do
          expect(@ui.css("#edit_location")).to be_present
          @ui.set_input_val("#edit_location", new_location)
          sleep 1
        end
      end
      if new_tags != ""
        it "Set the following tag(s): '#{new_tags}'" do
          @ui.click('#arrays_tag_btn')
          sleep 1
          expect(@ui.css('.sidepanel-extension.active .tag_button .tag_nav')).to be_visible
          expect(@ui.css('.sidepanel-extension.active .tag_button .tag_nav .search_wrap #profile_filter_tags_input')).to be_visible
          expect(@ui.css('.sidepanel-extension.active .tag_button .tag_nav .items')).to be_visible
          expect(@ui.css('.sidepanel-extension.active .tag_button .tag_nav .add #arrays_clients_add_tag_input')).to be_visible
          expect(@ui.css('.sidepanel-extension.active .tag_button .tag_nav .add #general_add_tag_btn')).to be_visible
          if new_tags.class.to_s.capitalize == "Array"
            new_tags.each do |tag|
              @ui.set_input_val('#arrays_clients_add_tag_input', tag)
              sleep 1
              @ui.click('#general_add_tag_btn')
              sleep 1
            end
          else
            @ui.set_input_val('#arrays_clients_add_tag_input', new_tags)
            sleep 1
            @ui.click('#general_add_tag_btn')
            sleep 1
          end
        end
      end
      if delete_tags != ""
        it "Delete the tag(s): '#{delete_tags}'" do
          css_string = "#profile_arrays_tags .tagControlContainer .tag.withDelete"
          if delete_tags.class.to_s.capitalize == "Array"
            delete_tags_new = delete_tags.sort
            delete_tags_new.each_with_index do |delete_tag, i|
              i = i+1
              css_string_new = css_string.sub("tag.withDelete", "tag.withDelete:nth-child(#{i}) .text")
              expect(@ui.css(css_string_new).text).to eq(delete_tag)
            end
            delete_tags.length.times do
              @ui.click(css_string + " .delete")
              sleep 1
            end
          else
            expect(@ui.css(css_string).text).to include(delete_tags)
            @ui.click(css_string + " .delete")
            sleep 1
          end
          expect(@ui.get(:elements, {css: css_string}).length).to eq(0)
        end
      end
      if [new_profile, new_hostname, new_location, new_tags].all? != ""
        it "Press the <SAVE> button" do
          expect(@ui.css('#array-details-save')).to be_present
          @ui.click('#array-details-save')
          sleep 2
        end
      end
    elsif verify == true
      it "Verify the AP details screen has the following values: '#{ap_hostname}','#{new_profile}','#{new_hostname}','#{new_location}','#{new_tags}'" do
        if new_tags.class.to_s.capitalize == "Array"
          @new_tags_length = new_tags.length
          @new_tags_texts = new_tags.sort
          puts @new_tags_texts
        else
          if new_tags != ""
            @new_tags_length = 1
          else
            @new_tags_length = 0
          end
          @new_tags_texts = new_tags
        end
        verify_hash = Hash[".array-details-title .title" => ap_hostname + " Details", ".array-details-desc" => "View/Edit the Access Point details.", ".arraydetails_general .title" => "General", ".arraydetails_general div:nth-child(2) .field_label" => "Profile:", "#edit_profile .text" => new_profile, ".arraydetails_general div:nth-child(3) .field_label" => "Hostname:", "#edit_name" => new_hostname, ".arraydetails_general div:nth-child(4) .field_label" => "Location:", "#edit_location" => new_location, ".arraydetails_general div:nth-child(5) .field_label" => "Tags:", "#profile_arrays_tags .tag_button" => "#arrays_tag_btn", "#profile_arrays_tags" => ".tagControlContainer", "#profile_arrays_tags .tagControlContainer .tag.withDelete" => @new_tags_length, "#profile_arrays_tags .tagControlContainer .tag.withDelete .text" => @new_tags_texts]
        verify_hash.keys.each do |key|
          if key == "#edit_location" or key == "#edit_name"
            expect(@ui.get(:input , {css: key}).value).to eq(verify_hash[key])
          elsif key.include? "#profile_arrays_tags"
            if key.include? ".withDelete"
              if key.include? ".text"
                  if @new_tags_length != 1
                    (1..verify_hash[key].length).each do |i|
                      i_new = i-1
                      key_new = key.sub("tag.withDelete .text", "tag.withDelete:nth-child(#{i}) .text")
                      expect(@ui.css(key_new).text).to eq(verify_hash[key][i_new])
                    end
                  elsif @new_tags_length == 0
                    expect(@ui.css(key).text).not_to exist
                  else
                    expect(@ui.css(key).text).to eq(verify_hash[key])
                  end
              else
                expect(@ui.get(:elements, {css: key}).length).to eq(verify_hash[key])
              end
            else
              expect(@ui.css(key + " " + verify_hash[key])).to be_present
            end
          else
            expect(@ui.css(key).text).to eq(verify_hash[key])
          end
        end
      end
    end
    it "Close the AP details screen and the slideout container" do
      @ui.click(".sidepanel-extension.active .slideout-toggle")
      sleep 2
      use_slideout_toggle
    end
    editor_save_changes
    press_the_done_button
  end
end

shared_examples "go to the dashboard and back to editor" do |building_name, ap_status, environment, scale_amout, scale_unit, address_verify|
  describe "Go to the Dashboard area and then back to the 'Editor' area" do
  go_to_floor_plans_area
  select_and_open_a_certain_buildings_editor(building_name)
  it "Go to the dashboard area and verify the proper location and AP" do
    map_id = nil
    map_id = @ui.css('.topLeftControls .topLeft div:nth-child(5) span:nth-child(2)').text
    sleep 1
    @ui.click('#fp_gotodashboard')
    sleep 3
    expect(@browser.url).not_to include("#mynetwork/overview/map/#{map_id}")
    expect(@ui.css('.markerContainer')).not_to exist
    #expect(@ui.css('.markerContainer .marker').attribute_value("href")).to include(ap_status)
  end
=begin
  it "Verify the 'View on map' details" do
    expect(@ui.css('.environment').text).to eq(environment)
    expect(@ui.css('.scale .mid').text).to_not eq('?')
    if scale_unit == "m"
      min = "0m"
      mid = "0.7m"
      max = "1.4m"
    elsif scale_unit == "ft"
      min = "0ft"
      mid = ["0.7ft", "1.1ft"]
      max = ["1.4ft", "2.1ft"]
    end
    expect(@ui.css('.scale .min').text).to eq(min)
    expect(mid).to include(@ui.css('.scale .mid').text)
    expect(max).to include(@ui.css('.scale .max').text)
    expect(address_verify).to include(@ui.css('.address .value').text)
    #@ui.css('.koCompass_needle').hover
    @browser.execute_script('$(".compass.koCompass").addClass("hover")')
    sleep 1
    expect(@ui.css('.koCompass_degree:last-child span:first-child').text).not_to eq("")
    sleep 2
  end
  it "Go back to the 'Editor' area" do
    sleep 1
    @ui.click('.bottomLeftControls .gotoedit')
    sleep 3
    map_id = @ui.css('.topLeftControls .topLeft div:nth-child(5) span:nth-child(2)').text
    expect(@browser.url).to include("#mynetwork/floorplans/#{map_id}/1")
  end
=end
  go_to_floor_plans_area
  select_and_open_a_certain_buildings_editor(building_name)
  press_the_done_button
  end
end

shared_examples "verify channels" do |building_name| #Created on 31/05/2017
  describe "Verify the AP Channels control" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
#    it "Verify the 'Channels' button" do
#      expect(@ui.css('#floorplan_channels')).to be_present
#      @ui.css('#floorplan_channels').hover
#      sleep 2
#      expect(@ui.css('#floorplan_channels').attribute_value("class")).to include('ko_tooltip_active')
#      expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq("Click to toggle channels view")
#      @ui.click('#floorplan_channels')
#      sleep 2
#      expect(@ui.css('#floorplan_channels').attribute_value("class")).to include(' active')
#      expect(@ui.css('.imageContainer .channelBubblesContainer circle')).to be_present
#      expect(@ui.css('.imageContainer .markerContainer').attribute_value("style")).to eq('display: none;')
#      @ui.click('#floorplan_channels')
#      sleep 2
#      expect(@ui.css('#floorplan_channels').attribute_value("class")).not_to include(' active')
#      expect(@ui.css('.imageContainer .markerContainer').attribute_value("style")).to eq('display: inline;')
#      expect(@ui.css('.imageContainer .channelBubblesContainer')).not_to be_present
#    end
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Channels")
    it "Verify the slideout tab (Channels)" do
      expect(@ui.css('.floorplan-sidepanel-content-inner .tab_contents .title').text).to eq('Channels')
      expect(@ui.css('.floorplan-sidepanel-content-inner .tab_contents .channels-icon-desc').text).to eq('Channels used by multiple Access Points')
      expect(@ui.css('.floorplan-sidepanel-content-inner .tab_contents .channels-container')).to exist
    end
    open_close_the_slideout_menu("close")
    press_the_done_button
  end
end

shared_examples "delete building from tile" do |building_name|
  describe "Delete building from tile" do
    it "Delete building" do
      if @ui.css('.dialogOverlay.confirm').exists?
        @ui.click('#_jq_dlg_btn_0')
        sleep 2
      end
      @ui.click('#header_mynetwork_link')
      sleep 1
      @ui.click('#mynetwork_tab_locations')
      sleep 1
      @ui.css('#locations_list').wait_until_present
      floorplans_length = @ui.css('#locations_list .ko_container').lis.length
      (1..floorplans_length).each do |floorplans_index|
        @css_value = "#locations_list .ko_container .tile:nth-child(#{floorplans_index})"
        if @ui.css(@css_value + " .title[title='#{building_name}']").exists?
          break
        end
      end
      puts @css_value
      @ui.css(@css_value).hover
      sleep 1
      #expect(@ui.css(@css_value + " .overlay .content")).to be_present
      @ui.click(@css_value + " .overlay .content .deleteIcon")
      sleep 2
      @ui.confirm_dialog
      @ui.css(@css_value + " .title[title='#{building_name}']").wait_while_present
    end
  end
end
shared_examples "verify Location Reporting on floor plan" do |building_name|
 describe "Verify Location reporting switch" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Filters")
   it "verify location reporting switch label" do
     expect(@ui.css('.geomap_filters .row_label span').text).to eq("Would you like to enable Location Reporting?")
   end
   it "verify location reporting default state" do
     expect(@ui.get(:checkbox, {id: 'floorplan_filters_location_enable_switch'}).set?).to eq(false)
   end
   it "verify that station and rogues button are inactive" do
     expect(@ui.css('.floorplan_btn.floorplan_showstations.disabled')).to exist
     expect(@ui.css('.floorplan_btn.floorplan_showrogues.disabled')).to exist
   end  
 end
end
shared_examples "Verify Location Reporting enable-disable" do |building_name|
  describe "Verify the 'Location reporting enable-disable' state" do
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Filters")
    sleep 2
    it "Verify Station and Rogues button when Enable location reporting" do
      @ui.click("#floorplan_filters_location_enable")
      sleep 2
      expect(@ui.get(:checkbox, {id: 'floorplan_filters_location_enable_switch'}).set?).to eq(true)
      expect(@ui.css('.floorplan_btn.floorplan_showstations.disabled')).not_to exist
      expect(@ui.css('.floorplan_btn.floorplan_showrogues.disabled')).not_to exist
    end
     it "Verify station and rogues when disable location reporting" do
      @ui.click("#floorplan_filters_location_enable")
      sleep 2
      expect(@ui.get(:checkbox, {id: 'floorplan_filters_location_enable_switch'}).set?).to eq(false)
      expect(@ui.css('.floorplan_btn.floorplan_showstations.disabled')).to exist
      expect(@ui.css('.floorplan_btn.floorplan_showrogues.disabled')).to exist
    end
    it "Verify Enable Location reporting should auto save" do
      @ui.click("#floorplan_filters_location_enable")
      sleep 2
      expect(@ui.get(:checkbox, {id: 'floorplan_filters_location_enable_switch'}).set?).to eq(true)
      @ui.click('#fp_done')
      sleep 2
      expect(@ui.css('.dialogOverlay.confirm')).not_to exist
    end
  end  
end
shared_examples "Verify Rogue deatils pop-up on floor plan" do |building_name|
  describe "Verify Rogue deatils pop-up on floor plan" do
    rogues_mac=""
    go_to_floor_plans_area
    select_and_open_a_certain_buildings_editor(building_name)
    open_close_the_slideout_menu("open")
    slideout_menu_go_to_tab("Filters")
    sleep 2
    it "Enable location service so tht locate rogue button will be active" do
      if(!@ui.get(:checkbox, {id: 'floorplan_filters_location_enable_switch'}).set?)
        @ui.click("#floorplan_filters_location_enable")
        sleep 2
      end
    end
    it "Locate rogues and open visible rogue details pop-up" do
        @ui.css('#floorplan_showrogues').click
        sleep 1
        rogues_elements=@ui.get(:elements, {css: "svg .rogueMarkerContainer .rogueMarker"})
        rogues_elements.each{ |rogue|
          if(rogue.visible?)
            begin
            rogue.click
            break
            rescue
            puts "Unable to click element rogue"
          end
          end
        }        
     end
     it "Verify rogues pop-up panel on floorplan" do
      expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(1)').text).to eq("MAC Address:")
      rogues_mac=@ui.css('#rogue_macaddress').text
      # expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(3)').text).to eq("Device Class:")
      expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(3)').text).to eq("Source Hostname:")
      expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(5)').text).to eq("SSID:")
      expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(7)').text).to eq("Manufacturer:")
      expect(@ui.css('.floorplan_rogue_popup dl dt:nth-child(9)').text).to eq("Channel:")
      expect(@ui.css('.floorplan_rogue_popup a').text).to eq("Details...")      
    end
    it "Verify click Details hyperlink navigate to Rogues tab" do
      @ui.css('.floorplan_rogue_popup a').click
      sleep 2
      expect(@browser.url).to include("/#mynetwork/rogues/")
      expect(@ui.css('.nssg-table .nssg-tobdy tr td:nth-child(1) div').text).to eq(rogues_mac) 
      expect(@ui.get(:elements, {css: ".nssg-table .nssg-tobdy tr"}).length).to eq(1)      
    end
  end  
end