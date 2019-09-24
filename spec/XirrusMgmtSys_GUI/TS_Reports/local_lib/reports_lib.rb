def change_to_a_certain_page_of_a_report(page_name, page_time_str)
  total_pages = @ui.css('.nssg-paging .nssg-paging-controls .nssg-paging-total').text #.chomp("of ")
  total_pages = total_pages.slice(total_pages.index('of') + 3..-1)
  total_pages_int = total_pages.to_i-1
    while (total_pages_int != 0) do
      if (@ui.css("#profile_view .report-page-chart-type").text == page_name && @ui.css("#profile_view .report-page-chart-range").text == page_time_str)
        sleep 1
        @ui.click('#profile_name')
      else
        sleep 1
        @ui.click('.nssg-paging .nssg-paging-controls .nssg-paging-next')
        sleep 1
      end
      total_pages_int-=1
    end
end

def verify_report_list_does_not_contain_deleted_report(report_name)
  sleep 5
  reports = @ui.get(:elements , {css: "#reports_list .ui-sortable .tile"})
  $i = 1
  reports.each { |report|
    report_title = @ui.css("#reports_list .ui-sortable li:nth-child(#{$i}) a .title").text
    if report_title == report_name
      expect(report_title).not_to eq(report_name)
    end
    $i += 1
  }
  $i = nil
end

def go_to_the_page_with_the_widget(widget_name)
  @ui.click('.nssg-paging-controls .nssg-paging-next')
  sleep 1
  a = @ui.get(:span, {css: '.nssg-paging-controls .nssg-paging-total'}).text.tr('of ', '')
  a2 = a.to_i - 1
  while (a2 != 0) do
    if (@ui.css("#profile_view .report-preview-body .report-page .report-page-widget-list .report-page-widget-li .report-page-chart-type").text == widget_name)
      sleep 1
      @ui.click('#profile_name')
      break
    else
      sleep 1
      @ui.click('.nssg-paging-controls .nssg-paging-next')
      sleep 1
    end
    a2-=1
  end
end

def clear_spinner_input(css_path)
  @ui.click(css_path)
  sleep 0.5
    for i in 0..9
      @browser.send_keys :backspace
      sleep 0.2
    end
    2.times do
      @browser.send_keys :delete
    end
  sleep 1
end

##########################################################################################################################################################
##############################################################  BASIC METHODS  ###########################################################################
##########################################################################################################################################################

shared_examples "go to reports landing page" do
  describe "Go to the Reports Landing Page" do
    it "Open the Reports drop-down list and press the 'View All Reports' link" do
      @ui.view_all_reports
      expect(@browser.url).to include('/#reports')
    end
  end
end

shared_examples "go to a specific report" do |report_name|
  describe "Go to the report named '#{report_name}'" do
      it "Go to the reports landing page and open the report named '#{report_name}'" do
        @ui.goto_report report_name
    end
  end
end

shared_examples "verify report name" do |report_name|
  describe "Verify that the report name is '#{report_name}'" do
    it "Goes to the new report and verifies that the report name is: '#{report_name}'" do
      name = @ui.css(".report-cover-title")
      name.wait_until(&:present?)
      expect(name.text).to eq(report_name)
    end
  end
end

shared_examples "verify report name in config" do |report_name|
  describe "Verify that the report name is '#{report_name}' (inside the configurations menu)" do
    it "Goes to the new report config page and verifies that the report name is: '#{report_name}" do
      name = @ui.css("#profile_name")
      name.wait_until(&:present?)
      expect(name.text).to eq(report_name)
    end
  end
end

shared_examples "go to scheduled reports page" do
  describe "Go to the Scheduled Reports Page" do
    it "Open the Reports drop-down list and press the 'View All Reports' link then navigate to the Scheduled Reports page" do
      @ui.view_all_reports
      expect(@browser.url).to include('/#reports')
      sleep 2
      @ui.click('.right-tab-menu a:nth-child(2)')
      @ui.css('.reports_container .nssg-table thead').wait_until(&:present?) and expect(@browser.url).to include('/#reports/scheduled')
    end
  end
end

##########################################################################################################################################################
############################################################  PRE-CANNED REPORTS  ########################################################################
##########################################################################################################################################################

shared_examples "delete all reports except for pre-canned" do
  describe "Delete all reports from the landing page except for the pre-canned ones" do
    it "Open the Reports drop-down list and press the 'View All Reports' link" do
      @ui.view_all_reports
      expect(@browser.url).to include('/#reports')
    end
    it "Delete all reports that are not the pre-canned reports" do
      list = @ui.css('#reports_list .ui-sortable')
      list.wait_until(&:present?)
      reports = list.lis(:class => 'tile').length
      while (reports != 0) do
        report_title = @ui.css("#reports_list .ui-sortable li:nth-child(#{reports}) .title")
        report_names = ["Application Visibility Report","AP and Client Throughput Report","AP and Client Usage Report","Detailed Client Activity Report","Devices Report"]
        if !report_names.include?(report_title.text)
          sleep 0.5
          if !["firefox", "edge"].include? @browser_name.to_s
            report_title.hover
          else
            @ui.show_needed_control("#reports_list .tile:nth-child(#{reports}) .overlay")
          end
          sleep 0.5
          @ui.click("#reports_list .ui-sortable li:nth-child(#{reports}) .overlay .deleteIcon")
          sleep 1.5
          @ui.click('#_jq_dlg_btn_1')
          sleep 2
        end
        reports -= 1
      end
    end
  end
end

shared_examples "check there are 5 pre-canned reports" do
  describe "Verify that the Reports landing page contains only 5 reports" do
    it "Check that there are 5 pre-canned reports" do
      list = @ui.css('#reports_list .ui-sortable')
      list.wait_until(&:present?)
      expect(list.lis(:class => 'tile').length).to eq(5)
    end
  end
end

shared_examples "verify the pre-canned reports names" do
  describe "Verify that the 5 pre-canned reports are the proper ones" do
    it "Verify that the list contains the pre-canned reports" do
      report_names = ["Application Visibility Report","AP and Client Throughput Report","AP and Client Usage Report","Detailed Client Activity Report","Devices Report"]
      report_names.each { |report_name|
        expect(@ui.css("#reports_list .tile span[title='#{report_name}']")).to be_visible
      }
    end
  end
end

shared_examples "verify pre-canned reports" do
  it_behaves_like "go to reports landing page"
  it_behaves_like "delete all reports except for pre-canned"
  it_behaves_like "check there are 5 pre-canned reports"
  it_behaves_like "verify the pre-canned reports names"
end

##########################################################################################################################################################
##############################################################  FAVORITE REPORTS  ########################################################################
##########################################################################################################################################################

shared_examples "verify favourite" do |report_name|
  describe "Verify that the '#{report_name}' report is set as favorite" do
    it "Check the menu and verifies that the '#{report_name}' is set as favorite" do
      @ui.click("#header_nav_reports > span")
      sleep 0.5
      items = @ui.id('reports_items')
      items.wait_until(&:present?)
      item = items.a(:title => report_name)
      expect(item).to be_visible
      sleep 0.5
      @ui.click('#main_container')
    end
  end
end

shared_examples "favourite report from tile" do |report_name|
  it_behaves_like "go to reports landing page"
  describe "Set the '#{report_name}' as a favourite report using the tile overlay button" do
    it "Click favourite icon on report tile" do
      @report_tile = @ui.report_tile_with_name report_name
      #@report_tile.hover
      @overlay_content = @ui.report_tile_with_name_new(report_name) + " .overlay"
      sleep 1
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      fav_btn = @report_tile.element(:css => ".overlay .reportsFavoriteIcon")
      expect(fav_btn).to be_visible
      fav_btn.click
      sleep 1
    end
    it_behaves_like "verify favourite", report_name
  end
end

shared_examples "favourite report from report menu" do |report_name|
  it_behaves_like "go to a specific report", report_name
  describe "Set the '#{report_name}' as a favourite report from reports' Menu" do
    it "Click favourite in report menu for '#{report_name}'" do
      @ui.click('#report_menu_btn')
      @ui.click('#report_favorite')
      sleep 1
    end
    it_behaves_like "verify favourite", report_name
  end
end

##########################################################################################################################################################
############################################################  DUPLICATE REPORTS  #########################################################################
##########################################################################################################################################################

