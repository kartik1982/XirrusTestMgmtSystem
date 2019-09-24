shared_examples "go to alerts tab" do
  it "Go to the Alerts tab from the My Network area" do
    if (!@browser.url.end_with? "#mynetwork/alerts")
      @ui.click('#header_mynetwork_link')
      sleep 2
      @ui.click('#mynetwork_tab_alerts')
    end
  end
end

shared_examples "show all available alerts" do
  it "Set the values 'All Statuses', 'All Alerts' and 'All Severities' and the view to '1000" do
    expect(@ui.css('#mynetwork_alerts_state')).to be_visible
    expect(@ui.css('#mynetwork_alerts_ack')).to be_visible
    expect(@ui.css('#mynetwork_alerts_severity')).to be_visible
    @ui.set_dropdown_entry('mynetwork_alerts_state', "All Statuses")
    sleep 0.5
    @ui.set_dropdown_entry('mynetwork_alerts_ack', "All Alerts")
    sleep 0.5
    @ui.set_dropdown_entry('mynetwork_alerts_severity', "All Severities")
    sleep 0.5
    expect(@ui.css('#mynetwork_alerts_state a .text').text).to eq("All Statuses")
    expect(@ui.css('#mynetwork_alerts_ack a .text').text).to eq("All Alerts")
    expect(@ui.css('#mynetwork_alerts_severity a .text').text).to eq("All Severities")
    sleep 0.5
    @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
  end
end

shared_examples "verify main features of tab" do
  it "Verify that the title, dropdown lists, grid, grid controls, refresh button and column picker all exist" do
    expect(@ui.css('#mynetwork_alerts_state')).to be_visible
    expect(@ui.css('#mynetwork_alerts_ack')).to be_visible
    expect(@ui.css('#mynetwork_alerts_severity')).to be_visible
    expect(@ui.css('.columnPickerIcon')).to be_visible
    expect(@ui.css('#mynetwork_alerts_tab .commonTitle span:nth-child(1)').text).to eq("Alerts")
    expect(@ui.css('#mynetwork_alerts_tab .commonTitle xhelp .koHelpIcon')).to be_present
    expect(@ui.css('.nssg-table thead:nth-child(2)')).to be_visible
    if @ui.css('.nssg-table tbody tr').exists?
      expect(@ui.css('.nssg-paging .nssg-paging-selector-container')).to be_visible
      expect(@ui.css('.nssg-paging .nssg-paging-count')).to be_visible
    end
    expect(@ui.css('.nssg-paging .nssg-refresh')).to be_visible
  end
end

shared_examples "verify default columns" do
  context "Go to the Alerts tab" do
    it_behaves_like "go to alerts tab"
  end
  context "Show all available alerts" do
    it_behaves_like "show all available alerts"
  end
  context "Set view to 'Default'" do
    it "Set the view to display the 'Default' columns and verify them" do
      @ui.css('.columnPickerIcon').click
      sleep 1.5
      expect(@ui.css('.column_selector_modal')).to be_visible
      sleep 0.5
      expect(@ui.css('.column_selector_modal .title_wrap .commonTitle').text).to eq('Select Columns')
      expect(@ui.css('.column_selector_modal .title_wrap .commonSubtitle').text).to eq('Select column items you would like to show in the table.')
      sleep 0.5
      @ui.click('#column_selector_restore_defaults')
      sleep 0.5
      expect(@ui.css('.column_selector_modal .content .rhs.greybox #rhs_selector ul').lis.length).to eq(7)
      sleep 0.5
    end
    it "Save the modal and verify the grid" do
      @ui.click('#column_selector_modal_save_btn')
      sleep 1
      header_count = @ui.get_grid_header_count_new
      sleep 0.5
      expect(header_count).to eq(9)
      ["Severity", "Alert Type", "Source", "State", "Open Date/Time", "Closed Date/Time", "Description"].each { |column_name|
        header_column = @ui.find_grid_header_by_name_new(column_name)
        expect(header_column[2].text).to eq(column_name)
      }
    end
  end
end

