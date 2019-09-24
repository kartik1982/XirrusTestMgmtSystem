def find_and_click_on_certain_dashboard_tile(dashboard_name)
	tiles = @ui.css('#dashboardHeader .ko-hover-scroll ul').lis.length
	while (tiles > 0) do
		if @ui.css("#dashboardHeader .ko-hover-scroll ul li:nth-child(#{tiles}) a .dashname").text == dashboard_name
			@ui.click("#dashboardHeader .ko-hover-scroll ul li:nth-child(#{tiles}) a .dashname")
			sleep 1
			expect(@ui.css('#dashboardContainer .dashheader .dashtitle .name').text).to eq(dashboard_name)
			break
		end
		if tiles == 1
			tile_not_found = true
			expect(tile_not_found).to eq(false)
		end
		sleep 0.5
		tiles -= 1
	end
end

def find_widget_with_certain_name(widget_name, summary, drilldown)
	if summary == false
		widgets_on_dashboard = @ui.get(:elements,{css: "#dashboardContainer ul .widget"})
		widgets_on_dashboard.each_with_index { |widget_on_dashboard, i|
			i+=1
			if drilldown == false
				first_part = @ui.css("#dashboardContainer ul li:nth-child(#{i}) .headerContainer .title span:nth-child(1)").text
				second_part = @ui.css("#dashboardContainer ul li:nth-child(#{i}) .headerContainer .title span:nth-child(2)").text
				widget_name_in_title = first_part + " " + second_part
				if  widget_name_in_title == widget_name
					expect(widget_name_in_title).to eq(widget_name)
					return "#dashboardContainer ul li:nth-child(#{i})"
				end
			else
				widget_name_drilldown = @ui.css("#dashboardContainer ul li:nth-child(#{i}) .headerContainer .title .widget-drilldown-root").text
				if widget_name_drilldown == "Applications"
					return "#dashboardContainer ul li:nth-child(#{i})"
				end
			end
		}
	else
		widget_name = widget_name.sub!(' (Summary)', '')
		case widget_name
			when "Clients on 2.4 Ghz"
				widget_name = widget_name.sub!('2.4 Ghz', '2.4GHz')
			when "Access Points up"
				widget_name = widget_name.sub!('u', 'U')
			when "Access Points down"
				widget_name = widget_name.sub!('d', 'D')
			when "Alerts - High", "Alerts - Medium", "Alerts - Low"
				widget_name = widget_name.sub!('Alerts - ', '')
		end
		summaries_on_dashboard = @ui.get(:elements ,{css: ".dashboardSummaryContainer .summaries .summary"})
		summaries_on_dashboard.each_with_index { |summary, i|
			i+=1
			if @ui.css(".dashboardSummaryContainer .summaries .summary:nth-child(#{i}) .name").text == widget_name
				expect( @ui.css(".dashboardSummaryContainer .summaries .summary:nth-child(#{i}) .name").text).to eq(widget_name)
				return ".dashboardSummaryContainer .summaries .summary:nth-child(#{i})"
			end
		}
	end
	return false
end