shared_examples "duplicate report from tile" do |report_name, report_description|
  it_behaves_like "go to reports landing page"
  describe "Duplicate report from tile" do
    it "Click duplicate icon on report tile" do
      @report_tile = @ui.report_tile_with_name report_name
      #@report_tile.hover
      @report_tile.focus
      @overlay_content = @ui.report_tile_with_name_new(report_name) + " .overlay"
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      dup_btn = @report_tile.element(:css => ".overlay .duplicateIcon")
      dup_btn.wait_until(&:present?)
      expect(dup_btn).to be_visible
      dup_btn.click
      sleep 1
    end
    it "Confirm dialog to go to duplicate report named 'Copy of #{report_name}' "  do
      @ui.confirm_dialog
    end
    it_behaves_like "verify report name in config", "Copy of " + report_name, report_description
  end
end

shared_examples "duplicate report from report menu" do |report_name, report_description|
  it_behaves_like "go to a specific report", report_name
  describe "Duplicate report from report Menu" do
    it "Click duplicate in the report menu for '#{report_name}'" do
      @ui.click('#report_menu_btn')
      sleep 1
      @ui.click('#report_duplicate')
      sleep 1
    end
    it "Confirm dialog to go to duplicate report named 'Copy of #{report_name}' "  do
      @ui.confirm_dialog
      sleep 1
    end
    it_behaves_like "verify report name in config", "Copy of " + report_name, report_description
  end
end

##########################################################################################################################################################
################################################################  ADD REPORTS  ###########################################################################
##########################################################################################################################################################


shared_examples "add new report" do |report_name, report_description|
  describe "Add a new report with the name '#{report_name}'" do
    it "Submits a new report named '#{report_name}'" do
      @ui.css(".report-config-body").wait_until(&:present?)
      @ui.set_input_val('#report-config-name',report_name)
      sleep 0.5
      description = @ui.get(:textarea, { id: 'report-config-description' })
      description.wait_until(&:present?)
      description.set report_description
      sleep 1
      @ui.click('.report-config-save')
    end
  end
  it_behaves_like "verify report name", report_name, report_description
end

shared_examples "create report from header menu" do |report_name, report_description|
  describe "Create a report from the header menu '+ New Report' button " do
    it "Clicks on '+ New report' button in reports header menu" do
      @ui.click("#header_nav_reports > span")
      expect(@ui.css("#header_reports_arrow .reports_nav.drop_menu_nav.active")).to be_visible
      @ui.click("#header_new_reports_btn")
    end
    it_behaves_like "add new report", report_name, report_description
  end
end

shared_examples "create report from new report button" do |report_name, report_description|
  it_behaves_like "go to reports landing page"
  describe "Create a report from the landing page '+ New Report' button" do
    it "Create report from '+ New report' button (reports View)" do
      @ui.click('#new_report_btn')
    end
    it_behaves_like "add new report", report_name, report_description
  end
end

##########################################################################################################################################################
#############################################################  DELETE REPORTS  ###########################################################################
##########################################################################################################################################################

shared_examples "delete report from tile" do |report_name|
  it_behaves_like "go to reports landing page"
  describe "Delete the report named '#{report_name}' using the tile overlay button" do
    it "Click delete icon on report tile" do
      @report_tile = @ui.report_tile_with_name report_name
      #@report_tile.hover
      @overlay_content = @ui.report_tile_with_name_new(report_name) + " .overlay"
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      delete_btn = @report_tile.element(:css => ".overlay .deleteIcon")
      delete_btn.wait_until(&:present?)
      expect(delete_btn).to be_visible
      delete_btn.click
    end
    it "Confirm the deletion" do
      @ui.confirm_dialog
      verify_report_list_does_not_contain_deleted_report(report_name)
    end
  end
end

shared_examples "delete report from report menu" do |report_name|
  it_behaves_like "go to a specific report", report_name
  describe "Delete the report named '#{report_name}' using the reports' Menu" do
    it "While in the report '#{report_name}', click the delete button in the reports' menu" do
      @ui.click('#report_menu_btn')
      @ui.click('#report_delete')
      @ui.confirm_dialog
    end
    it "Route back to Reports List Landing Page" do
      Watir::Wait.until { @browser.url.end_with? "#reports/reports" }
      sleep 3
    end
    it "Verify that the '#{report_name}' report is removed from list" do
      #expect(@ui.css("#reports_list .tile span[title='#{report_name}']")).not_to exist
      verify_report_list_does_not_contain_deleted_report(report_name)
    end
  end
end

##########################################################################################################################################################
###############################################################  EDIT REPORTS  ###########################################################################
##########################################################################################################################################################

shared_examples "edit report" do |report_name, page_name, page_time|
  describe "Edit the report named '#{report_name}' and add the page named '#{page_name}' and time span '#{page_time}'" do
    it "Edit the '#{report_name}' report and add the page '#{page_name}' for '#{page_time}'" do
      @ui.css(".report-config-body").wait_until(&:present?)
        @browser.execute_script('$("#suggestion_box").hide()')
      @ui.click('#report-add-page')
      sleep 1
      @ui.set_dropdown_entry('report-page-widget', page_name)
      sleep 1
      if @ui.css(".switch_label").present?
        if !@ui.get(:checkbox, {css: '.switch_checkbox'}).set?
          @ui.click('.switch')
        end
      end
      @ui.click("#report-page-description")
      sleep 0.5
      @ui.set_dropdown_entry('report-page-range', page_time)
      sleep 0.5
      @ui.click('.report-config-save')
    end
    it "Change to the '#{page_name}' page for #{page_time} in the report" do
      @ui.click('.nssg-paging .nssg-paging-controls .nssg-paging-next')
      sleep 1
      case page_time
        when "Last Hour"
           $page_time_str = "(1 hour)"
        when "Last Day"
           $page_time_str = "(1 day)"
        when "Last 7 Days"
           $page_time_str = "(7 days)"
        when "Last 30 Days"
           $page_time_str = "(30 days)"
      end
      change_to_a_certain_page_of_a_report(page_name, $page_time_str)
    end
    it "Verify that the page contains the following: #{page_name} widget & #{page_time} time span" do
      page = @ui.css('.report-page-chart-type')
      page.wait_until(&:present?)
      expect(page.text).to eq(page_name)
      range = @ui.css('.report-page-chart-range')
      range.wait_until(&:present?)
      expect(range.text).to eq("#{$page_time_str}")
    end
  end
end

shared_examples "edit report from tile" do |report_name, page_name, page_time|
  it_behaves_like "go to reports landing page"
  describe "Edit report from tile" do
    it "Click edit icon on report tile" do
      @report_tile = @ui.report_tile_with_name report_name
      #@report_tile.hover
      @overlay_content = @ui.report_tile_with_name_new(report_name) + " .overlay"
      @browser.execute_script("$(\"#{@overlay_content}\").show()")
      edit_btn = @report_tile.a(:class => "editIcon")
      edit_btn.wait_until(&:present?)
      expect(edit_btn).to be_visible
      edit_btn.click
    end
    it_behaves_like "edit report", report_name, page_name, page_time
  end
end

shared_examples "edit report from report menu" do |report_name, report_description, page_name, page_time|
  it_behaves_like "go to a specific report", report_name
  describe "edit report from report Menu" do
    it "Click the 'Edit' option in the report menu for the report named '#{report_name}'" do
      @ui.click('#report_menu_btn')
      @ui.click('#report_edit')
    end
    it_behaves_like "edit report", report_name, page_name, page_time
  end
end


shared_examples "change to certain widget name page in report" do |widget_name|
  describe "Change to the page that contains the '#{widget_name}' in the report" do
    it "Change to the '#{widget_name}' page in the report" do
      go_to_the_page_with_the_widget(widget_name)
    end
  end
end

shared_examples "change the view option for the page to a certain profile" do |profile_name|
  describe "Change the view option for the current report page to the profile named '#{profile_name}'" do
    it "Change the report profile from 'All Profiles' to '#{profile_name}'" do
      name = @ui.css("#profile_name")
      name.wait_until(&:present?)
      expect(name.attribute_value("class")).to include("report-preview-title")
      @ui.click('.report-edit-view-btn')
      sleep 0.5
      @ui.set_dropdown_entry('report-edit-view-profile', profile_name)
      sleep 0.5
      @ui.click('#report-edit-view-apply')
    end
    it "Verify that the report name has received the filtered icon and the 'Edit View' button has the name #{profile_name}" do
      name = @ui.css("#profile_name")
      name.wait_until(&:present?)
      expect(name.attribute_value("class")).to include("filtered")
      sleep 1
      btn_name = @ui.css('#report-edit-view-btn')
      btn_name.wait_until(&:present?)
      expect(btn_name.text).not_to eq(profile_name)
      expect(btn_name.text).to eq("Edit View")
      sleep 1
      @ui.click("#profile_name")
    end
  end
