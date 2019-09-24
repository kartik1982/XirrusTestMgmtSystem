shared_examples "go to analytics area" do # Created on: 05/02/2017
	describe "Go to the Reports Analythics area" do
		it "Open the Reports dropdown menu and press the 'Analytics' link" do
			if @browser.url.include?('/#analytics') == false
				expect(@ui.css('#header_nav_reports')).to be_visible
				@ui.click('#header_nav_reports') and sleep 1
				expect(@ui.css('#header_nav_reports .drop_menu_nav')).to be_visible and expect(@ui.css('#header_nav_reports .drop_menu_nav #analytics_menu_item')).to be_visible
				@ui.click('#analytics_menu_item a')
				sleep 5
				@ui.css('.analytics-header span').wait_until(&:present?) and expect(@ui.css('.analytics-header span').text).to eq('Analytics') and expect(@browser.url).to include('/#analytics')
			end
		end
	end
end

shared_examples "verify analytics landing page" do |empty_landing_page, number_of_widgets| # Created on: 05/02/2017
	it_behaves_like "go to analytics area"
	describe "Verify the Analytics landing page contains the proper elements" do
		it "Verify that the Analytics root container is visible" do
			expect(@ui.css('.analytics-root')).to be_visible
		end
		if empty_landing_page == true
			it "Verify the 'Landing page' elements (no widgets)" do
				expect(@ui.css('.analytics-root .analytics-header span').text).to eq("Analytics")
				expect(@ui.css('.analytics-root .widgets-list').divs.length).to eq(3)
				expect(@ui.css('.analytics-root .widgets-list .new-widget-button .new-item-icon')).to be_present
				expect(@ui.css('.analytics-root .widgets-list .new-widget-button .descriptive-text').text).to eq("")
				@ui.click('.analytics-root .analytics-header span')
				@ui.css('.analytics-root .widgets-list .new-widget-button .new-item-icon').hover
				expect(@ui.css('.analytics-root .widgets-list .new-widget-button .descriptive-text').text).to eq("Choose Visualization…")
			end
		else
			it "Verify the 'Landing Page' elements (with widgets)" do
				expect(@ui.css('.analytics-root .analytics-header span').text).to eq("Analytics")
				expect(@ui.get(:elements , {css: ".analytics-root .widgets-list xc-analytics-widget"}).length).to eq(number_of_widgets)
			end
		end
	end
end

shared_examples "verify add edit widget modal" do |use_new_widget_button, close_widget| # Created on: 05/03/2017
	describe "Verify the 'Add/Edit Widget' modal" do
		if use_new_widget_button == true
			it "Open the 'Add/Edit Widget' modal" do
				@ui.click('.analytics-root .widgets-list .new-widget-button .new-item-icon')
				@ui.css("xc-modal-placeholder").wait_until(&:present?)
				@ui.css("xc-modal-placeholder .xc-modal-close").wait_until(&:present?)
			end
		end
		it "Verify the widget content" do
			verify_hash = Hash['xc-modal-container xc-modal-title' => "Select A Visualization to Add", 'xc-modal-container xc-modal-description' => "Select the visualization you would like to display", 'xc-modal-placeholder .xc-modal-close' => true,'xc-tabs-container xc-tab:first-child' => "selected dark", 'xc-tabs-container xc-tab:nth-child(2)' => "dark", 'xc-tabs-container xc-tab:first-child xc-tab-label' => "New", 'xc-tabs-container xc-tab:nth-child(2) xc-tab-label' => "Previous", 'xc-modal-container .widget-editor-container .attr-selection li:first-child' => "Number of Visitors", 'xc-modal-container .widget-editor-container .attr-selection li:nth-child(2)' => "Avg. Dwell Time", 'xc-modal-container .widget-editor-container div:nth-child(1) .row input' => true, '.widget-editor-container .row.groups-container label' => "Group:", '.widget-editor-container .row.groups-container span' => "ko_dropdownlist", '.widget-editor-container .row.dates-container .inner-row' => "Date Range", '.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .label' => "From:", '.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .label' => "To:", '.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input' => "datepicker", '.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input' => "datepicker", '.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .datepicker_icon' => true, '.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .datepicker_icon' => true, 'xc-modal-buttons button:nth-child(1)' => true, 'xc-modal-buttons .button' => "Cancel", 'xc-modal-buttons button:nth-child(2)' => true, 'xc-modal-buttons .button.orange' => "ADD"]
			verify_hash.keys.each do |key|
				if key.include?('-tabs-')
					if key.include?('label')
						expect(@ui.css(key).text).to eq(verify_hash[key])
					else
						expect(@ui.css(key).attribute_value("class")).to eq(verify_hash[key])
					end
				elsif key.include?('.widget-editor-container')
					if key.include?('attr-selection') or key.include?('label') or key.end_with?('inner-row')
						expect(@ui.css(key).text).to eq(verify_hash[key])
					elsif key.include?('span') or key.include?('-time input')
						expect(@ui.css(key).attribute_value("class")).to eq(verify_hash[key])
					else
						expect(@ui.css(key).visible?).to eq(verify_hash[key])
					end
				elsif key.include?('.xc-modal-close') or key.include?('button:')
					expect(@ui.css(key).visible?).to eq(verify_hash[key])
				else
					expect(@ui.css(key).text).to eq(verify_hash[key])
				end
			end
		end
		if close_widget == true
			it "Close the widget modal and verify it's properly closed" do
				@ui.click("xc-modal-placeholder .xc-modal-close")
				@ui.css("xc-modal-placeholder").wait_while_present
				expect(@ui.css("xc-modal-placeholder")).not_to be_visible
			end
		end
	end