shared_examples "test my network alerts grid" do
  context "Go to the Alerts tab" do
    it_behaves_like "go to alerts tab"
  end
  context "Verify the main features of the Alerts tab" do
    it_behaves_like "verify main features of tab"
  end
  context "Show all available alerts" do
    it_behaves_like "show all available alerts"
  end
  context "Verify the default columns" do
  it_behaves_like "verify default columns"
  end
  context "Verify the sorting feature on all columns" do
    it "Verify the sorting feature for ascending on all columns" do
      ["Severity", "Alert Type", "Source", "State", "Open Date/Time", "Closed Date/Time"].each { |column_name|
        header_column = @ui.find_grid_header_by_name_new(column_name)
        expect(header_column[2].text).to eq(column_name)
        sleep 1
        header_column[2].click
        sleep 1
        expect(@ui.css(".nssg-table thead tr th:nth-child(#{$header_count})").attribute_value("class")).to include('nssg-sorted-asc')
      }
    end
    it "Verify the sorting feature for descending on all columns" do
      ["Severity", "Alert Type", "Source", "State", "Open Date/Time", "Closed Date/Time"].each { |column_name|
        header_column = @ui.find_grid_header_by_name_new(column_name)
        expect(header_column[2].text).to eq(column_name)
        sleep 1
        header_column[2].click
        sleep 1
        header_column[2].click
        sleep 1
        expect(@ui.css(".nssg-table thead tr th:nth-child(#{$header_count})").attribute_value("class")).to include('nssg-sorted-desc')
      }
    end
  end
  context "Remove then readd the 'State' column" do
    it "Remove the 'State' column " do
      @ui.css('.columnPickerIcon').click
      sleep 1.5
      expect(@ui.css('.column_selector_modal')).to be_visible
      sleep 0.5
      lenght_of_selected_items = @ui.css('.column_selector_modal .content .rhs.greybox #rhs_selector ul').lis.length
      while lenght_of_selected_items != 0
        if @ui.css(".column_selector_modal .content .rhs.greybox #rhs_selector ul li:nth-child(#{lenght_of_selected_items})").text == "State"
          sleep 1
          @ui.css(".column_selector_modal .content .rhs.greybox #rhs_selector ul li:nth-child(#{lenght_of_selected_items})").click
          break
        end
        lenght_of_selected_items-=1
        sleep 0.5
      end
      sleep 0.5
      @ui.click('#column_selector_modal_remove_btn')
      sleep 0.5
      expect(@ui.css('.column_selector_modal .content .rhs.greybox #rhs_selector ul').lis.length).to eq(6)
      @ui.click('#column_selector_modal_save_btn')
      sleep 1
      bool_not_exists = @ui.find_grid_header_by_name_new("State")
      expect(bool_not_exists).to eq(true)
      ["Severity", "Alert Type", "Source", "Open Date/Time", "Closed Date/Time"].each { |column_name|
        header_column = @ui.find_grid_header_by_name_new(column_name)
        expect(header_column[2].text).to eq(column_name)
      }
    end
    it "ReAdd the 'State' column " do
      @ui.css('.columnPickerIcon').click
      sleep 1.5
      expect(@ui.css('.column_selector_modal')).to be_visible
      sleep 0.5
      lenght_of_selected_items = @ui.css('.column_selector_modal .content .lhs.greybox .select_list ul').lis.length
      while lenght_of_selected_items != 0
        if @ui.css(".column_selector_modal .content .lhs.greybox .select_list ul li:nth-child(#{lenght_of_selected_items})").text == "State"
          sleep 1
          @ui.css(".column_selector_modal .content .lhs.greybox .select_list ul li:nth-child(#{lenght_of_selected_items})").click
          break
        end
        lenght_of_selected_items-=1
        sleep 0.5
      end
      sleep 0.5
      @ui.click('#column_selector_modal_move_btn')
      sleep 0.5
      expect(@ui.css('.column_selector_modal .content .rhs.greybox #rhs_selector ul').lis.length).to eq(7)
      @ui.click('#column_selector_modal_save_btn')
      sleep 1
      ["Severity", "Alert Type", "Source", "State", "Open Date/Time", "Closed Date/Time"].each { |column_name|
        header_column = @ui.find_grid_header_by_name_new(column_name)
        expect(header_column[2].text).to eq(column_name)
      }
    end
  end
end

