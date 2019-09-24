require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"

shared_examples "go to the rogues tab" do # US 5223 - Rogues ! Show additional information on rogues - Created on 26/09/2017
  describe "Go to the Rogues tab" do
    it "Press the 'Rogues sub tab button and wait for the tab to load" do
      @ui.click('#header_nav_mynetwork')
      sleep 3
      @ui.click('#mynetwork_tab_rogues') and sleep 2
      expect(@browser.url).to include("/#mynetwork/rogues")
    end
  end
end

shared_examples "general features" do # US 5223 - Rogues ! Show additional information on rogues - Created on 26/09/2017
  describe "Verify that the general features of the ROGUES tab are properly displayed" do
    verify_controls_hash = Hash[".rogues_tab .commonTitle" => "Rogues on your network", ".rogues_tab .commonSubtitle" => "View access points detected in the vicinity of your network.", "Export button" => "#mn-cl-export-btn", "Column Picker" => ".columnPickerIcon", "Search Input" => ".xc-search input", "Search Button" => ".xc-search .btn-search", "Search Clear" => ".xc-search .btn-clear", "Paging Pages" => ".nssg-paging .nssg-paging-pages", "Paging Count" => ".nssg-paging .nssg-paging-count", "Paging Controls" => ".nssg-paging .nssg-paging-controls", "Refresh button" => ".nssg-paging .nssg-refresh", "Table Header" => ".nssg-table thead:nth-of-type(2)", "Table Body" => ".nssg-table tbody"]
    verify_controls_hash.each do |key, value|
      it "Verify that the '#{key}' element properly exists" do
        if key.include? ".rogues_tab"
          expect(@ui.css(key)).to exist
          expect(@ui.css(key).text).to eq(value)
        elsif value == ".xc-search .btn-clear"
          expect(@ui.css(value)).to exist
        else
          expect(@ui.css(value)).to be_visible
        end
      end
    end
    it "Verify the tab text ('Rogues')" do
      expect(@ui.css('#mynetwork_tab_rogues').text).to eq("Rogues")
    end
    it "Restore default columns to the grid (verify all columns number)" do
      @ui.click('.columnPickerIcon') and @ui.css('.column_selector_modal').wait_until_present and sleep 1
      expect(@ui.css('.column_selector_modal .commonTitle').text).to eq("Select Columns") and expect(@ui.css('.column_selector_modal .commonSubtitle').text).to eq("Select column items you would like to show in the table.")
      @ui.click('#column_selector_restore_defaults') and sleep 1
      selected_items_list = @ui.css('#rhs_selector ul')
      list_length = selected_items_list.lis.length
      expect(list_length).to eq(7)
    end
    it "Restore default columns to the grid (verify all columns names)" do
      selected_items_list = @ui.css('#rhs_selector ul')
      list_length = selected_items_list.lis.length
      column_names = ["MAC Address (required)", "SSID", "Manufacturer", "Channel", "RSSI", "Time Discovered", "Last Seen"]
        begin
          list_length-=1
          li = selected_items_list.lis.select{|li| li.visible?}[list_length]
          column_name = column_names[list_length]
          puts li.text + " - should equal - " + column_name
          expect(li.text).to eq(column_name)

        end while (list_length > 0)
      sleep 1
    end
    it "Save the default columns" do
      @ui.click('#column_selector_modal_save_btn') and sleep 2
    end
    it "Verify all columns (number) present in the grid" do
      th_items_list = @ui.css('table thead:nth-child(2) tr')
      list_length = th_items_list.ths.length
      expect(list_length).to eq(8)
    end
    it "Verify all column names in the grid" do
      column_names = ["MAC Address", "SSID", "Manufacturer", "Channel", "RSSI", "Time Discovered", "Last Seen"]
      column_names.each_with_index do |column_name, i|
        i = i+=1
        expect(@ui.css("table thead:nth-of-type(2) tr th:nth-child(#{i}) .nssg-th-text").text).to eq(column_name)
      end
    end
    it "Verify that all columns are sortable" do
      th_items_list = @ui.css('table thead:nth-child(2) tr').ths
      th_items_list.each do |th|
        if !th.attribute_value("class").include?"gutter" and th.attribute_value("style") != "padding: 0px; border: 0px solid transparent; width: 0px;"
          expect(th.attribute_value("class")).to include("nssg-sortable")
          th.click
          sleep 1
          expect(th.attribute_value("class")).to include("nssg-sorted")
        end
      end
    end
  end
end

shared_examples "search for a certain rogue element" do |search_object, mandatory_found| # US 5223 - Rogues ! Show additional information on rogues - Created on 26/09/2017
  describe "Verify that the user can search for a rogue element from any available columns" do
    it "Set the view to '500' elements per page" do
      if (@ui.css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages').exists?)
        @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "500")
        sleep 4
      end
    end
    it "Search for the string '#{search_object}' and verify that it is properly displayed with or without results" do
      search_for_a_certain_string_new(search_object, mandatory_found)
    end
    backspace_or_x = [true, false].sample
    if backspace_or_x == true
      it "Cancel the search using the 'BACKSPACE' key and verify that the search box is properly displayed" do
        (0..search_object.length+2).each do
          @browser.send_keys :backspace
          @browser.send_keys :delete
          sleep 0.3
        end
        sleep 0.5
        verify_search_box(true)
      end
    else
      it "Cancel the search using the 'x' button and verify that the search box is properly displayed" do
        search_box_element = find_proper_search_box
        search_box_element.element(css: ' .btn-clear').click
        sleep 0.5
        verify_search_box(true)
      end
    end
  end