def find_all_available_applications(widget_string_path)
	application_names_array = []
	case @ui.css(widget_string_path + ' .content div').attribute_value("class")
		when "widget_kendo"
			applications = @ui.get(:elements, {css: widget_string_path + ' .content .widget_kendo .legend .item'})
			applications.each_with_index { |application, i|
				i+=1
				application_name_in_legend = @ui.get(:div , {css: widget_string_path + " .content .widget_kendo .legend div:nth-child(#{i})"}).text
				application_name_in_legend = application_name_in_legend[0, application_name_in_legend.index("\n")]
				if application_name_in_legend != "Other"
					application_names_array.push(application_name_in_legend)
				end
			}
		when "widget_table-container"
			table_length = @ui.css(widget_string_path + ' .content .widget_table-container .table tbody').trs.length
			while (table_length > 0) do
				application_name_in_cell = @ui.css(widget_string_path + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(2)")
				application_name_in_cell = application_name_in_cell.attribute_value("class").gsub("TABLEWIDGET_name ", "")
				if application_name_in_cell != "Other"
					application_names_array.push(application_name_in_cell)
				end
				table_length -= 1
			end
		when "bar_graph"
			applications = @ui.get(:elements, {css: widget_string_path + ' .content .bar_graph .bars .row'})
			applications.each { |application|
				application_name_in_bars = application.element(:css => " .value .label").text
				if application_name_in_bars != "Other"
					application_names_array.push(application_name_in_bars)
				end
			}
	end
	return application_names_array
end

def find_application_on_widget_and_click_on_it(application_name, widget_string_path)
	case @ui.css(widget_string_path + ' .content div').attribute_value("class")
		when "widget_kendo"
			applications = @ui.get(:elements, {css: widget_string_path + ' .content .widget_kendo .legend .item'})
			applications.each_with_index { |application, i|
				i+=1
				application_name_in_legend = @ui.get(:div , {css: widget_string_path + " .content .widget_kendo .legend div:nth-child(#{i})"}).text
				puts application_name_in_legend
				if application_name_in_legend.include?(application_name + "\n")
					application.hover
					sleep 0.5
					return widget_string_path + " .content .widget_kendo .legend div:nth-child(#{i})"
				end
			}
			sleep 0.5
		when "widget_table-container"
			table_length = @ui.css(widget_string_path + ' .content .widget_table-container .table tbody').trs.length
			while (table_length > 0) do
				application_name_in_cell = @ui.css(widget_string_path + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(2)")
				puts application_name_in_cell
				if application_name_in_cell.attribute_value("class").include?(application_name)
					application_name_in_cell.hover
					sleep 0.5
					return widget_string_path + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(2)"
				end
				table_length -= 1
			end
		when "bar_graph"
			applications = @ui.get(:elements, {css: widget_string_path + ' .content .bar_graph .bars .row'})
			i = 1
			applications.each { |application|
				application_name_in_bars = application.element(:css => " .value .label").text
				if application_name_in_bars == application_name
					application.hover
					sleep 0.5
					return widget_string_path + " .bar_graph .bars div:nth-child(#{i})"
				end
				i += 2
			}
			sleep 0.5
	end
end

shared_examples "dashboard clients block" do |widget_name|
	describe "Verify the 'Block' function on the dashboar tile named '#{widget_name}'" do
		it "Open the '.tooltip' for all available clients and verify that the 'Block/Unblock' actions container is visible" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			@ui.click(widget_string_path + ' .headerContainer .title')
			widget_entries = find_all_available_applications(widget_string_path)
			widget_entries.each do |widget_entry|
				found_application = find_application_on_widget_and_click_on_it(widget_entry, widget_string_path)
				sleep 1
				@ui.css(found_application + " .bar-image").hover
				sleep 1
				expect(@ui.css(found_application + " .tooltip")).to be_visible
				expect(@ui.css(found_application + " .tooltip .actions")).to be_visible
				sleep 1
			end
		end
	end
end

shared_examples "get certain client block and unblock" do |widget_name|
	describe "Verify the 'Block' function on the dashboar tile named '#{widget_name}'" do
		it "Open the client tooltip and 'Block' a certain client" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			@ui.click(widget_string_path + ' .headerContainer .title')
			widget_entries = find_all_available_applications(widget_string_path)
			$widget_entry = widget_entries.sample
			found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
			sleep 1
			@ui.css(found_client + " .bar-image").hover
			sleep 1
			expect(@ui.css(found_client + " .tooltip")).to be_visible
			expect(@ui.css(found_client + " .tooltip .actions")).to be_visible
			expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(1)")).to be_visible
			@ui.click(found_client + " .tooltip .actions button:nth-of-type(1)")
			sleep 1
		end
		it "Verify the 'Block client' confirmation modal" do
			@ui.css('.confirm').wait_until_present
			expect(@ui.css('.confirm .title span').text).to eq("Block client")
			expect(@ui.css('.confirm .msgbody div').text).to eq("Are you sure you want to block the selected client?")
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
		end
		it "Find the client and verify that the 'Blocked' icon is displayed" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			@ui.click(widget_string_path + ' .headerContainer .title')
			found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
			expect(@ui.css(found_client + " .client-blocked")).to be_visible
		end
		it "Reopen the client tooltip and 'Unblock' the client" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			@ui.click(widget_string_path + ' .headerContainer .title')
			found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
			sleep 1
			@ui.css(found_client + " .bar-image").hover
			sleep 1
			expect(@ui.css(found_client + " .tooltip")).to be_visible
			expect(@ui.css(found_client + " .tooltip .actions")).to be_visible
			expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(2)")).to be_visible
			@ui.click(found_client + " .tooltip .actions button:nth-of-type(2)")
			sleep 1
		end
		it "Verify the 'Unblock client' confirmation modal" do
			@ui.css('.confirm').wait_until_present
			expect(@ui.css('.confirm .title span').text).to eq("Unblock client")
			expect(@ui.css('.confirm .msgbody div').text).to eq("Are you sure you want to unblock the selected client?")
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
		end
		it "Find the client and verify that the 'Blocked' icon is NOT displayed" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			@ui.click(widget_string_path + ' .headerContainer .title')
			found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
			expect(@ui.css(found_client + " .client-blocked")).not_to be_present
		end
	end
end

shared_examples "create new tile" do |tile_name|
	describe "Create a new tile named '#{tile_name}'" do
		it "Go to My Network" do
			@ui.click('#header_nav_mynetwork')
			@ui.css('#mynetwork_view').wait_until_present
			expect(@browser.url).to include('/#mynetwork/overview')
		end
		it "Press the '+ NEW' tile button" do
			original_tile_length = @ui.css('#dashboardHeader .ko-hover-scroll ul').lis.length
			expect(@ui.css('.newDashboardTile')).to be_visible
			@ui.click('.newDashboardTile')
			sleep 1
			new_tile_length = @ui.css('#dashboardHeader .ko-hover-scroll ul').lis.length
			expect(original_tile_length).not_to eq(new_tile_length)
		end
		it "Select the tile named 'Dashboard 1'" do
			find_and_click_on_certain_dashboard_tile("Dashboard 1")
		end
		it "Enable the change name input box for the tile 'Dashboard 1' and change it to '#{tile_name}'" do
			@ui.css('#dashboardContainer .dashheader .dashtitle .name').hover
			sleep 0.5
			@ui.css('#dashboardContainer .dashheader .dashtitle .name').click
			sleep 0.5
			expect(@ui.css('#dashboardContainer .dashheader .dashtitle input')).to be_visible
			@ui.set_input_val('#dashboardContainer .dashheader .dashtitle input', tile_name)
			sleep 0.5
			@ui.click('#mynetwork_view .globalTitle')
			sleep 0.5
			expect(@ui.css('#dashboardContainer .dashheader .dashtitle input')).not_to be_visible
			expect(@ui.css('#dashboardContainer .dashheader .dashtitle .name').text).to eq(tile_name)
		end
	end
end

shared_examples "delete a certain tile" do |tile_name|
	describe "Delete the tile named '#{tile_name}'" do
		it "Go to My Network" do
			@ui.click('#header_nav_mynetwork')
			@ui.css('#mynetwork_view').wait_until_present
			expect(@browser.url).to include('/#mynetwork/overview')
		end
		it "Select the tile named '#{tile_name}'" do
			find_and_click_on_certain_dashboard_tile(tile_name)
		end
		it "Delete the selected tile named '#{tile_name}'" do
			if @ui.css('#dashboardContainer .dashheader .dashtitle .name').text == tile_name
				@ui.click('#mynetwork_dash_delete_duplicate_container')
				sleep 1
				@ui.click('#mynetwork_dash_delete_duplicate_container .drop_menu_nav.active a:nth-child(2)')
				sleep 2
				expect(@ui.css('.dialogOverlay.confirm')).to be_visible
				sleep 0.5
				@ui.click('#_jq_dlg_btn_1')
			end
		end
		it "Expect that the tiles list does not contain the tile named '#{tile_name}'" do
			tiles = @ui.css('#dashboardHeader .ko-hover-scroll ul').lis.length
			tile_found = false
			while (tiles > 0) do
				if @ui.css("#dashboardHeader .ko-hover-scroll ul li:nth-child(#{tiles}) a .dashname").text == tile_name
					expect(tile_found).to eq(true)
					break
				end
				if tiles == 1
					expect(tile_found).to eq(false)
				end
				sleep 0.5
				tiles -= 1
			end
		end
	end
end

shared_examples "add a widget" do |widget_name, summary|
	describe "Add the '#{widget_name}' to the dashboard" do
		it "Press the '+ADD WIDGET' button and expect the 'Select Widgets to Add' modal to be displayed" do
			@ui.click('#mynetwork_overview_add_widget')
			sleep 0.5
			expect(@ui.css('#widget_add_modal')).to be_visible
			expect(@ui.css('#widget_add_modal .title_wrap .commonTitle').text).to eq('Select Widgets to Add')
			expect(@ui.css('#widget_add_modal .title_wrap .commonSubtitle').text).to eq('Select the widgets you would like to show on your dashboard.')
			expect(@ui.css('#widget_add_modal .content .greybox .top .select_all')).to be_visible
			expect(@ui.css('#widget_add_modal .content .greybox .top .search')).to be_visible
			expect(@ui.css('#widget_add_modal .content .greybox .select_list #add_widget_list')).to be_visible
			expect(@ui.css('#widgets_add_modal_add_btn')).to be_visible
			expect(@ui.css('#widgets_add_modal_cancel_btn')).to be_visible
			expect(@ui.css('#widget_add_modal_closemodalbtn')).to be_visible
		end
		it "Search for the widget named '#{widget_name}' and place a tick for it then press the 'ADD' button" do
			widgets_length = @ui.css('#widget_add_modal .content .greybox .select_list ul').lis.length
			while ( widgets_length > 0 ) do
				first_part = @ui.css("#widget_add_modal .content .greybox .select_list ul li:nth-child(#{widgets_length}) span:nth-child(1)").text
				second_part = @ui.css("#widget_add_modal .content .greybox .select_list ul li:nth-child(#{widgets_length}) span:nth-child(2)").text
				widget_name_in_list = first_part + " " + second_part
				if (widget_name_in_list == widget_name)
					@ui.css("#widget_add_modal .content .greybox .select_list ul li:nth-child(#{widgets_length}) .mac_chk_label").click
					sleep 0.5
					break
				end
				if widgets_length == 1
					widget_not_found = true
					expect(widget_not_found).to eq(false)
				end
				sleep 0.5
				widgets_length -= 1
			end
			sleep 0.5
			@ui.click('#widgets_add_modal_add_btn')
			sleep 1
			if summary == false
				expect(@ui.css('#dashboardContainer .noWidgetsContainer')).not_to be_visible
				sleep 0.5
				expect(@ui.css('#dashboardContainer ul').lis.length).not_to eq(0)
			else
				expect(@ui.css('.dashboardSummaryContainer .summaries')).to exist
				sleep 0.5
				expect(@ui.css('.dashboardSummaryContainer .summaries').divs.length).not_to eq(0)
			end
		end
		it "Verify that the name of the widget is properly displayed" do
			widget_found = find_widget_with_certain_name(widget_name, summary, false)
			if summary == true
				expect(widget_found).to eq(false)
			else
				expect(widget_found).not_to eq(false)
			end
			if @ui.css('#dashboard_xr320_limitation_close_button').exists?
				if @ui.css('#dashboard_xr320_limitation_close_button').visible?
					sleep 1
					@ui.click('#dashboard_xr320_limitation_close_button')
				end
			end
		end
	end
end

shared_examples "delete a certain widget" do |widget_name, summary|
	describe "Delete the widget named '#{widget_name}'" do
		it "Find the widget named '#{widget_name}' and open the tools menu and select the option 'Delete'" do
			widget_string_path = find_widget_with_certain_name(widget_name, summary, false)
			sleep 0.5
			if summary == true
				@browser.execute_script('$(".deleteSummary").show()')
				sleep 4
				@ui.click(widget_string_path + " .deleteSummary")
			else
				@ui.click(widget_string_path + " .headerContainer .controls .tools_menu")
				sleep 1.5
				if widget_name == "Top Access Points (by Usage)" or widget_name == "Top Clients (by Usage)"
					@ui.click(widget_string_path + " .headerContainer .controls .tools_menu .drop_menu_nav .nav_item:nth-child(3)")
				else
					@ui.click(widget_string_path + " .headerContainer .controls .tools_menu .drop_menu_nav .nav_item:nth-child(2)")
				end
			end
			sleep 1.5
			@ui.click('#_jq_dlg_btn_1')
			sleep 1
		end
		it "Verify that the widget is removed" do
			widget_found = find_widget_with_certain_name(widget_name, summary, false)
			expect(widget_found).to eq(false)
		end
	end
end

shared_examples "edit widget change view type" do |widget_name, view_type|
	describe "Edit the widget named '#{widget_name}' and change the view type to '#{view_type}'" do
		it "Find the widget named '#{widget_name}' and change the view type to '#{view_type}'" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			@browser.execute_script('$("#suggestion_box").hide()')
			@ui.css(widget_string_path + ' .footer .chartbtns .charticon.' + view_type).hover
			sleep 0.5
			@ui.css(widget_string_path + ' .footer .chartbtns .charticon.' + view_type).click
		end
		it "Verify that the proper view type is displayed and the widget shows the proper controls" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			case view_type
				when "bar"
					expect(@ui.css(widget_string_path + ' .content div').attribute_value("class")).to eq('bar_graph')
				when "pie"
					expect(@ui.css(widget_string_path + ' .content div').attribute_value("class")).to eq('widget_kendo')
				when "table"
					expect(@ui.css(widget_string_path + ' .content div').attribute_value("class")).to eq('widget_table-container')
			end
		end
	end
end

shared_examples "edit widget change period" do |widget_name, period|
	describe "Edit the widget named '#{widget_name}' and change the period display to '#{period}'" do
		it "Find the widget named '#{widget_name}' and change the period display to the value '#{period}'" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			@browser.execute_script('$("#suggestion_box").hide()')
			@ui.css(widget_string_path + ' .footer .ko_dropdownlist').hover
			sleep 0.5
			@ui.set_dropdown_entry_by_path(widget_string_path + ' .footer .ko_dropdownlist', period)
		end
		it "Verify the period dropdown list displays the proper string ('#{period}')" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			expect(@ui.css(widget_string_path + ' .footer .ko_dropdownlist .ko_dropdownlist_button .text').text).to eq(period)
		end
	end
end

shared_examples "edit widget and activate the drill down" do |widget_name , application_name|
	describe "Edit the Widget named '#{widget_name}' and activate the drill down" do
		it "Find the widget named '#{widget_name}', then Search for '#{application_name}' (in any view) and click on it to open the drill down" do
			@ui.click('#header_nav_mynetwork')
			sleep 3
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			application_name_string_path = find_application_on_widget_and_click_on_it(application_name, widget_string_path)
			sleep 1
			expect(application_name_string_path).not_to eq(nil)
			@ui.click(application_name_string_path)
		end
		it "Expect that the widget displays the confirmation prompt for enabling the drilldown" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			expect(@ui.css(widget_string_path + ' .headerContainer .title a:first-child').text).to eq('Applications')
			expect(@ui.css(widget_string_path + ' .headerContainer .title span:nth-of-type(1)').text).to eq('/')
			expect(@ui.css(widget_string_path + ' .headerContainer .title span:nth-of-type(2)').text).to eq(application_name)
			expect(@ui.css(widget_string_path + ' .tabs .tab:first-child').text).to eq("Top Clients (by Usage)")
			expect(@ui.css(widget_string_path + ' .tabs .tab:last-child').text).to eq("Access Points (by Usage)")
			expect(@ui.css(widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:first-child').text).to eq("Enable Application Drilldown")
			expect(@ui.css(widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:nth-child(2)').text).to eq("The application drilldown feature needs to be enabled. Data collection will begin immediately. It will take some time to populate the graphs appropriately.")
			expect(@ui.css(widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:last-child label').text).to eq("Do you want to enable Application Drilldown Feature?")
			expect(@ui.css(widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:last-child .switch')).to be_visible
			expect(@ui.get(:checkbox , {css: widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:last-child .switch .switch_checkbox'}).set?).to eq(false)
		end
		it "Set the switch control to 'Yes'" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			@ui.css(widget_string_path + ' .content .widget-drilldownprompt .widget-drilldownprompt-container div:last-child .switch .switch_label').click
		end
		it "Expect that data will be showed" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs")).to exist
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs").divs.length).to eq(2)
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(1)").text).to eq("Top Clients (by Usage)")
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(2)").text).to eq("Access Points (by Usage)")
		end
		it "Navigate back to the Applications widget original view" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			@ui.click(widget_string_path + ' .headerContainer .title a:first-child')
		end
	end
end


shared_examples "edit widget top applications and use drill down for all applications" do |widget_name|
	describe "Edit the Widget named '#{widget_name}' and open the drill down on all applications" do
		before :all do
			@ui.click('#header_nav_mynetwork')
			sleep 3
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			@all_applications_array = find_all_available_applications(widget_string_path)
			sleep 0.5
		end
		it "Drilldown into each of the applications, expect that data displayed for 'top clients' and 'top access points' is either available or properly handeled on 'No content available', then navigate back to the Applications widget original view" do
			@all_applications_array.each do |application_name|
				log "Testing the application '#{application_name}'"
				widget_string_path = find_widget_with_certain_name(widget_name, false, false)
				sleep 1
				application_name_string_path = find_application_on_widget_and_click_on_it(application_name, widget_string_path)
				sleep 1
				expect(application_name_string_path).not_to eq(nil)
				if @ui.css(widget_string_path + ' .content div').attribute_value("class") == "bar_graph"
					application_name_string_path = application_name_string_path + " .count"
				end
				sleep 1
				@ui.click(application_name_string_path)
				sleep 1
				@@test_failed = false
				css_paths = [widget_string_path + ' .headerContainer .title span:last-child', widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(1)"]
				verify_values = [application_name, "tab selected"]
				css_paths.each_with_index do |css_path, i|
					if i == 0
						if @ui.css(css_path).text != verify_values[i]
							@@test_failed = true
							break
						end
					elsif i == 1
						if @ui.css(css_path).attribute_value("class") != verify_values[i]
							@@test_failed = true
							break
						end
					end
				end

				#expect(@ui.css(widget_string_path + ' .headerContainer .title span:last-child').text).to eq(application_name)
				#expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(1)").attribute_value("class")).to eq("tab selected")
				sleep 0.5
				if @@test_failed != true
					@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(2)").click
				end
				sleep 1
				#expect(@ui.css(widget_string_path + ' .headerContainer .title span:last-child').text).to eq(application_name)
				#expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(2)").attribute_value("class")).to eq("tab selected")
				sleep 0.5
				@ui.click(widget_string_path + ' .headerContainer .title a:first-child')
			end
		end
			it 'Is the test failed?' do
				expect(@@test_failed).to eq(false)
			end
		#end
		it "This part will be skiped once the bug '#32736' is fixed" do
			if @ui.css('.widget-drilldown-root').exists?
				widget_string_path = find_widget_with_certain_name(widget_name, false, true)
				@ui.click(widget_string_path + ' .headerContainer .title a:first-child')
			end
		end
	end
end


shared_examples "edit widget top applications and use drill down" do |widget_name, application_name, top_client, client_data_value_figure, client_data_value_percentage, top_accesspoint, accesspoint_data_value_figure, accesspoint_data_value_percentage|
	describe "Edit the Widget named '#{widget_name}' and open the drill down on the application '#{application_name}'" do
		it "Find the widget named '#{widget_name}' then Search for '#{application_name}' (in any view) and click on it to open the drill down" do
			@ui.click('#header_nav_mynetwork')
			sleep 3
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			application_name_string_path = find_application_on_widget_and_click_on_it(application_name, widget_string_path)
			sleep 1
			expect(application_name_string_path).not_to eq(nil)
			@ui.click(application_name_string_path)
		end
		it "Expect that data displayed for top client is '#{top_client}'" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, true)
			sleep 0.5
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(1)").attribute_value("class")).to eq("tab selected")
			sleep 1
			verify_application_on_widget(top_client, client_data_value_figure, client_data_value_percentage, true, widget_string_path)
		end
		it "Expect that data displayed for top access point is '#{top_accesspoint}'" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, true)
			sleep 0.5
			@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(2)").click
			sleep 1
			expect(@ui.css(widget_string_path + " .widget-content-wrapper.hastabs .tabs div:nth-child(2)").attribute_value("class")).to eq("tab selected")
			verify_application_on_widget(top_accesspoint, accesspoint_data_value_figure, accesspoint_data_value_percentage, true, widget_string_path)
		end
		it "Navigate back to the Applications widget original view" do
			widget_string_path = find_widget_with_certain_name(widget_name, false, true)
			sleep 0.5
			@ui.click(widget_string_path + ' .headerContainer .title a:first-child')
		end
	end
end

def verify_application_on_widget(application_name, data_value_figure, data_value_percentage, drilldown, widget_string_path)
	if drilldown == true
		widget_string_path_new = widget_string_path + ' .widget-content-wrapper.hastabs'
	else
		widget_string_path_new = widget_string_path
	end
	case @ui.css(widget_string_path_new + ' .content div').attribute_value("class")
		when "widget_kendo"
			applications = @ui.get(:elements, {css: widget_string_path_new + ' .content .widget_kendo .legend .item'})
			applications.each_with_index { |application, i|
				i+=1
				application_name_in_legend = @ui.css(widget_string_path_new + " .content .widget_kendo .legend div:nth-child(#{i}) .text").text
				if  application_name_in_legend.include?(application_name)
					expect(application_name_in_legend).to eq(application_name) # + "\n (" + data_value_percentage + ")")
					break
				end
			}
			sleep 0.5
		when "widget_table-container"
			table_length = @ui.css(widget_string_path_new + ' .content .widget_table-container .table tbody').trs.length
			while (table_length > 0) do
				application_name_in_cell = @ui.css(widget_string_path_new + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(2)")
				if application_name_in_cell.attribute_value("class").include?(application_name)
					expect(@ui.css(widget_string_path_new + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(2) div span").text).to eq(application_name)
					expect(@ui.css(widget_string_path_new + " .content .widget_table-container .table tbody tr:nth-child(#{table_length}) td:nth-child(4) div span").attribute_value("title")).to eq(data_value_figure)
					break
				end
				table_length -= 1
			end
		when "bar_graph"
			applications = @ui.get(:elements, {css: widget_string_path_new + ' .content .bar_graph .bars .row'})
			i = 1
			applications.each_with_index { |application|
				application_name_in_bars = @ui.css(widget_string_path_new + " .bar_graph .bars .row:nth-child(#{i}) .bar-container .bar-over .value .label").text
				if  application_name_in_bars.include?(application_name)
					expect(@ui.css(widget_string_path_new + " .bar_graph .bars .row:nth-of-type(#{i}) .bar-container .bar-over .value .label").text).to eq(application_name)
					expect(@ui.css(widget_string_path_new + " .bar_graph .bars .row:nth-of-type(#{i}) .bar-container .bar-over .value .text").text).to eq(data_value_figure)
					break
				end
				i += 1
			}
			sleep 0.5
	end
end
shared_examples "verify that Clients on Band widget has hyper link" do
  describe "verify that Clients on 2.4 GHz, 5 GHz and Total Clients widget has hyper link" do
    it "Go to My Network -> Overview-> Clients" do
      @ui.click('#header_nav_mynetwork')
      @ui.css('#mynetwork_view').wait_until_present
      expect(@browser.url).to include('/#mynetwork/overview')
      find_and_click_on_certain_dashboard_tile("Clients")
    end    
  end
end
shared_examples "verify that clicking Clients on Band widget redirect to Client panel" do |band|
  describe "Verify clicking Clients on '#{band}' widget redirect to mynetwork->Clients tab" do
     it "Go to My Network -> Overview-> Clients" do
      @ui.click('#header_nav_mynetwork')
      @ui.css('#mynetwork_view').wait_until_present
      expect(@browser.url).to include('/#mynetwork/overview')
      sleep 2
      find_and_click_on_certain_dashboard_tile("Clients")
      sleep 2
      expect(@ui.css('.dashboardSummaryContainer .summary.orange .name').attribute_value('href')).to include("#mynetwork/clients/?band=24GHZ")
      expect(@ui.css('.dashboardSummaryContainer .summary.green .name').attribute_value('href')).to include("#mynetwork/clients/?band=5GHZ")
      expect(@ui.css('.dashboardSummaryContainer .summary.blue .name').attribute_value('href')).to include("#mynetwork/clients/?band=BOTH")
    end    
    it "verify that click Clients on #{band} redirect to clients tab" do
      if band=="2.4 GHz"
      @ui.click('.dashboardSummaryContainer .summary.orange .name')
      sleep 2
      expect(@browser.url).to include('/#mynetwork/clients/?band=24GHZ')
      expect(@ui.css('#clients_state a .text').text).to eq('Online')
      expect(@ui.css('#clients_band a .text').text).to eq('2.4 GHz')
      
      elsif band=="5 GHz"
      @ui.click('.dashboardSummaryContainer .summary.green .name')
      sleep 2
      expect(@browser.url).to include('/#mynetwork/clients/?band=5GHZ')
      expect(@ui.css('#clients_state a .text').text).to eq('Online')
      expect(@ui.css('#clients_band a .text').text).to eq('5 GHz')
      else 
      @ui.click('.dashboardSummaryContainer .summary.blue .name')
      sleep 2
      expect(@browser.url).to include('/#mynetwork/clients/?band=BOTH')
      expect(@ui.css('#clients_state a .text').text).to eq('Online')
      expect(@ui.css('#clients_band a .text').text).to eq('2.4 GHz & 5 GHz')
      end
    end
  end
end
shared_examples "get certain client 'trobuleshooting' 'view Details' and 'application drill'" do |widget_name|
  describe "Verify the 'trobuleshooting' 'view Details' and 'application drill' function on the dashboard tile named '#{widget_name}'" do
    it "Verify Client tooltip has 'trobuleshooting' 'view Details' and 'application drill' a certain client" do
      widget_string_path = find_widget_with_certain_name(widget_name, false, false)
      @ui.click(widget_string_path + ' .headerContainer .title')
      widget_entries = find_all_available_applications(widget_string_path)
      if $the_environment_used=="test03"
        client_name="MyPC"
      else
        client_name="MYPC"
      end
      $widget_entry = widget_entries[widget_entries.index{|s| s.include?client_name}]
      found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
      sleep 1
      @ui.css(found_client + " .bar-image").hover
      sleep 1
      expect(@ui.css(found_client + " .tooltip")).to be_visible
      expect(@ui.css(found_client + " .tooltip .actions")).to be_visible
      expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(1)")).to be_visible
      expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(3)")).to be_visible
      expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(3)").text).to eq("Troubleshooting")
      expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(4)")).to be_visible
      expect(@ui.css(found_client + " .tooltip .actions button:nth-of-type(4)").text).to eq("View Details")
      expect(@ui.css(found_client + " .tooltip a")).to be_visible
      expect(@ui.css(found_client + " .tooltip a").text).to eq("more…")
      sleep 0.5
      @ui.click(found_client + " .tooltip .actions button:nth-of-type(3)")
    end
    it "Verify the 'Troubleshooting client' action from dashboard" do      
      sleep 5
      expect(@browser.url).to include("/#mynetwork/clients")
      expect(@browser.url).not_to include("/troubleshooting/")
      expect(@ui.css('.client-health-title')).to be_visible
    end
    it "Go to My Network- Dashboard" do
      @ui.click('#header_nav_mynetwork')
      @ui.css('#mynetwork_view').wait_until_present
      expect(@browser.url).to include('/#mynetwork/overview')
      sleep 1
    end
    it "Verify the 'View Details client' action from dashboard" do
      widget_string_path = find_widget_with_certain_name(widget_name, false, false)
      @ui.click(widget_string_path + ' .headerContainer .title')
      found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
      sleep 1
      @ui.css(found_client + " .bar-image").hover
      sleep 1
      expect(@ui.css(found_client + " .tooltip .actions")).to be_visible
      @ui.click(found_client + " .tooltip .actions button:nth-of-type(4)")
      sleep 3      
      expect(@browser.url).to include("/#mynetwork/clients/troubleshooting/")
      expect(@ui.css('.client-troubleshooting-title')).to be_visible
      expect(@ui.css('client-troubleshooting-details #client-troubleshooting-container span .subtitle')).to be_visible
      expect(@ui.css('client-troubleshooting-details #client-troubleshooting-container span .subtitle').text).to eq("Top Applications (by Usage)")
    end
     it "Go to My Network- Dashboard" do
      @ui.click('#header_nav_mynetwork')
      @ui.css('#mynetwork_view').wait_until_present
      expect(@browser.url).to include('/#mynetwork/overview')
      sleep 1
    end
    it "Verify the 'View Details client' action from dashboard" do
      widget_string_path = find_widget_with_certain_name(widget_name, false, false)
      @ui.click(widget_string_path + ' .headerContainer .title')
      found_client = find_application_on_widget_and_click_on_it($widget_entry, widget_string_path)
      sleep 1
      @ui.css(found_client + " .bar-image").hover
      sleep 1
      expect(@ui.css(found_client + " .tooltip .actions")).to be_visible
      @ui.click(found_client + " .tooltip a")
      sleep 2      
      expect(@ui.css('.TOP_CLIENTS_BY_USAGE .tabs .selected').text).to eq("Top Applications (by Usage)")
    end  
  end
end
shared_examples "Verify Application description for Top Application" do |widget_name|
  describe "Verify the 'Application Description' for dashboard tile named '#{widget_name}'" do
    it "Verify Application tooltip has 'Application Name' and Application Description'" do
      widget_string_path = find_widget_with_certain_name(widget_name, false, false)
      @ui.click(widget_string_path + ' .headerContainer .title')
      widget_entries = find_all_available_applications(widget_string_path)
      if (widget_name.include? "Top Application")
        widget_entries.each{|application|
          found_application = find_application_on_widget_and_click_on_it(application, widget_string_path)    
           sleep 1
        @ui.css(found_application + " .bar-image").hover
        sleep 1
        expect(@ui.css(found_application + " .tooltip")).to be_visible 
        expect(@ui.css(found_application + " .tooltip .tooltip_title").text).to eq(application) 
        expect(@ui.css(found_application + " .tooltip .description")).to be_visible #include(application)  
        } 
      end  
      if(widget_name=="Top Application Categories (by Usage)" || widget_name=="Top Clients (by Usage)")
       found_application = find_application_on_widget_and_click_on_it(widget_entries[0], widget_string_path)    
        sleep 1
        @ui.css(found_application + " .bar-image").hover
        sleep 1
        @ui.css(found_application + " .tooltip a").click
        sleep 1
        widget_entries = find_all_available_applications(widget_string_path)
        widget_entries.each{|application|
            found_application = find_application_on_widget_and_click_on_it(application, widget_string_path)    
             sleep 1
          @ui.css(found_application + " .bar-image").hover
          sleep 1
          expect(@ui.css(found_application + " .tooltip")).to be_visible 
          expect(@ui.css(found_application + " .tooltip .tooltip_title").text).to eq(application) 
          expect(@ui.css(found_application + " .tooltip .description")).to be_visible #include(application)  
          } 
      end
      end   
   end
end
shared_examples "set filter to All Devices" do |tab_name|
  describe "set filter to All Devices for #{tab_name}" do
    it "Go to #{tab_name}" do
    sleep 1
      case tab_name
        when "MyNetwork / Overview"
          @ui.click('#mynetwork_tab_arrays')
        when "MyNetwork / Access Points tab"
          @ui.click('#mynetwork_tab_arrays')
        when "MyNetwork / Clients tab"
          @ui.click('#mynetwork_tab_clients')
        when "MyNetwork / Alerts tab"
          @ui.click('#mynetwork_tab_alerts')
        when "MyNetwork / Rogues tab"
          @ui.click('#mynetwork_tab_rogues')
      end
      sleep 1
    end
    it "change drop-down to 'All Devices'" do
      if tab_name !="MyNetwork / Overview"
        @ui.set_dropdown_entry('mynetwork-aps-filter', "All Devices")
      else        
        @ui.set_dropdown_entry('mynetwork_overview_scopetoprofile', "All Devices")
      end
    end
  end
end

shared_examples "change locations and back to dashboard" do |profile_name, location, go_back_to_dashboard|
  describe "Change the location to '#{location}' and return to the 'MyNetork / Dashdoard' area" do
    it "Go to the @location: '#{location}' " do
      sleep 1
      case location
        when "Profiles"
          @ui.view_all_profiles
        when "Access Points"
          @ui.goto_all_guestportals_view
        when "Reports"
          @ui.view_all_reports
        when "MyNetwork / Access Points tab"
          @ui.click('#mynetwork_tab_arrays')
        when "MyNetwork / Clients tab"
          @ui.click('#mynetwork_tab_clients')
        when "MyNetwork / Alerts tab"
          @ui.click('#mynetwork_tab_alerts')
        when "MyNetwork / Floor Plans tab"
          @ui.click('#mynetwork_tab_locations')
        when "Settings / Support Management"
          @ui.click('#header_nav_user') and sleep 1
          @ui.click('#header_backoffice_link')
        when "Settings / Command Center"
          @ui.click('#header_nav_user') and sleep 1
          @ui.click('#header_msp_link')
        when "Settings / Troubleshooting"
          @ui.click('#header_nav_user') and sleep 1
          @ui.click('#header_troubleshooting')
        when "Settings / Settings"
          @ui.click('#header_nav_user') and sleep 1
          @ui.click('#header_settings_link')
        when "Settings / Contact us"
          @ui.click('#header_nav_user') and sleep 1
          @ui.click('#header_contact')
      end
      sleep 1
    end
    if go_back_to_dashboard == true
      it "Go back to the 'MyNetwork / Dashboard' area" do
        sleep 1
        @ui.click('#header_mynetwork_link')
        sleep 2
      end
      it "Verify that the user is located on the 'My Network' / 'Dashboard' page" do
        sleep 2
        @browser.execute_script('$("#suggestion_box").hide()')
        sleep 1
        expect(@browser.url).to include("/#mynetwork/overview/")
      end
      if profile_name != "All Devices"
        it_behaves_like "verify overview tab has filtered icon"
      else
        it_behaves_like "verify overview tab does not have filtered icon"
      end
      it_behaves_like "verify overview tab is filtered by profile", profile_name
    end
  end
end