end

shared_examples "set end override to specific date and time" do |end_time, end_date|
  describe "Change the *END* override to the date/time as following: #{end_date} and #{end_time}" do
    it "Set *END* override for date/time to '#{end_date}' at '#{end_time}'" do
      @ui.click('#report-edit-view-btn')
      sleep 1
      @ui.click("#report-edit-view-endswitch .switch_label")
      sleep 0.5
      clear_spinner_input('#report-edit-view-enddate')
      @ui.set_input_val('#report-edit-view-enddate', end_date)
      sleep 0.5
      @ui.click('#report-edit-view-popover .title')
      clear_spinner_input('#report-edit-view-endtime')
      @ui.set_input_val('#report-edit-view-endtime', end_time)
      sleep 0.5
      @ui.click('#report-edit-view-popover .title')
      sleep 0.5
      @ui.click('#report-edit-view-apply')
      sleep 1
      expect(@ui.css('.temperror')).not_to exist
      expect(@ui.css('.error')).not_to exist
    end
  end
end

shared_examples "set start override to specific date and time" do |start_time, start_date|
  describe "Change the *START* override to the date/time as following: '#{start_date}' and '#{start_time}'" do
    it "Set *START* override for date/time to '#{start_date}' at '#{start_time}'" do
      @ui.click('#report-edit-view-btn')
      sleep 1
      @ui.click('#report-edit-view-startswitch .switch_label')
      sleep 0.5
      clear_spinner_input('#report-edit-view-startdate')
      @ui.set_input_val('#report-edit-view-startdate', start_date)
      sleep 0.5
      @ui.click('#report-edit-view-popover .title')
      clear_spinner_input('#report-edit-view-starttime')
      @ui.set_input_val('#report-edit-view-starttime', start_time)
      sleep 0.5
      @ui.click('#report-edit-view-popover .title')
      sleep 0.5
      @ui.click('#report-edit-view-apply')
      sleep 1
      expect(@ui.css('.temperror')).not_to exist
      expect(@ui.css('.error')).not_to exist
    end
  end
end

shared_examples "verify report shows specific date/time override" do |profile_name, verify_date|
  describe "Verify that the Report displays the information from the specific date/time override period" do
    it "Verify that the report shows it only displays information from the profile '#{profile_name}' and from the period '#{verify_date}'" do
      a = @ui.css('#profile_view .report-preview-body .report-page .report-cover-info').text
      expect(a).to include(profile_name)
      if verify_date != nil
        expect(a).to include("\n" + profile_name + "\n" + verify_date)
      end
    end
  end
end

shared_examples "modify override options then verify cancel button" do |profile_name, verify_date|
  describe "Change settings on the report override then use the cancel button and verify it it's functionality works as intended" do
    it "Modify the override options then verify the 'Cancel' button closes the prompt without applying any setting changes" do
      @ui.click('#report-edit-view-btn')
      sleep 0.5
      @ui.click("#report-edit-view-endswitch .switch_label")
      sleep 0.5
      @ui.set_dropdown_entry('report-edit-view-profile', "All Devices")
      sleep 1
      @ui.click('#report-edit-view-cancel')
      sleep 1
      a = @ui.css('#profile_view .report-preview-body .report-page .report-cover-info').text
      expect(a).to include(profile_name)
      expect(a).to include("\n" + profile_name + "\n" + verify_date)
      sleep 1
      @ui.click('#report-edit-view-btn')
      sleep 1
      expect(@ui.get(:checkbox, {id: "report-edit-view-endswitch_switch"}).set?).to eq(true)
      expect(@ui.get(:checkbox, {id: "report-edit-view-startswitch_switch"}).set?).to eq(true)
      sleep 0.5
      @ui.click('#report-edit-view-cancel')
    end
  end
end