shared_examples "acknowledge & unacknowledge alerts" do |profile_name|
  context "Go to the Alerts tab, verify main features and show all available alerts" do
    it_behaves_like "go to alerts tab"
    it_behaves_like "verify main features of tab"
    it_behaves_like "show all available alerts"
    it_behaves_like "verify default columns"
  end
  context "Acknowledge, verify then Unacknowledge an alert" do
    it "Get the length of the 'Acknowledged' grid" do
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "Acknowledged")
      sleep 2
      @@acknowledged_entries = @ui.css('.nssg-table tbody').trs.length
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "All Alerts")
    end
    it "Select the line with the entry source as #{profile_name}, acknowledge it and verify the grid show a visual aid" do
      @ui.grid_verify_strig_value_on_specific_line(4, profile_name, "a", 4, "a", profile_name)
      @ui.grid_tick_on_specific_line_avaya_provisioned(4, profile_name, "a")
      sleep 0.5
      expect(@ui.css('#mynetwork_alerts_ack_btn')).to be_visible
      sleep 0.5
      @ui.click('#mynetwork_alerts_ack_btn')
      sleep 1.5
      @ui.click('.nssg-refresh')
      sleep 0.5
      @ui.grid_verify_strig_value_on_specific_line(4, profile_name, "a", 4, "a", profile_name)
      #expect(@ui.css(".nssg-table tr:nth-child(#{$grid_length}) td:nth-child(1) div").attribute_value("class")).to eq("nssg-td-select acked")
    end
    it "Change the view type to 'Acknowledged' alerts only, verify the length of the table is '+1 vs. before', and revert to 'All Alerts'" do
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "Acknowledged")
      sleep 1
      all_acknowledged_entries = @@acknowledged_entries + 1
      expect(@ui.css('.nssg-table tbody').trs.length).to eq(all_acknowledged_entries)
      while all_acknowledged_entries > 0
        expect(@ui.css(".nssg-table tbody tr:nth-child(#{all_acknowledged_entries}) td:nth-child(1)").attribute_value("class")).to include("nssg-td-select")
        all_acknowledged_entries-=1
      end
      sleep 1
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "All Alerts")
    end
    it "Select the line with the entry source as '#{profile_name}', unacknowledge it and verify the grid does not show the visual aid" do
      @ui.grid_verify_strig_value_on_specific_line(4, profile_name, "a", 4, "a", profile_name)
      @ui.grid_tick_on_specific_line_avaya_provisioned(4, profile_name, "a")
      sleep 0.5
      expect(@ui.css('#mynetwork_alerts_unack_btn')).to be_visible
      sleep 0.5
      @ui.click('#mynetwork_alerts_unack_btn')
      sleep 1.5
      @ui.click('.nssg-refresh')
      sleep 0.5
      @ui.grid_verify_strig_value_on_specific_line(4, profile_name, "a", 4, "a", profile_name)
    end
    it "Change the view type to 'Acknowledged' alerts only, verify the length of the table is '-1 vs. before', and revert to 'All Alerts'" do
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "Acknowledged")
      sleep 1
      expect(@ui.css('.nssg-table tbody').trs.length).to eq(@@acknowledged_entries)
      sleep 1
      @ui.set_dropdown_entry('mynetwork_alerts_ack', "All Alerts")
    end
  end
end