end

shared_examples "on rogues tab change the filter options" do |what_status, what_time_period| # US XMSC - 176 - Rogues ! Show additional information on rogues - Created on 27/11/2017
  describe "On the Rogues tab of My network set the view to '#{what_status}' / '#{what_time_period}'" do
    it "Set the 'Show' type dropdown list to '#{what_status}'" do
      if @ui.css('#mynetwork-rogues-state a .text').text != what_status
        @ui.set_dropdown_entry('mynetwork-rogues-state', what_status)
        sleep 0.5
      end
      expect(@ui.css('#mynetwork-rogues-state a .text').text).to eq(what_status)
    end
    if what_time_period != nil
      it "Set the 'Time Span' type dropdown list to '#{what_time_period}'" do
        if @ui.css('#mynetwork-rogues-time a .text').text != what_time_period
          @ui.set_dropdown_entry('mynetwork-rogues-time', what_time_period)
          sleep 0.5
        end
        expect(@ui.css('#mynetwork-rogues-time a .text').text).to eq(what_time_period)
      end
    end
  end
end

shared_examples "verify the rogues grid is properly displayed" do # US XMSC - 176 - Rogues ! Show additional information on rogues - Created on 27/11/2017
  describe "Verify that the Rogues grid is properly displayed" do
    it "Expect that the elements of the grid are visible" do
      verify_controls_hash = Hash[".rogues_tab .commonTitle" => "Rogues on your network", ".rogues_tab .commonSubtitle" => "View access points detected in the vicinity of your network.", "Export button" => "#mn-cl-export-btn", "Column Picker" => ".columnPickerIcon", "Search Input" => ".xc-search input", "Search Button" => ".xc-search .btn-search", "Search Clear" => ".xc-search .btn-clear", "Paging Pages" => ".nssg-paging .nssg-paging-pages", "Paging Count" => ".nssg-paging .nssg-paging-count", "Paging Controls" => ".nssg-paging .nssg-paging-controls", "Refresh button" => ".nssg-paging .nssg-refresh", "Table Header" => ".nssg-table thead:nth-of-type(2)", "Table Body" => ".nssg-table tbody"]
      verify_controls_hash.each do |key, value|
        if key.include? ".rogues_tab"
          expect(@ui.css(key)).to exist
          expect(@ui.css(key).text).to eq(value)
        elsif value == ".xc-search .btn-clear"
          expect(@ui.css(value)).to exist
        else
          expect(@ui.css(value)).to be_visible
        end
      end
    end
  end
end

def file_name_constructor(what_status, what_time_period)
  if what_status == "Active"
    status = "ONLINE"
    if what_time_period == nil
      time = "ALL"
    end
  elsif  what_status == "Inactive"
    status = "OFFLINE"
  elsif what_status == "All"
    status = "BOTH"
  end
  if what_time_period == "Seen in the last day"
    time = "DAY"
  elsif what_time_period == "Seen in the last week"
    time = "WEEK"
  elsif what_time_period == "Seen in the last month"
    time = "MONTH"
  elsif what_time_period == "All time"
    time = "ALL"
  end
  return "/Rogues-" + status + "-" + time + "-"
end

shared_examples "verify rogues exports" do |what_status, what_time_period| # US XMSC - 176 - Rogues ! Show additional information on rogues - Created on 27/11/2017
  describe "Verify the export feature on the rogues grid" do
    it "Press the 'Export All' button" do
      @ui.click('#mn-cl-export-btn')
    end
    it "Verify that the exported list contains all the rogue entries" do
      text = @ui.css('.nssg-paging-count').text
      i = text.index('of')
      length = text.length
      number = text[i + 3, text.length]
      file_name = file_name_constructor(what_status, what_time_period)
      fname = @download + file_name + (Date.today.to_s) + ".csv"
      file = File.open(fname, "r")
      data = file.read
      count = data.count("\n").to_s
      expect(data).to include("MAC Address,RSSI,Channel,SSID,Source Hostname,Manufacturer,Last Seen,Time Discovered")
      # expect(data).to include("Rogue MAC,Max RSSI,Channel,SSID,Source Host Name,Manufacturer,Last Seen,First Seen")
      file.close
      @ui.click('.rogues_tab .commonTitle')
      File.delete(@download + file_name + (Date.today.to_s) + ".csv")
    end
  end
end

shared_examples "verify the rogues grid display only last 90 days rogues" do
  describe "verify the rogues grid display only last 90 days rogues" do
    column_num=nil
    it "sort Time discovered column to assending order" do
      th_items_list = @ui.css('table thead:nth-child(2) tr').ths
      th_items_list.each_with_index do |th, index|
        if th.attribute_value("col-id")== "timeOrigin"
          column_num = index+1
          expect(th.attribute_value("class")).to include("nssg-sortable")
          th.click
          sleep 1
          if !th.attribute_value("class").include?("nssg-sorted-asc")
            th.click
          end
        end
      end 
    end 
    it "verify that rogues listed are not older than 90 days" do    
       disc_date_rogue = (@ui.css("table tbody tr:nth-child(1) td:nth-child(#{column_num})").text).to_date
       puts "first rogues discover date :" + disc_date_rogue.to_s
       puts "Todays Date: " + Date.today.to_s
       expect(130).to be > (Date.today - disc_date_rogue).to_i
    end
  end  #describe
end #shared_examples