shared_examples "reset all override features and verify report back to default" do |profile_name, verify_date|
  describe "Reset all the override features and verify that the Report has been changed to it's default settings" do
    it "Reset all the settings to their default values" do
      @ui.click('#report-edit-view-btn')
      sleep 0.5
      @ui.click("#report-edit-view-endswitch .switch_label")
      sleep 0.5
      @ui.set_dropdown_entry('report-edit-view-profile', "All Devices")
      sleep 1
      @ui.click('#report-edit-view-apply')
    end
    it "Verify that the report shows it displays information from 'All Profiles' and from the default period" do
      a = @ui.css('#profile_view .report-preview-body .report-page .report-cover-info').text
      expect(a).not_to include(profile_name)
      expect(a).not_to include(verify_date)
      sleep 0.5
      @ui.click('#report-edit-view-btn')
      sleep 1
      expect(@ui.get(:checkbox, {id: "report-edit-view-endswitch_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox, {id: "report-edit-view-startswitch_switch"}).set?).to eq(false)
      sleep 0.5
      @ui.click('#report-edit-view-cancel')
    end
  end
end

shared_examples "verify time override input works on certain time frame" do |time_frame|
  describe "Verify that when trying to change the custom time override, the application will allow only the use of the time frame '#{time_frame}' Hour / Minute" do
    it "On the End Time override, verify that the time interval can only be changed by 1 Hour / Minute" do
      if time_frame == 1
        $time_helper = 40
      else
        $time_helper = 0
      end
      @ui.click('#report-edit-view-btn')
      sleep 0.5
      original_end_time = @ui.get(:input ,{id: "report-edit-view-endtime"}).value.chomp(" am").tr(':','').to_i
      @ui.click('#report-edit-view-popover .endTime .spinner_controls .up_arr')
      sleep 0.5
      new_end_time = @ui.get(:input ,{id: "report-edit-view-endtime"}).value.chomp(" am").tr(':','').to_i
      expect(new_end_time-time_frame).to be_within(500).of(original_end_time)
      (1..5).each do
        @ui.click('#report-edit-view-popover .endTime .spinner_controls .down_arr')
        sleep 0.5
      end
      new_end_time = @ui.get(:input ,{id: "report-edit-view-endtime"}).value.chomp(" am").tr(':','').to_i
      expect(new_end_time+(time_frame*4)+$time_helper).to be_within(500).of(original_end_time)
    end
    it "On the Start Time override, verify that the time interval can only be changed by 1 Hour / Minute" do
      original_end_time = @ui.get(:input ,{id: "report-edit-view-starttime"}).value.chomp(" am").tr(':','').to_i
      @ui.click('#report-edit-view-popover div:nth-of-type(4) .endTime .spinner_controls .up_arr')
      sleep 0.5
      new_end_time = @ui.get(:input ,{id: "report-edit-view-starttime"}).value.chomp(" am").tr(':','').to_i
      expect(new_end_time-time_frame).to be_within(500).of(original_end_time)
      (1..5).each do
        @ui.click('#report-edit-view-popover div:nth-of-type(4) .endTime .spinner_controls .down_arr')
        sleep 0.5
      end
      new_end_time = @ui.get(:input ,{id: "report-edit-view-starttime"}).value.chomp(" am").tr(':','').to_i
      expect(new_end_time+(time_frame*4)+$time_helper).to be_within(500).of(original_end_time)
    end
    it "Close the Edit view popover" do
      sleep 1
      @ui.click('#report-edit-view-apply')
      sleep 1
      expect(@ui.css('#report-edit-view-popover')).not_to be_visible
    end
  end
end


shared_examples "report custom view one hour one minute increments" do |report_name, widget_name, profile_name, end_date, end_time, start_date, start_time, verify_date, time_frame|
  it_behaves_like "go to a specific report", report_name
  it_behaves_like "change to certain widget name page in report", widget_name
  it_behaves_like "change the view option for the page to a certain profile", profile_name
  it_behaves_like "set end override to specific date and time", end_time, end_date
  it_behaves_like "set start override to specific date and time", start_time, start_date
  it_behaves_like "verify report shows specific date/time override", profile_name, verify_date
  it_behaves_like "verify time override input works on certain time frame", time_frame
end

shared_examples "report custom view" do |report_name, widget_name, profile_name, end_date, end_time, start_date, start_time, verify_date|
  it_behaves_like "go to a specific report", report_name
  it_behaves_like "change to certain widget name page in report", widget_name
  it_behaves_like "change the view option for the page to a certain profile", profile_name
  it_behaves_like "set end override to specific date and time", end_time, end_date
  it_behaves_like "set start override to specific date and time", start_time, start_date
  it_behaves_like "verify report shows specific date/time override", profile_name, verify_date
  it_behaves_like "modify override options then verify cancel button", profile_name, verify_date
  it_behaves_like "reset all override features and verify report back to default", profile_name, verify_date
end

shared_examples "report custom view only set" do |report_name, widget_name, profile_name, end_date, end_time, start_date, start_time, verify_date|
  it_behaves_like "go to a specific report", report_name
  it_behaves_like "change to certain widget name page in report", widget_name
  it_behaves_like "change the view option for the page to a certain profile", profile_name
  it_behaves_like "set end override to specific date and time", end_time, end_date
  it_behaves_like "set start override to specific date and time", start_time, start_date
  it_behaves_like "verify report shows specific date/time override", profile_name, verify_date
end

shared_examples "report custom view no changes to dates only set" do |report_name, widget_name, profile_name|
  it_behaves_like "go to a specific report", report_name
  it_behaves_like "change to certain widget name page in report", widget_name
  it_behaves_like "change the view option for the page to a certain profile", profile_name
  it_behaves_like "verify report shows specific date/time override", profile_name, nil
end

shared_examples "negative testing on report custom view" do |report_name|
  it_behaves_like "go to a specific report", report_name
  describe "Verify that the application properly handles negative testing" do
    it "Set the START and END dates to the exact same one and verify the error message properly informs the user" do
      @ui.click('#report-edit-view-btn')
      sleep 0.5
      @ui.click('#report-edit-view-endswitch .switch_label')
      sleep 0.5
      @ui.click('#report-edit-view-startswitch .switch_label')
      sleep 0.5
      @ui.set_input_val('#report-edit-view-endtime', "12:00 am")
      sleep 0.5
      @ui.set_input_val('#report-edit-view-starttime', "12:00 am")
      sleep 0.5
      @ui.click('#report-edit-view-apply')
      sleep 0.5
      expect(@ui.css('.msgbody').text).to eq("Start date must be at least 30 mins before end date.")
      sleep 5
      @ui.click('#report-edit-view-cancel')
    end
    it "Verify that the report can be filtered for several years and no error is displayed" do
      @ui.click('#report-edit-view-btn')
      sleep 0.5
      @ui.click('#report-edit-view-endswitch .switch_label')
      sleep 0.5
      @ui.click('#report-edit-view-startswitch .switch_label')
      sleep 0.5
      clear_spinner_input('#report-edit-view-startdate')
      @ui.set_input_val('#report-edit-view-startdate', "01/01/2000")
      sleep 0.5
      @ui.click('#report-edit-view-popover .title')
      sleep 0.5
      @ui.click('#report-edit-view-apply')
      sleep 2
      expect(@ui.css('.msgbody')).not_to exist
    end
  end
end


##########################################################################################################################################################
##############################################################  REPORTS DRILLDOWN US 4367  ###############################################################
##########################################################################################################################################################


shared_examples "verify reports drilldown" do
  describe "verify reports drill down" do
    it "Verify the Reports drilldown (Top Applications by Usage) report page and get all the values from it" do
      report_page_widget_list = '.report-page-widget-list'
      first_widget_main = report_page_widget_list + " li:first-child"
      second_widget_main = report_page_widget_list + " li:nth-child(2)"
      expect(@ui.css(first_widget_main + " .report-page-chart-type").text).to eq("Top Applications by usage")
      expect(@ui.css(second_widget_main + " .report-page-chart-type").text).to eq("Top Applications by usage")
      pie_chart_widget = first_widget_main + " .widget .widget-content-wrapper"
      bar_graph_widget = second_widget_main + " .widget .widget-content-wrapper"
      expect(@ui.css(pie_chart_widget + " .content").attribute_value("class")).to include("content candrilldown")
      expect(@ui.css(bar_graph_widget + " .content").attribute_value("class")).to include("content candrilldown")
      @@skip_due_to_nocontent = false
      if (@ui.css(pie_chart_widget + " .content").attribute_value("class").include?("nocontent") and @ui.css(bar_graph_widget + " .content").attribute_value("class").include?("nocontent"))
        @@skip_due_to_nocontent = true
      end
      if @@skip_due_to_nocontent != true
        @@application_percentages = Hash[]
        @@application_percentages_names = Hash[]

        # pie chart
        legend_items_path = pie_chart_widget + " .content .widget_kendo .legend"
        legend_items = @ui.get(:elements , {css: legend_items_path + " .item"})
        expect(legend_items.length).to eq(10)
        legend_items.each_with_index { |legend_item, index|
          a = index + 1
          b = legend_item.element(css: ".item .text").text
          c = legend_item.element(css: ".item .data").text

          @@application_percentages_names[a] = b
          @@application_percentages[a] = c
        }

        @@application_megabytes = Hash[]
        @@application_megabytes_names = Hash[]

        # bar graph
        bars_path = bar_graph_widget + " .content .bar_graph .bars"
        bars = @ui.get(:elements , {css: bars_path + " .row"})
        expect(bars.length).to eq(10)
        bars.each_with_index { |bar, index|
          a = index + 1
          (1..10).each
          if bar.element(css: ".count").text != "10."
            expect(bar.attribute_value("class")).to eq("row drilldown")
          else
            expect(bar.attribute_value("class")).to eq("row lastbar")
          end
          b = bar.element(css: ".bar-container .bar-under .value .label").text
          c = bar.element(css: ".bar-container .bar-under .value .text").text
          @@application_megabytes_names[a] = b
          @@application_megabytes[a] = c
        }

        puts @@application_megabytes_names
        puts @@application_megabytes
        puts @@application_percentages_names
        puts @@application_percentages
        expect(@@application_percentages_names).to eq(@@application_megabytes_names)
      end
    end
  end
end

shared_examples "add drilldown application pages verify pages" do |how_many_applications, what_summary, use_custom_time_frame, end_time, end_date, start_time, start_date|
  describe "Add the Drilldown application pages for the first '#{how_many_applications}' and the summary based on '#{what_summary}'" do
    it "Go to the 'Edit Report' area" do
      @ui.click('#report_menu_btn')
      @ui.click('#report_edit')
    end
    it "Find the 'Top Applications by usage' page and if it dosen't exist create it" do
     @@pages_in_thumbs_list = @ui.get(:elements , {css:".xc-preview-panel-thumbs-list .ui-sortable .xc-preview-panel-thumbs-item"})
        if @@pages_in_thumbs_list.length != 1
          @@pages_in_thumbs_list.each { |page_in_thumbs_list|
            if page_in_thumbs_list.element(css: ".xc-preview-panel-thumbs-item-anchor .xc-preview-panel-thumbs-item-title").attribute_value("title").include?("Top Applications by usage")
              @bool_exists = true
              page_in_thumbs_list.click
              break
            else
              @bool_exists = false
            end
          }
        end
        if @bool_exists == false
          @ui.css(".report-config-body").wait_until(&:present?)
          @browser.execute_script('$("#suggestion_box").hide()')
          @ui.click('#report-add-page')
          sleep 1
          @ui.set_dropdown_entry('report-page-widget', "Top Applications by usage")
          sleep 0.5
          @ui.click("#report-page-description")
          sleep 0.5
          @ui.set_dropdown_entry('report-page-range', "Last 30 Days")
        end
    end
    it "Enable the drill down data controls (validate all controls)" do
      expect(@ui.get(:elements , {css:'.report-config-drilldown .xc-field'}).length).to eq(6)
      @ui.click(".report-config-drilldown .switch .switch_label")
      sleep 0.5
      expect(@ui.get(:elements , {css:'.report-config-drilldown .xc-field'}).length).to eq(2)
      @ui.click(".report-config-drilldown .switch .switch_label")
      sleep 0.5
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(3) div").text).to eq("How many results do you want to include?")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(4) .xc-field-label-top").text).to eq("Top:")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(4) .spinner").attribute_value("max")).to eq("10")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(4) .spinner").attribute_value("min")).to eq("1")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(4) .spinner").attribute_value("maxlength")).to eq("2")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(5) div").text).to eq("Select the summaries you want to include per result:")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child .mac_chk_label").text).to eq("Top Clients (by Usage)")
      expect(@ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) .mac_chk_label").text).to eq("Access Points (by Usage)")
      sleep 0.5
      @ui.click("#report-page-description")
    end
    it "Set the value '#{how_many_applications}' to the included results spinner control" do
      @ui.set_input_val(".report-config-drilldown .xc-field:nth-of-type(4) .spinner", how_many_applications)
      sleep 0.5
      @ui.click("#report-page-description")
    end
    it "Place a tick for the corresponding summary" do
      if what_summary == "Top Clients (by Usage)"
        if @ui.get(:checkbox, {css: ".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input"}).set? == false
          @ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input").click
        end
        if @ui.get(:checkbox, {css: ".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) input"}).set? == true
          @ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) input").click
        end
      elsif what_summary == "Access Points (by Usage)"
        if @ui.get(:checkbox, {css: ".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input"}).set? == true
          @ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input").click
        end
        if @ui.get(:checkbox, {css: ".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) input"}).set? == false
          @ui.css(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) input").click
        end
      end
    end
    it "Verify that the application shows that the page has drill down elements (icon)" do
      expect(@ui.css('.xc-preview-panel-thumbs-list .ui-sortable li:nth-child(2) a .xc-preview-panel-thumbs-item-img-drilldown.xc-icon.xc-icon-drilldown')).to be_present
      @@new_count_pages_in_thumbs_list = @ui.get(:elements , {css:".xc-preview-panel-thumbs-list .ui-sortable .xc-preview-panel-thumbs-item"})
      expect(@@pages_in_thumbs_list.length).to eq(2)
      #expect(@@pages_in_thumbs_list.length + how_many_applications.to_i).to eq(@@new_count_pages_in_thumbs_list.length)
    end
    it "Press the <SAVE> button" do
      @ui.click('.report-config-save')
    end
  end
  if use_custom_time_frame == true
    it_behaves_like "set end override to specific date and time", "10:00 am", "7/1/2017"
    it_behaves_like "set start override to specific date and time", "10:00 am", "6/1/2017"
  end
  describe "Verify the report's pages and elements have the proper values" do
    it "Verify that the 'View Report' shows the proper number of pages and proper page titles" do
      how_many_pages = @ui.css(".nssg-paging-total").text
       puts how_many_pages
      if how_many_pages.length == 4
        how_many_pages = how_many_pages.slice(3).to_i
      elsif how_many_pages.length == 5
        how_many_pages = how_many_pages.slice(3..4).to_i
      end

        expect(how_many_pages).to eq(how_many_applications + 2)
        (1..how_many_pages).each do |i|
          if i != 1 and i != 2
            a = i - 2
            puts "expected"
            puts "Page number --- #{i}"
            if @@skip_due_to_nocontent != true
              puts "Application name --- #{@@application_percentages_names[a]}"
            end
            2.times do
              puts 'FII ATENT AMU'
              sleep 1
            end
            expect(@ui.get(:input , {css: ".nssg-paging-current"}).value.to_i).to eq(i)
            sleep 1
            if @@skip_due_to_nocontent == true
              expect(@ui.css('.report-page .report-page-description').text).to eq("")
              expect(@ui.css('.report-page .report-page-widget-list').lis.length).to eq(0)
            else
              expect(@ui.css('.report-page .report-page-widget-list li:first-child .report-page-chart-type').text).to include(@@application_percentages_names[a])
              expect(@ui.css('.report-page .report-page-widget-list li:last-child .report-page-chart-type').text).to eq("Applications / " + @@application_percentages_names[a])
              expect(@ui.css('.report-page .report-page-widget-list li:first-child .report-page-chart-subtype').text).to eq(what_summary)
              expect(@ui.css('.report-page .report-page-widget-list li:last-child .report-page-chart-subtype').text).to eq(what_summary)
              if use_custom_time_frame == true
                expect(@ui.css('.report-page .report-page-widget-list li:first-child .report-page-chart-range').text).to eq("")
                expect(@ui.css('.report-page .report-page-widget-list li:last-child .report-page-chart-range').text).to eq("")
              else
                expect(@ui.css('.report-page .report-page-widget-list li:first-child .report-page-chart-range').text).to eq(use_custom_time_frame)
                expect(@ui.css('.report-page .report-page-widget-list li:last-child .report-page-chart-range').text).to eq(use_custom_time_frame)
              end
            end
          end
          if i != how_many_pages
            @ui.click(".nssg-paging-next")
          end
        end
    end
  end