shared_examples "verify filters" do
  context "Go to the Alerts tab and show all available alerts" do
    it_behaves_like "go to alerts tab"
    it_behaves_like "show all available alerts"
  end
  context "Verify the Alerts Filters" do
    it "Verify grid entries and get alert counts" do
      closed_array = []
      opened_array = []
      high_array = []
      medium_array = []
      low_array = []
      length_of_table = @ui.css('.nssg-table tbody').trs.length
      hc = @ui.find_grid_header_by_name_new("State")
      state_column_number = hc[0].to_i
      hc = @ui.find_grid_header_by_name_new("Source")
      source_column_number = hc[0].to_i
      hc = @ui.find_grid_header_by_name_new("Severity")
      severity_column_number = hc[0].to_i
      while (length_of_table > 0)
        puts "Length of table: #{length_of_table}"
        if @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{state_column_number}) div span:nth-child(2)").attribute_value("title") == "Closed"
          closed_alert_source = @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{source_column_number}) a").text
          closed_array.insert(0, closed_alert_source)
        elsif @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{state_column_number}) div span:nth-child(2)").attribute_value("title") == "Open"
          opened_alert_source = @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{source_column_number}) a").text
          opened_array.insert(0, opened_alert_source)
        end
        if @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title") == "High"
          alert_severity = @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title")
          high_array.insert(0, alert_severity)
        elsif @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title") == "Medium"
          alert_severity = @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title")
          medium_array.insert(0, alert_severity)
        elsif @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title") == "Low"
          alert_severity = @ui.css(".nssg-table tbody tr:nth-child(#{length_of_table}) td:nth-child(#{severity_column_number}) div span:nth-child(2)").attribute_value("title")
          low_array.insert(0, alert_severity)
        end
        length_of_table-=1
      end
      $opened_alerts = opened_array.length
      $closed_alerts = closed_array.length
      $high_alerts = high_array.length
      $medium_alerts = medium_array.length
      $low_alerts = low_array.length
    end
    it "Set the view to Severity: High (Verify '#{$high_alerts}' entries are displayed) / Medium ('#{$medium_alerts}' entries) / Low ('#{$low_alerts}' entries)" do
      @ui.set_dropdown_entry('mynetwork_alerts_severity', "High")
      sleep 1
      length_of_table = @ui.css('.nssg-table').trs.length - 1
      expect(length_of_table).to eq($high_alerts)
      sleep 0.5
      @ui.set_dropdown_entry('mynetwork_alerts_severity', "Medium")
      sleep 1
      length_of_table = @ui.css('.nssg-table').trs.length - 1
      expect(length_of_table).to eq($medium_alerts)
      sleep 0.5
      @ui.set_dropdown_entry('mynetwork_alerts_severity', "Low")
      sleep 1
      length_of_table = @ui.css('.nssg-table').trs.length - 1
      expect(length_of_table).to eq($low_alerts)
      sleep 1
      @ui.set_dropdown_entry('mynetwork_alerts_severity', "All Severities")
    end
    it "Set the view to Status: Opened (Verify '#{$opened_alerts}' entries are displayed) / Closed ('#{$closed_alerts}' entries)" do
      @ui.set_dropdown_entry('mynetwork_alerts_state', "Open")
      sleep 1
      length_of_table = @ui.css('.nssg-table').trs.length - 1
      expect(length_of_table).to eq($opened_alerts)
      sleep 0.5
      @ui.set_dropdown_entry('mynetwork_alerts_state', "Closed")
      sleep 1
      length_of_table = @ui.css('.nssg-table').trs.length - 1
      expect(length_of_table).to eq($closed_alerts)
    end
  end
end

shared_examples "verify the Alert grid display after clean-up data" do |priority|
  describe "verify the alert with #{priority} grid display only expected days alerts" do
    column_num=nil
   it "Go to the Alerts tab from the My Network area" do
      if (!@browser.url.end_with? "#mynetwork/alerts")
        @ui.click('#header_mynetwork_link')
        sleep 2
        @ui.click('#mynetwork_tab_alerts')
      end
    end
    it "on Alert tab change the filter options to all Alerts status and priority #{priority}" do
       #set Alert status to all status
       @ui.set_dropdown_entry('mynetwork_alerts_state', "All Statuses")
       sleep 1
       @ui.set_dropdown_entry('mynetwork_alerts_ack', "All Alerts")
       sleep 2
       @ui.set_dropdown_entry('mynetwork_alerts_severity', "#{priority}")
    end   
    it "sort Alert open Date-time column to assending order" do
      th_items_list = @ui.css('table thead:nth-child(2) tr').ths
      th_items_list.each_with_index do |th, index|
        if th.attribute_value("col-id")== "createdTime"
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
    it "verify that Alert listed are not older than expected days" do    
       open_date_alert = (@ui.css("table tbody tr:nth-child(1) td:nth-child(#{column_num})").text).to_date
       puts "first Alert open date :" + open_date_alert.to_s
       puts "Todays Date: " + Date.today.to_s
       if priority=="High"
       expect(731).to be > (Date.today - open_date_alert).to_i
       else
         expect(551).to be > (Date.today - open_date_alert).to_i
       end
    end
  end  #describe
end #shared_examples