end

shared_examples "add a visualization widget" do |vname, type_of_data, group, date_from, date_to, open_add_widget, use_previous| # Created on: 05/03/2017
	it_behaves_like "go to analytics area"
	it_behaves_like "verify add edit widget modal", open_add_widget, false
	if use_previous == false
		describe "Add a visualization widget with the name '#{vname}', '#{type_of_data}', '#{group}', '#{date_from}' and '#{date_to}'" do
			it "Set the name, type of data, group assigned, date from and date to values" do
				@ui.click('xc-tabs-container xc-tab:first-child') and sleep 1
				@ui.set_input_val('xc-modal-container .widget-editor-container div:nth-child(1) .row input', vname) and sleep 1
				if type_of_data == "Number of Visitors"
					@ui.click('xc-modal-container .widget-editor-container .attr-selection li:first-child') and sleep 1
				elsif type_of_data == "Avg. Dwell Time"
					@ui.click('xc-modal-container .widget-editor-container .attr-selection li:nth-child(2)') and sleep 1
				end
				if @ui.css(".widget-editor-container .row.groups-container .ko_dropdownlist .ko_dropdownlist_button .text").text != group
					@ui.set_dropdown_entry_by_path(".widget-editor-container .row.groups-container span", group) and sleep 1
				end
				if date_from != ""
				  @ui.set_val_for_input_field('.start-time input', date_from) and sleep 1
					# @ui.set_val_for_input_field('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input', date_from) and sleep 1
					#@browser.execute_script("$('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input').val('')")
					#@ui.click('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time .datepicker_icon')
					#@ui.set_input_val('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input',date_from)
					#@ui.set_pika_date_time_picker('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time .datepicker_icon', date_from)
					#@ui.click('xc-tabs-container xc-tab:first-child')
					#@ui.click('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time .datepicker_icon')
					#@ui.set_input_val('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input',date_from)
					sleep 1
					#@browser.execute_script("$('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input').val('#{date_from}')")
					#@ui.set_val_for_input_field_new('.widget-editor-container .row.dates-container .inner-row:nth-of-type(2) .start-time input', date_from) and sleep 1
				end
				@ui.click('xc-modal-container .widget-editor-container div:nth-child(1) .row input') and sleep 1
				# @ui.click('xc-modal-container xc-modal-title') and sleep 1
				if date_to != ""
				  @ui.set_val_for_input_field('.end-time input', date_to) and sleep 1
					# @ui.set_val_for_input_field('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input', date_to) and sleep 1
					#@ui.set_val_for_input_field_new('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input', date_to) and sleep 1
					#@ui.click('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time .datepicker_icon')
					#@ui.set_input_val('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input',date_to)
					#@ui.click('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time .datepicker_icon')
					#@ui.click('xc-tabs-container xc-tab:first-child')
					#@ui.set_pika_date_time_picker('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time .datepicker_icon', date_to)
					#@ui.click('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time .datepicker_icon')
					#@ui.set_input_val('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input',date_to)
					#@browser.execute_script("$('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input').val('')")
					sleep 1
					#@browser.execute_script("$('.widget-editor-container .row.dates-container .inner-row:nth-of-type(3) .end-time input').val('#{date_to}')")
				end
				# @ui.click('xc-modal-container xc-modal-title') and sleep 1
				@ui.click('xc-modal-container .widget-editor-container div:nth-child(1) .row input') and sleep 1
			end
			it "Press the 'ADD' button" do
				@ui.css('xc-modal-buttons .button.orange').hover
				@ui.click('xc-modal-buttons .button.orange')
				@ui.css("xc-modal-placeholder").wait_while_present
				expect(@ui.css("xc-modal-placeholder")).not_to be_visible
				n=0
				loop do
				  sleep 10
				  n+=1
				  break if !@ui.css('.loadingMessage').visible? or n==30
				end
			end
		end
	elsif use_previous == true
		describe "Add a visualization widget with the name '#{vname}' from the 'PREVIOUS' tab of the modal" do
			it "Go to the previous tab and search for the entry '#{vname}" do
				@ui.click('.modal-widget-editor xc-tabs-container .dark:nth-of-type(2)')
				sleep 3
				@ui.set_input_val('.modal-widget-editor .widget-editor-container div:nth-child(2) .row:nth-of-type(1) search .xc-search input', vname)
				sleep 4
				expect(@ui.css('.widget-editor-container div:nth-child(2) .row:nth-of-type(2) ul').lis.length).to eq(1) and expect(@ui.css('.widget-editor-container div:nth-child(2) .row:nth-of-type(2) ul li .visualization-title .visualization-name').text).to eq(vname)
				@ui.click('.widget-editor-container div:nth-child(2) .row:nth-of-type(2) ul li .visualization-title') and sleep 2
				@ui.click('.widget-editor-container div:nth-child(2) .row:nth-of-type(2) ul li .visualization-title .visualization-name') and sleep 2
			end
			it "Press the 'ADD' button" do
				@ui.css('xc-modal-buttons .button.orange').hover
				@ui.click('xc-modal-buttons .button.orange')
				@ui.css("xc-modal-placeholder").wait_while_present
				expect(@ui.css("xc-modal-placeholder")).not_to be_visible
				  n=0
          loop do
            sleep 30
            n+=1
            break if !@ui.css('.loadingMessage').visible? or n==30
        end
			end
		end
	end