end

shared_examples "add drilldown application pages verify values" do |how_many_applications, what_summary, use_custom_time_frame, end_time, end_date, start_time, start_date|
  describe "Add the Drilldown application pages for the first '#{how_many_applications}' and the summary based on '#{what_summary}'" do
    it "Go to the 'Edit Report' area" do
      @ui.click('#report_menu_btn')
      @ui.click('#report_edit')
    end
    it "Find the 'Top Applications by usage' page and if it dosen't exist create it" do
     @@pages_in_thumbs_list = @ui.get(:elements , {css:".xc-preview-panel-thumbs-list .ui-sortable .xc-preview-panel-thumbs-item"})
        if @@pages_in_thumbs_list.length != 1
          @@pages_in_thumbs_list.each { |page_in_thumbs_list|
            if page_in_thumbs_list.element(css: ".xc-preview-panel-thumbs-item-anchor .xc-preview-panel-thumbs-item-title").attribute_value("title").include?("Top Applications by usage")
              @bool_exists = true
              page_in_thumbs_list.click
              break
            else
              @bool_exists = false
            end
          }
        end
        if @bool_exists == false
          @ui.css(".report-config-body").wait_until(&:present?)
          @browser.execute_script('$("#suggestion_box").hide()')
          @ui.click('#report-add-page')
          sleep 1
          @ui.set_dropdown_entry('report-page-widget', "Top Applications by usage")
          sleep 0.5
          @ui.click("#report-page-description")
          sleep 0.5
          @ui.set_dropdown_entry('report-page-range', "Last 30 Days")
        end
    end
    it "Set the value '#{how_many_applications}' to the included results spinner control" do
      @ui.set_input_val(".report-config-drilldown .xc-field:nth-of-type(4) .spinner", how_many_applications)
      sleep 0.5
      @ui.click("#report-page-description")
    end
    it "Place a tick for the corresponding summary" do
      @ui.click(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input + .mac_chk_label")
      if what_summary == "Top Clients (by Usage)"
        @ui.click(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:first-child input + .mac_chk_label")
      elsif what_summary == "Access Points (by Usage)"
        @ui.click(".report-config-drilldown .xc-field:nth-of-type(6) .report-config-drilldown-selection ul li:nth-child(2) input + .mac_chk_label")
      end
    end
    it "Press the <SAVE> button" do
      @ui.click('.report-config-save')
    end
  end
  if use_custom_time_frame == true
    it_behaves_like "set end override to specific date and time", "10:00 am", "7/1/2017"
    it_behaves_like "set start override to specific date and time", "10:00 am", "6/1/2017"
  end
  describe "Verify the report's pages and elements have the proper values" do
    it "Verify that the report pages all show the proper data values for each Access Point (total Download)" do
      how_many_pages = @ui.css(".nssg-paging-total").text
      if how_many_pages.length == 4
        how_many_pages = how_many_pages.slice(3).to_i
      elsif how_many_pages.length == 5
        how_many_pages = how_many_pages.slice(3..4).to_i
      end
        (1..how_many_pages).each do |i|
          if i != 1 and i != 2
            a = i - 2
            expect(@ui.get(:input , {css: ".nssg-paging-current"}).value.to_i).to eq(i)
            sleep 1
            if @@skip_due_to_nocontent != true
              @total_usage = 0
              how_many_lines = @ui.css('.report-page .base_grid table tbody').trs.length
              for o in 0..how_many_lines do
                if o != 0
                  if what_summary == "Top Clients (by Usage)"
                    total_column = 5
                  elsif what_summary == "Access Points (by Usage)"
                    total_column = 6
                  end
                  line_total_cell = @ui.css(".report-page .base_grid table tbody tr:nth-child(#{o}) td:nth-child(#{total_column})").text
                  if line_total_cell.include?("GB")
                    line_usage_value = line_total_cell.to_f * 1000
                  elsif line_total_cell.include?("MB")
                    line_usage_value = line_total_cell.to_f
                  elsif line_total_cell.include?("KB")
                    line_usage_value = line_total_cell.to_f / 1000
                  elsif line_total_cell.include?("Bytes")
                    line_usage_value = line_total_cell.to_f / 1000000
                  end
                  @total_usage = @total_usage + line_usage_value
                  if @@application_megabytes[a].include?("GB")
                    application_download = @@application_megabytes[a].tr("(","").tr(")","").to_f * 1000
                  elsif @@application_megabytes[a].include?("MB")
                    application_download = @@application_megabytes[a].tr("(","").tr(")","").to_f
                  elsif @@application_megabytes[a].include?("KB")
                    application_download = @@application_megabytes[a].tr("(","").tr(")","").to_f / 1000
                  elsif @@application_megabytes[a].include?("Bytes")
                    application_download = @@application_megabytes[a].tr("(","").tr(")","").to_f / 1000000
                  end
                  expect(line_total_cell).to be_present
                  @total_usage_tolerance = @total_usage*99/100
                  puts ""
                  puts "line total cell #{line_total_cell}"
                  puts "total_usage #{@total_usage}"
                  puts "total_usage 99% #{@total_usage_tolerance}"
                  puts "application download #{application_download}"
                  puts ""
                  if application_download > @total_usage + @total_usage_tolerance
                    log "BIG DIFFERENCE - INVESTIGATE PLESE"
                  else
                    expect(@total_usage).to be_within(@total_usage_tolerance).of(application_download)
                  end
                end
              end
            end
          end
          if i != how_many_pages
            @ui.click(".nssg-paging-next")
          end
        end

    end
   
  end
end

##########################################################################################################################################################
##############################################################  REPORTS EMAIL US 4742  ###################################################################
##########################################################################################################################################################

def login_to_gmail(user_name, user_password)
  #@ui_new.set_input_val("#Email", user_name)
  @ui_new.set_input_val(".whsOnd.zHQkBf", user_name)
  sleep 2
  #@ui_new.click("#next")
  @ui_new.click("#identifierNext")
  sleep 3
  #@ui_new.set_input_val("#Passwd", user_password)
  @ui_new.set_input_val(".whsOnd.zHQkBf", user_password)
  sleep 2
  #@ui_new.click("#signIn")
  @ui_new.click("#passwordNext")
  sleep 3
  @ui_new.css(".z0 .T-I").wait_until(&:present?)
  expect(@ui_new.css(".z0 .T-I")).to be_present
end

def search_for_certain_email_in_google_grid(email_recepient_and_subject, email_description)
  email_found = false
  email_css = ""
  expect(@ui_new.css('.Cp table tbody')).to be_present
  sleep 2
  grid_length = @ui_new.css('.Cp table tbody').trs.length
  (1..grid_length).each do |grid_length_new|
    css_string = ".Cp table tbody tr:nth-child(#{grid_length_new})"
    if @ui_new.css(css_string + " td:nth-child(6) .y6 span:first-child b").exists?
      puts @ui_new.css(css_string + " td:nth-child(6) .y6 span:first-child b").text
      if @ui_new.css(css_string + " td:nth-child(6) .y6 span:first-child b").text.include? email_recepient_and_subject
        email_css = css_string + " td:nth-child(6) .y6"
        email_found = true
        break
      end
    else
      puts @ui_new.css(css_string + " td:nth-child(6) .y6 span:first-child").text
      if @ui_new.css(css_string + " td:nth-child(6) .y6 span:first-child").text.include? email_recepient_and_subject
        email_css = css_string + " td:nth-child(6)"# .y6"
        email_found = true
        break
      end
    end
  end
  expect(email_found).to eq(true)
  puts @ui_new.css(email_css + " .y2").text
  #expect(@ui_new.css(email_css + " .y2").text).to include(email_description)
  return email_css
end

def verify_report_email_features(report_name, what_email)
  case what_email
    when "Emailed Report"
      expect(@ui_new.css('.Cp table tbody')).not_to be_visible
      expect(@ui_new.css('.nH .Bs td:first-child')).to be_present
      # body = @ui_new.css(".nH .Bs td:first-child table[class*='frame']") 
      body = @ui_new.css(".nH .Bs td:first-child")
      expect(body.element(:css => "a[href = 'https://support.cambiumnetworks.com']")).to be_present
      expect(body.element(:css => "img[alt = 'Riverbed Support']")).to be_present
      expect(body.element(:css => "img[alt = 'Riverbed Support']").attribute_value("src")).to eq('https://ci3.googleusercontent.com/proxy/VZxKTX_hqJbVmbe9ASaZT_GwtriANTWKFSeUNquo1NQDGBhoowXF8VWEQ5oIOzyyJ48cc3KqAB9Mfg8ZwKq4VwFsD4vC83n3u9V1Xud_4X0SkSgfQxY=s0-d-e1-ft#https://support.riverbed.com/content/dam/images/rb-support-logo.png')
      expect(body.element(:css => "h1").text).to eq("Dear Customer,")
      ps =  body.elements(:css => "p")
      expected_texts = ["Please find the report #{report_name} attached to this email.", "This is a report email from XMS-Cloud. You received this email because #{@username} requested this report be sent to you.", "Sincerely,\nCambium Networks Support\nsupport.cambiumnetworks.com"]
      ps.each_with_index do |p, i|
        expect(p.text).to eq(expected_texts[i])
      end
      # expected_text = "Dear Customer,\nPlease find the report #{report_name} attached to this email.\nThis is a report email from Xirrus Management System (XMS). You received this email because #{@username} requested this report be sent to you.\nIf you have any questions about any of our products, please feel free to contact Xirrus Customer Support:\nEmail: support@xirrus.com\nWeb: http://support.xirrus.com\nPhone:\nUnited States and Canada +1.800.947.7871 (US Toll Free) or +1.805.262.1600 (Direct)\nEurope, Middle East, and Africa +44 20.3239.8644\nAustralia 1.300.947.787 (Within Australia)\nAsia and Oceania +61.2.8006.0622\nLatin, Central, and South America +1.805.262.1600\nThank you,\n\nThe Xirrus Team"
      # expect(body.element(:css => "table td").text).to eq(expected_text)
      expect(@ui_new.css('.aQH span:first-child')).to be_present
      expect(@ui_new.css('.aQH span:nth-child(2)')).not_to be_present
      expect(@ui_new.css('.aYy .aV3').text).to eq(report_name + ".pdf")
    when "Support or Feedback"
      expect(@ui_new.css('.Cp table tbody')).not_to be_visible
      expect(@ui_new.css('.nH .Bs td:first-child')).to be_present
      #table_css = ".ii.gt.adP.adO table tbody tr td div"
      #expect(@ui_new.css(table_css)).to exist
      #puts @ui_new.css(table_css).text
      #if report_name.class == Array
      #  report_name.each do |string_to_verify|
      #    expect(@ui_new.css(table_css).text).to include(string_to_verify)
      #  end
      #end
  end
end

shared_examples "launch new browser window and verify report email received" do |user_email, subject, report_name, description, what_email|
  describe  "Launch a new browser window for 'Chrome' and verify that the email containing '#{report_name}' was properly received" do
      it "Open a new browser window, go to the BULK email address and login, search for the email for '#{user_email}' with the subject '#{subject} + #{report_name}', open the email and verify it's content " do
        sleep 20
        @browser_new = Watir::Browser.new :chrome
        @browser_new.driver.manage.window.maximize
        @ui_new = GUI::UI.new(args = {browser: @browser_new})
        @browser_new.goto("https://mail.google.com/mail")
        sleep 2
        login_to_gmail("xirrusms@gmail.com", "Xirrus!234")
        searched_subject = "To: #{user_email} || Subject: #{subject}"# + "#{report_name}"
        puts "Searched objects length = '#{searched_subject.length}'"
        if searched_subject.length > 90
          searched_subject = searched_subject[0,searched_subject.rindex(/./,87)].rstrip# + "..."
        end
        puts "Searched Subject = '#{searched_subject}'"
        @email_css = search_for_certain_email_in_google_grid(searched_subject, description)
        puts "@email_css = '#{@email_css}'"
        @ui_new.click(@email_css)
        sleep 2
        verify_report_email_features(report_name, what_email)
        sleep 1
        @browser_new.quit
      end
  end
end

shared_examples "verify the email report modal" do |see_recurring, close|
  describe "Press the 'Email Report...' button and verify the modal content" do
    it "Press the 'Email Report...' button and verify the modal content" do
      if @ui.css('.nssg-paging-first').visible?
        @ui.click('.nssg-paging-first')
        sleep 1
      end
      #report_name = @ui.css('.report-cover-title').text
      if @ui.css('#email-report-btn').exists?
        expect(@ui.css('#email-report-btn')).to be_present
        sleep 1
        @ui.click('#email-report-btn')
      end
      sleep 1
      @ui.css('#reports_emailReport').wait_until(&:present?)
      verify_hash = Hash[".commonTitle" => "Email Report", ".content .field:nth-child(1) .field_label" => "Email Address(es):", ".buttons #newprofile_cancel" => "Cancel", ".buttons #newprofile_create" => "DONE", "#email_field" => "text"] #".content .field:nth-child(2) .field_label" => "Subject:",, "#subject_field" => "text"
      verify_hash.keys.each do |key|
        if ["#email_field", "#subject_field"].include? key
          expect(@ui.css("#reports_emailReport #{key}").attribute_value("type")).to eq(verify_hash[key])
        else
          expect(@ui.css("#reports_emailReport #{key}").text).to eq(verify_hash[key])
        end
      end
      if see_recurring == true
        #expect(@ui.get(:input , {id: "subject_field"}).value).to eq(report_name)
        expect(@ui.css("#reports_emailReport .content .field:nth-child(2) .field_label").text).to eq("Make Recurring:")
        @ui.click("#reports_emailReport .recurring_container .switch_label")
        sleep 1
        verify_hash = Hash[".recurring_container .frequency-pickers-container .ko_dropdownlist_button .text" => "Daily", ".recurring_container .frequency-pickers-container .spinner" => "text", ".recurring_container .time-zone-picker .ko_dropdownlist_button .text" => "(GMT-11:00) Midway Island, Samoa"] # .recurring_container .recurring-desc" => "This report's largest time range is set to \"last day\". \n The recurrance is set to match by default. \n You can adjust this to another timeframe.",
        verify_hash.keys.each do |key|
          if key.include? ".ko_dropdownlist_button"
            expect(@ui.css("#reports_emailReport #{key}").attribute_value("title")).to eq(verify_hash[key])
         # elsif key.include? ".recurring-desc"
         #   expect(@ui.css("#reports_emailReport #{key}").text).to eq(verify_hash[key])
          else
            expect(@ui.css("#reports_emailReport #{key}").attribute_value("type")).to eq(verify_hash[key])
          end
        end
      else
        expect(@ui.css(".recurring_container")).not_to exist
      end
    end
    if close == true
      it "Press the <CANCEL> button" do
        @ui.click('#newprofile_cancel')
        sleep 3
        expect(@ui.css('#reports_emailReport').visible?).to eq(false)
      end
    end
  end
end

def rezolve_email_addresses(email_address)
  if email_address.class.to_s.capitalize == "Array"
    array_of_emails = true
  else
    array_of_emails = false
  end
  if array_of_emails == true
    email_address_new = ""
    email_address.each do |email|
      if email_address.first == email
        email_address_new = email_address_new.gsub!(/$/, "#{email}")
      else
        email_address_new = email_address_new.gsub!(/$/, ", #{email}")
      end
    end
  elsif array_of_emails == false
    email_address_new = email_address
  end
  return email_address_new
end

def select_dropdownlist_entry_on_email_report_modal(css_path_of_control, value)
  @ui.click(css_path_of_control)
  sleep 2
  dropdown_list = @ui.css('.ko_dropdownlist_list.active')
  sleep 0.5
  dropdown_list.li(text: value).click
end

shared_examples "set email report" do |email_address, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, skip_verify_modal|
  if skip_verify_modal != true
    puts "HERE"
    it_behaves_like "verify the email report modal", see_recurring, false
  end
  describe "Set the value(s) '#{email_address}' for the Email Addresses in a report" do
    if email_address != ""
      it "Set the email address to the value '#{email_address}'" do
        @ui.set_input_val("#email_field", rezolve_email_addresses(email_address))
        sleep 1
        expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "input", "#email_field")).to eq(rezolve_email_addresses(email_address))
        sleep 1
      end
    end
    if make_recurring == true
      it "Enable the recurring switch and set the period to '#{time_span}, #{hour} and #{offset}'" do
        expect(@ui.css('.recurring_container .switch .switch_label')).to be_present
        if @ui.get(:checkbox , {css: ".recurring_container .switch .switch_checkbox"}).set? == false
          @ui.click('.recurring_container .switch .switch_label')
        end
        expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "checkbox", ".recurring_container .switch .switch_checkbox")).to eq(true)
        sleep 1
        expect(@ui.css('.frequency-pickers-container')).to be_present
        if @ui.css('.frequency-pickers-container .ko_dropdownlist_button .text').text != time_span
          select_dropdownlist_entry_on_email_report_modal(".frequency-pickers-container .ko_dropdownlist .ko_dropdownlist_button .arrow", time_span)
          sleep 1
          expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "dropdownlist", ".frequency-pickers-container .ko_dropdownlist_button .text")).to eq(time_span)
        end
        case time_span
          when "Weekly"
            if @ui.css(".frequency-pickers-container .ko_dropdownlist:nth-of-type(2) .ko_dropdownlist_button .text").text != time_span_day
              select_dropdownlist_entry_on_email_report_modal(".frequency-pickers-container .ko_dropdownlist:nth-of-type(2) .ko_dropdownlist_button .arrow", time_span_day)
              sleep 1
              expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "dropdownlist", ".frequency-pickers-container .ko_dropdownlist:nth-of-type(2) .ko_dropdownlist_button .text")).to eq(time_span_day)
            end
          when "Monthly"
            select_dropdownlist_entry_on_email_report_modal(".frequency-pickers-container .ko_dropdownlist:nth-of-type(2) .ko_dropdownlist_button .arrow", time_span_which_day)
            sleep 1
            expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "dropdownlist", ".frequency-pickers-container .ko_dropdownlist:nth-of-type(2) .ko_dropdownlist_button .text")).to eq(time_span_which_day)
            sleep 1
            select_dropdownlist_entry_on_email_report_modal(".frequency-pickers-container .ko_dropdownlist:nth-of-type(3) .ko_dropdownlist_button .arrow", time_span_day)
            sleep 1
            expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "dropdownlist", ".frequency-pickers-container .ko_dropdownlist:nth-of-type(3) .ko_dropdownlist_button .text")).to eq(time_span_day)
        end
        if @ui.get(:input , {css: '.frequency-pickers-container .spinner'}).value != hour
          @ui.set_input_val(".frequency-pickers-container .spinner", hour)
          sleep 1
          expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "input", ".frequency-pickers-container .spinner")).to eq(hour)
        end
        if @ui.css('.time-zone-picker .ko_dropdownlist_button .text').text != offset
          @ui.set_dropdown_entry_by_path(".time-zone-picker", offset)
          sleep 1
          expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "dropdownlist", ".time-zone-picker .ko_dropdownlist_button .text")).to eq(offset)
        end
      end
    elsif make_recurring == false and see_recurring == true
      it "Set the reccuring switch to 'No'" do
        sleep 2
        puts @ui.get(:checkbox , {css: ".recurring_container .switch .switch_checkbox"}).set?
        if @ui.get(:checkbox , {css: ".recurring_container .switch .switch_checkbox"}).set? == true
          @ui.css(".recurring_container .switch .switch_label").click
          sleep 3
          puts @ui.get(:checkbox , {css: ".recurring_container .switch .switch_checkbox"}).set?
         end
        if @ui.get(:checkbox , {css: ".recurring_container .switch .switch_checkbox"}).set? == true
          expect(@ui.click_on_certain_control_and_return_recently_added_value("#reports_emailReport .commonTitle", "checkbox", ".recurring_container .switch .switch_checkbox")).to eq(true)
        end
      end
    end
    it "Press the <DONE> button" do
      @ui.click('#newprofile_create')
      sleep 3
      expect(@ui.css('#reports_emailReport').visible?).to eq(false)
    end
  end
end

shared_examples "verify reports scheduled tab" do
  it_behaves_like "go to reports landing page"
  describe "Verify the Scheduled tab on the Reports area" do
    it "Go to the 'Scheduled' tab" do
      if !@browser.url.include?("/#reports/scheduled")
        @ui.click('#main_container .right-tab-menu a:nth-child(2)')
        sleep 2
        expect(@browser.url).to include("/#reports/scheduled")
      end
    end
    it "Verify the grid's general features" do
      strings = [".nssg-paging-selector-container", ".nssg-paging-count", ".nssg-paging-controls", ".nssg-refresh"]
      strings.each do |string|
        expect(@ui.css(string)).to be_present
      end
      expect(@ui.css('.reports_container .commonTitle').text).to include("Scheduled Report")
      #expect(@ui.css('.reports_container .commonSubtitle').text).to eq("Manage scheduled emails")
      table_headers = Hash[1 => "", 2 => "", 3 => "Report", 4 => "Recipient", 5 => "Schedule", 6 => "Filter"]
      #table_headers = Hash[1 => "", 2 => "", 3 => "Email Address", 4 => "Report", 5 => "Recurring on", 6 => "Conditions"]
      (1..6).each do |i|
        if i == 1
          expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text")).not_to exist
          expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-th-actions")
        elsif i == 2
          expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text")).not_to exist
          expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-th-select")
        #elsif i == 4
        #  expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text").text).to eq(table_headers[i])
        #  expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i})").attribute_value("class")).to include("nssg-sortable")
        else
          expect(@ui.css(".nssg-table .nssg-thead tr th:nth-child(#{i}) .nssg-th-text").text).to eq(table_headers[i])
        end
      end
      expect(@ui.css('.nssg-table thead tr').ths.length).to eq(6)
    end
  end