end

def find_proper_widget_in_the_landing_page(vname) # Created on: 05/03/2017
	widgets = @ui.get(:elements , {css: ".analytics-root .widgets-list xc-analytics-widget"}) and sleep 1
	widgets.each do |widget|
		if widget.element(:css => '.xc-widget-container .xc-widget-container-header .title').text == vname
			if !widget.element(:css => '.xc-widget-container .xc-widget-container-body .failedMessage').visible?
				widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li').wait_until(&:present?)
			end
			puts widget.element(:css => '.xc-widget-container .xc-widget-container-header .title').text
			return widget
		end
		expect(vname).not_to eq("NOT FOUND !!!")
	end
end

shared_examples "verify widget" do |vname, type_of_data, group, date_from, date_to, expected_data| # Created on: 05/03/2017
	describe "Verify the widget '#{vname}' properly exists and has the proper data" do
		it "Find the widget in the landing page and verify all major elements (#{vname}, #{type_of_data}, #{group}, #{date_from}, #{date_to})" do
			widget = find_proper_widget_in_the_landing_page(vname)
			expect(widget.element(:css => '.xc-widget-container .xc-widget-container-footer span').text).to eq(group)
			puts widget.element(:css => '.xc-widget-container .xc-widget-container-header .timespan').text
			if date_from.class == Hash
				puts "(" + date_from["Formated Date"] + " - " + date_to["Formated Date"] + ")"
				expect(widget.element(:css => '.xc-widget-container .xc-widget-container-header .timespan').text).to eq("(" + date_from["Formated Date"] + " - " + date_to["Formated Date"] + ")")
			else
				puts "(" + date_from + " - " + date_to + ")"
				expect(widget.element(:css => '.xc-widget-container .xc-widget-container-header .timespan').text).to eq("(" + date_from + " - " + date_to + ")")
			end
			#expect(widget.element(:css => '.xc-widget-container .xc-widget-container-header .timespan').text).to eq("(" + date_from + " - " + date_to + ")")
			#expect(widget.element(:css => '.xc-widget-container .xc-widget-container-header .timespan').text).to eq("(" + (Date.parse date_from).strftime("%-m/%-d/%Y") + " - " + (Date.parse date_to).strftime("%-m/%-d/%Y") + ")")
		end
		it "Verify the data of the widget" do
			widget = find_proper_widget_in_the_landing_page(vname)
			if expected_data == "No data available"
				expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body .failedMessage .title').text).to eq('There is no data available')
				expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body .failedMessage .subtitle').text).to eq('Try connecting clients to your wireless network to display statistics and charts.')
			else
				if type_of_data == "Number of Visitors"
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(1) .analytics-badge-name').text).to eq("Visitors")
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(1) .analytics-badge-value').text).to eq(expected_data["Visitors"])
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(2) .analytics-badge-name').text).to eq("Visits")
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(2) .analytics-badge-value').text).to eq(expected_data["Visits"])
				elsif type_of_data == "Avg. Dwell Time"
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(1) .analytics-badge-name').text).to eq("Median Visit")
					expect(widget.element(:css => '.xc-widget-container .xc-widget-container-body ul li:nth-child(1) .analytics-badge-value').text).to eq(expected_data["Median Visit"])
				end
			end
		end
	end