end

def perform_action(action, searched_column, searched_string)
  line_css = @ui.find_certain_line_in_grid(searched_column, searched_string)
  @ui.css(line_css + " .nssg-td-select").hover
  sleep 0.5
  expect(@ui.css(line_css + " .nssg-td-actions .nssg-actions-container")).to be_present
  if action == "delete"
    @ui.click(line_css + " .nssg-td-actions .nssg-actions-container .nssg-action-delete")
  elsif action == "invoke"
    @ui.click(line_css + " .nssg-td-actions .nssg-actions-container .nssg-action-invoke")
  elsif action == "tick delete"
    @ui.click(line_css + " .nssg-td-select .mac_chk_label")
    sleep 0.5
    expect(@ui.get(:checkbox , {css: line_css + " .nssg-td-select .mac_chk"}).set?).to eq(true)
    expect(@ui.css("#reports-scheduled-delete")).to be_present
    @ui.click("#reports-scheduled-delete")
  elsif action == "tick"
    @ui.click(line_css + " .nssg-td-select .mac_chk_label")
    sleep 0.5
    expect(@ui.get(:checkbox , {css: line_css + " .nssg-td-select .mac_chk"}).set?).to eq(true)
  end
end

shared_examples "find and verify certain line" do |email_address, report_name, recurring_on, conditions, nil_if_expected_not_to_be_found|
  describe "Find and verify a certain line in the grid" do
   it "Find and verify the line with the values '#{email_address}, #{report_name}, #{recurring_on}, #{conditions}' exists" do
      if nil_if_expected_not_to_be_found != nil
        line_css = @ui.find_certain_line_in_grid("Report", report_name)
        verify_hash = Hash[".emails" => email_address, ".report" => report_name, ".recurringOn" => recurring_on, ".conditions" => conditions]
        verify_hash.keys.each do |key|
          expect(@ui.css(line_css + " " + key + " .nssg-td-text").text).to eq(verify_hash[key])
        end
      else
        expect(@ui.css('table tbody li')).not_to exist
      end
    end
  end
end

shared_examples "certain action on scheduled report line" do |email_address, report_name, recurring_on, conditions, action, email_address_new, see_recurring, make_recurring, time_span, time_span_day, time_span_which_day, hour, offset, verify_recurring_on|
  if action != "verify not exists"
    it_behaves_like "find and verify certain line", email_address, report_name, recurring_on, conditions, true
    if action != "verify"
      describe "'#{action}' the scheduled report line with the email address of '#{email_address}' and report name '#{report_name}'" do
        it "Perform the action '#{action}' on the needed line" do
          perform_action(action, "Report", report_name)
        end
      end
      case action
        when "invoke"
          #describe "Open the reports Email Edit Modal" do
          #  it "Open the Reports Email Edit modal" do
          #    @ui.click('#email-report-btn')
          #    sleep 1
          #    @ui.css('#reports_emailReport').wait_until(&:present?)
          #  end
          #end
          objects_hash = Hash["email_address" => email_address_new, "see_recurring" => see_recurring, "make_recurring" => make_recurring, "time_span" => time_span, "time_span_day" => time_span_day, "time_span_which_day" => time_span_which_day, "hour" => hour, "offset" => offset]
          it_behaves_like "set email report", objects_hash["email_address"], objects_hash["see_recurring"], objects_hash["make_recurring"], objects_hash["time_span"], objects_hash["time_span_day"], objects_hash["time_span_which_day"], objects_hash["hour"], objects_hash["offset"], true
          if email_address_new == ""
            email_address_new = email_address
          end
          if verify_recurring_on == ""
            verify_recurring_on = recurring_on
          end
          it_behaves_like "find and verify certain line", email_address_new, report_name, verify_recurring_on, conditions, true
        when "delete", "tick delete"
          describe "Delete the entry from the grid" do
            it "Access the deletion prompt and verify that the line isn't present in the grid anymore" do
              @ui.css('.dialogOverlay.confirm').wait_until(&:present?)
              expect(@ui.css('.confirm .title span').text).to eq("Delete scheduled report?")
              expect(@ui.css('.confirm .msgbody div:first-child').text).to eq("Are you sure you want to delete this scheduled report?")
              @ui.click('#_jq_dlg_btn_1')
              @ui.css('.dialogOverlay.confirm').wait_while_present
              sleep 1
              if @ui.css('.nssg-table').exists? != false
                if @ui.css('.nssg-table tbody tr').exists? != false
                  expect(@ui.find_certain_line_in_grid("Report", report_name)).to eq(nil)
                end
              end
            end
          end
      end
    end
  else
    it_behaves_like "find and verify certain line", email_address, report_name, recurring_on, conditions, nil
  end
end

############## OTHER JOBS ##############
shared_examples "copy emails from the bulk email to another folder" do
  describe "Copy all emails from the Xirrus bulk email to another folder for greater visibility" do
    it "Perform the needed actions" do
        @browser_new = Watir::Browser.new :chrome
        @browser_new.driver.manage.window.maximize
        @ui_new = XMS::NG::UI.new(args = {browser: @browser_new})
        @browser_new.goto("https://mail.google.com/mail")
        sleep 2
        login_to_gmail("xirrusms@gmail.com", "Xirrus!234")
        puts ""
        1000.times do
          puts @ui_new.css('.wT .J-Ke.n0').text
          @ui_new.click(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh")
          sleep 0.3
          if @ui_new.css(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh").parent.attribute_value("aria-checked") != "true"
            @ui_new.click(".aeH div:last-child .J-JN-M-I-Jm .T-Jo-auh")
            sleep 0.3
          end
          @ui_new.css(".aeH div:last-child .ns .asa .ase").wait_until(&:present?)
          @ui_new.click(".aeH div:last-child .ns .asa .ase")
          #@browser_new.execute_script("$('.aeH div:last-child .G-tf .ns .asa .ase').click()")
          sleep 0.3
          @ui_new.css(".J-M.agd.aYO .J-M-Jz div:first-child div").wait_until(&:present?)
          @ui_new.click(".J-M.agd.aYO .J-M-Jz div:first-child div")
          sleep 0.3
          if @ui_new.css('.v1').visible?
            @ui_new.css('.v1').wait_while_present
          end
          @ui_new.css('.bofITb').wait_until(&:present?)
          expect(@ui_new.css('.bofITb').text).to eq("100 conversations have been moved to \"Before September 2017\".")
          sleep 0.7
        end
        @browser_new.quit
    end
  end
end