end

shared_examples "action on widget" do |vname, action, vname_new, type_of_data, group, date_from, date_to, open_add_widget|
	describe "#{action} the widget named '#{vname}'" do
		if action == "Delete"
			it "Find the widget and press the hamburger button, then press the delete button" do
				widget = find_proper_widget_in_the_landing_page(vname)
				widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon").click and sleep 2
				expect(widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon .drop_menu_nav")).to be_present
				widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon .drop_menu_nav .nav_item:nth-of-type(1)").click and sleep 2
			end
		elsif action == "Edit"
			it "Find the widget and press the hamburger button, then press the 'Change Visualization' button" do
				widget = find_proper_widget_in_the_landing_page(vname)
				widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon").click and sleep 2
				expect(widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon .drop_menu_nav")).to be_present
				widget.element(:css => ".xc-widget-container .xc-widget-container-header .hamburger-icon .drop_menu_nav .nav_item:nth-of-type(2)").click and sleep 2
			end
		end
	end
	if action != "Delete"
		it_behaves_like  "add a visualization widget", vname_new, type_of_data, group, date_from, date_to, open_add_widget
	end
end

shared_examples "verify 20 Widget added and no more new widget can add" do
  describe "verify 20 Widget added and no more new widget can add" do
      it "Verify that 20 widget added" do
        widgets = @ui.get(:elements , {css: ".analytics-root .widgets-list xc-analytics-widget"}) 
        sleep 1
        expect(widgets.size).to eq(20)
      end
      it "verify that no more widget can add" do
        expect(@ui.css('.new-item-icon')).not_to be_present
       end
    end
 end
 
 shared_examples "send email analytic report" do |email_address|
  describe "send email analytic report" do
      it "verify the email analytic report modal" do
        expect(@ui.css('.email-report-btn')).to be_present
        expect(@ui.css('.email-report-btn').text).to eq "Email Report"   
        @ui.css('.email-report-btn').click
        sleep 2
        expect(@ui.css('#analytics-email-modal xc-modal-header xc-modal-title').text).to eq "Email Report"
        expect(@ui.css('#analytics-email-modal xc-modal-header xc-modal-description').text).to eq "Enter email addresses you would like to send report to"
        expect(@ui.css('#analytics-email-modal xc-modal-body .row label').text).to eq "Email Address(es):"
        expect(@ui.css('#analytics-email-modal xc-modal-body xc-modal-buttons .button').text).to eq "Cancel"
        expect(@ui.css('#analytics-email-modal xc-modal-body xc-modal-buttons .button.orange').text).to eq "DONE"
        @ui.css('#analytics-email-modal xc-modal-body xc-modal-buttons .button').click            
      end
      it "set email address and send report to #{email_address}" do
        @ui.css('.email-report-btn').click
        sleep 2
        @ui.set_input_val('#email_field', email_address)
        sleep 0.5
        @ui.css('#analytics-email-modal xc-modal-body xc-modal-buttons .button.orange').click
        expect(@ui.css('#analytics-email-modal')).not_to be_present      
        sleep 1
       end
       it "wait for 120 sec just to make sure email geenrated and send" do
         sleep 120
       end
    end
 end
