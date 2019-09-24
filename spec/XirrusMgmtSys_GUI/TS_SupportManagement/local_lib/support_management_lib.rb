require_relative "../../TS_Settings/local_lib/settings_lib.rb"

def hover_over_specific_line_from_grid_without_paging(column_no, a_or_div, name)
	grid_entries = @ui.css('.nssg-table .nssg-tbody')
	grid_entries.wait_until_present
	grid_length = grid_entries.trs.length
    while (grid_length != 0) do
            if (@ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(#{column_no}) #{a_or_div}").text == name)
                sleep 1
                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(#{column_no})").hover
                sleep 1
                $grid_length_global = grid_length
                break
            end
           grid_length-=1
	end
end

def go_to_tab_support_management(tab)
	case tab
		when "Firmware"
			tab_string = "#backoffice_tab_firmware"
		when "Access Points"
			tab_string = "#backoffice_tab_arrays"
		when "Access Points - My Network"
			tab_string = "#mynetwork_tab_arrays"
		when "Switches"
      tab_string = "#backoffice_tab_switches"
		when "AOS Boxes"
			tab_string = "#backoffice_tab_aosboxes"
		when "Circles"
			tab_string = "#backoffice_tab_circles"
		when "Customers"
			tab_string = "#backoffice_tab_customers"
		when "Access Points - Browsing tenant"
			tab_string = "#customerDash_tab_arrays"
		when "User Accounts - Browsing tenant"
			tab_string = "#customerDash_tab_users"
		else
			puts "Tab not recognized!!!"
	end
	@browser.execute_script('$("#suggestion_box").hide()')
	sleep 2
	@ui.click(tab_string)
	sleep 1
end

# def search_for_a_certain_string(string,expected_results)
	# @ui.set_input_val(".xc-search input", string)
	# sleep 2
	# if @ui.css('.btn-search').visible?
		# @ui.click(".btn-search")
		# sleep 2
	# end
	# grid_entries = @ui.css('.nssg-table .nssg-tobdy')
	# grid_entries.wait_until_present
	# grid_length = grid_entries.trs.length
	# expect(grid_length).to eq(expected_results)
# end

def go_to_support_management_new
	@ui.css('#header_nav_user').wait_until_present
	@ui.click('#header_nav_user')
	sleep 1
	@ui.click('#header_backoffice_link')
	sleep 1
	expect(@browser.url).to include("/#backoffice")
	sleep 1
end

shared_examples "go to support management" do
	describe "Navigates to the Support Management area" do
		it "Open the user dropdown list and select the option 'Support Management'" do
			@ui.click('#header_nav_user')
			sleep 1
			@ui.click('#header_backoffice_link')
			sleep 1
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Ensure that the application is on the Backoffice area" do
			expect(@browser.url).to include("/#backoffice/firmware")
			sleep 1
		end
	end
end

shared_examples "go to tab support management" do |tab|
  describe "Navigates to #{tab} in Support Management area" do
    it "Navigate to support management #{tab} tab" do
         go_to_tab_support_management(tab)
    end
  end
end

shared_examples "create a new firmware" do |version, release_date, url, enterprise_active, enterprise_beta, cloud_active, cloud_beta|
	describe "Create a new firmware with the following values: #{version} / #{release_date} / #{url} / #{enterprise_active} / #{enterprise_beta} / #{cloud_active} / #{cloud_beta}" do
		it "Press the '+ New Firmware' button" do
			sleep 1
			@ui.click('#bo-fw-new-btn')
			sleep 1
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).to be_visible
			sleep 1
		end
		it "Set the '#{version}' string for the Version input field" do
			@ui.set_input_val('#edit_version', version)
			sleep 1
		end
    it "Set the '#{url}' string for the Url input field" do
      @ui.css("#clidetails_tab_cli").click
      @ui.set_input_val('#edit_url', url)
      sleep 1
    end
		#removing feature from 9.5.0
		# it "Set the '#{release_date}' string for the Release Date input field" do
			# @ui.click('#edit_releaseDate')
				# (0..12).each do
					# @browser.send_keys :backspace
				# end
			# @ui.set_input_val('#edit_releaseDate', release_date)
			# sleep 1
		# end

		# it "Set the '#{enterprise_active}' value for the Url input field" do
			# if (enterprise_active == false)
				# @ui.click('#edit_ea .switch_label .right')
			# end
		# end
		# it "Set the '#{enterprise_beta}' value for the Url input field" do
			# if (enterprise_beta == true)
				# @ui.click('#edit_eb .switch_label .left')
			# end
		# end
		# it "Set the '#{cloud_active}' value for the Url input field" do
			# if (cloud_active == false)
				# @ui.click('#edit_ca .switch_label .right')
			# end
		# end
		# it "Set the '#{cloud_beta}' value for the Url input field" do
			# if (cloud_beta == true)
				# @ui.click('#edit_cb .switch_label .left')
			# end
		# end
		it "Press the 'Save' button" do
			@ui.click('.ko_slideout_content .bottom_buttons .buttons .orange')
		end
	end
end

shared_examples "edit a certain firmware" do |version, version_new, url_new|
	describe "Edit the firmware with the version #{version}" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Open the 'View/Edit Firmware details' slide out for the firmware version #{version}" do
			@ui.grid_action_on_specific_line("3","div",version,"invoke")
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).to be_visible
		end
		it "Change the 'Version' fields' value to #{version_new}" do
			sleep 1
			@ui.set_input_val('#edit_version', version_new)
		end
		it "Change the 'URL' field's value to #{url_new}" do
			sleep 1
			@ui.set_input_val('#edit_url', url_new)
		end
		it "Save the changes and close the slideout" do
			@ui.click('.bottom_buttons .buttons .orange')
			sleep 1
			@ui.click('#clidetails_close_btn')
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).not_to be_visible
		end
		it "Set the view type to '1000'" do
			if @ui.css('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .text').text != "1000"
				@ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
				sleep 1
				@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "1000")
				sleep 2
			end
		end
		it "Verify that the line now has the version set to #{version_new} and the URL set to #{url_new}" do
      found_css = quicksearch_for_entry_in_grid(3, version_new)
			expect(found_css).not_to eq(nil)
			expect(@ui.css(found_css + " td:nth-child(3) div").text).to eq(version_new)
			sleep 1
			expect(@ui.css(found_css + " td:nth-child(4) div").text).to eq(url_new)
		end
	end
end

shared_examples "view details slideout window controls" do
	describe "Test the controls on the view details slideout window" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Get the Version numbers of the first three lines in the grid" do
			$first_line_version = @ui.css('.nssg-table tbody tr:first-child td:nth-child(3) div').text
			$second_line_version = @ui.css('.nssg-table tbody tr:nth-child(2) td:nth-child(3) div').text
			$third_line_version = @ui.css('.nssg-table tbody tr:nth-child(3) td:nth-child(3) div').text
		end
		it "Open the slideout window for the first line in the grid " do
			sleep 0.5
			@ui.css('.nssg-table tbody tr:first-child td:nth-child(3)').hover
			sleep 0.5
			@ui.css('.nssg-table tbody tr:first-child .nssg-actions-container .nssg-action-invoke').click
		end
		it "Verify that the slideout window is properly displayed and has all features expected" do
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to exist
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content #clidetails_close_btn')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .slideout_title span')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .slideout_title span').text).to eq($first_line_version)
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .top .buttons .blue')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_version')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_url')).to be_visible
			# expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_releaseDate')).to be_visible
			# expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_ea')).to be_visible
			# expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_eb')).to be_visible
			# expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_ca')).to be_visible
			# expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .tab_contents .info_block #edit_cb')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .bottom_buttons .buttons #clidetails_prev_array')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .bottom_buttons .buttons .orange')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .bottom_buttons .buttons #clidetails_next_CLI')).to be_visible
		end
		it "Press the 'Next Firmware' button and verify that the slideout window displays the firmare #{$second_line_version}" do
			@ui.click('#clidetails_next_CLI')
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to exist
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .slideout_title span').text).to eq($second_line_version)
		end
		it "Press the 'Next Firmware' button and verify that the slideout window displays the firmare #{$third_line_version}" do
			if @ui.css('#_jq_dlg_btn_0').exists? and @ui.css('#_jq_dlg_btn_0').visible?
				@ui.click('#_jq_dlg_btn_0')
			end
			@ui.click('#clidetails_next_CLI')
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to exist
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .slideout_title span').text).to eq($third_line_version)
		end
		it "Press the 'Previous Firmware' button twice and verify that the slideout window displays the firmware #{$first_line_version}" do
			@ui.click('#clidetails_prev_array')
			sleep 0.5
			@ui.click('#clidetails_prev_array')
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to exist
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).to be_visible
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content .slideout_title span').text).to eq($first_line_version)
		end
		it "Minimize the firmware slideou window, verify it exists but is not visible, maximize it and verify that it is opened properly" do
			@ui.click('#clidetails_collapse_btn')
			sleep 0.5
			expect(@ui.css('#clidetails_collapse_btn.collapsed')).to exist
			sleep 0.5
			@ui.click('#clidetails_collapse_btn')
			sleep 0.5
			expect(@ui.css('#clidetails_collapse_btn.collapsed')).not_to exist
		end
		it "Close the firmware using the 'x' close button" do
			@ui.click('#clidetails_close_btn')
			sleep 1
			expect(@ui.css('.tabpanel_slideout.opened .ko_slideout_content')).not_to exist
		end
	end
end

def quicksearch_for_entry_in_grid(what_column_number, entry_name)
	firmware_entries_tr_td_text = @ui.get(:elements , {css: ".nssg-table tbody tr td:nth-child(#{what_column_number})"})
	i = 1
	puts "TIME START = #{Time.now}"
	firmware_entries_tr_td_text.each do |firmaware_entry_name|
		if firmaware_entry_name.text == entry_name
			puts "TIME FOUND = #{Time.now}"
			return ".nssg-table tbody tr:nth-child(#{i})"
		end
		i+=1
	end
	puts "TIME ENDED = #{Time.now}"
	return nil
end

shared_examples "delete a certain firmware with grid delete button" do |version|
	describe "Delete a certain firmware from the grid" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Set the view type to '1000'" do
			if @ui.css('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .text').text != "1000"
				@ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
				sleep 1
				@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "1000")
				sleep 2
			end
		end
		it "Locate the #{version} version into the grid and place a tick for the correspoding line" do
			found_css = quicksearch_for_entry_in_grid(3, version)
			@ui.css(found_css + " td:nth-child(2) .mac_chk_label").hover
			sleep 1
			@ui.click(found_css + " td:nth-child(2) .mac_chk_label")
		end
=begin
		it "Verify the grid length " do
			firmware_entries = @ui.css('.nssg-table tbody')
			firmware_entries.wait_until_present
			$firmware_entries_length = firmware_entries.trs.length
		end

		it "Locate the #{version} version into the grid and place a tick for the correspoding line" do
			row_number = 1 #

			while (row_number != $firmware_entries_length) do
	            if (@ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(3)").text == version)
	                sleep 1
	                @ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(2) .mac_chk_label").hover
	                sleep 1
	                @ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(2) .mac_chk_label").click
	                sleep 1
	            end
            row_number+=1
        	end
        end
=end
        it "Press the 'Delete' button and accept the deletion" do
        	sleep 3
        	@ui.click('#bo-fw-delete-btn')
        	sleep 1
        	@ui.click('#_jq_dlg_btn_1')
        	sleep 1
        	@browser.refresh
        	sleep 5
        end

        it "Verify that the #{version} firmware is not included in the grid" do
        	found_css = quicksearch_for_entry_in_grid(3, version)
        	expect(found_css).to eq(nil)
        end
	end
end

shared_examples "cant delete a certain firmware" do
	describe "Verify Cloud Admin user can't delete a certain firmware from the grid" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Verify the grid does not have a checkbox and that the entries do not have an action container" do
			row_number = 1
			while (row_number != 10) do
	            expect(@ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(1) .nssg-actions-container")).not_to exist
	            expect(@ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(2) .mac_chk_label")).not_to exist
            	row_number+=1
        	end
		end
	end
end

shared_examples "cant delete a certain firmware with grid delete button" do |version|
	describe "Verify Cloud Admin user can't delete a certain firmware from the grid" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Verify the grid length and locate the #{version} version into the grid and place a tick for the correspoding line" do
			firmware_entries = @ui.css('.nssg-table tbody')
			firmware_entries.wait_until_present
			firmware_entries_length = firmware_entries.trs.length
			row_number = 1 #
			while (row_number != firmware_entries_length) do
	            if (@ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(3)").text == version)
	                sleep 1
	                @ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(2) .mac_chk_label").hover
	                sleep 1
	                @ui.css(".nssg-table tbody tr:nth-child(#{row_number}) td:nth-child(2) .mac_chk_label").click
	                sleep 1
	            end
            row_number+=1
        	end
        end
        it "Verify that the 'Delete' button is  visible but pressing it shows a 403 Forbidden error message" do
        	expect(@ui.css('#bo-fw-delete-btn')).to be_present
        	sleep 1
        	@ui.click('#bo-fw-delete-btn')
        	sleep 1
        	@ui.click('#_jq_dlg_btn_1')
        	sleep 0.3
        	@ui.css(".error").wait_until_present
        	expect(@ui.css('.error')).to be_present
        	expect(@ui.css('.error .title span').text).to eq("403 Forbidden")
        end
        it "REFRESH TO REMOVE" do
        	@browser.refresh
        end
	end
end

shared_examples "delete a certain firmware with line context button delete" do |version|
	describe "Delete a certain firmware from the grid using the line's context button delete" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Focus on the line with version #{version}, open the context menu and press the delete button" do
			sleep 1
			found_css = quicksearch_for_entry_in_grid(3, version)
			@ui.css(found_css + " td:nth-child(2) .mac_chk_label").hover
			sleep 1
			@ui.click(found_css + " td:nth-child(1) .nssg-action-delete")
			sleep 1
			@ui.click('#_jq_dlg_btn_1')
        	sleep 1
        	@browser.refresh
        	sleep 5
		end
		it "Verify that the #{version} firmware is not included in the grid" do
        	found_css = quicksearch_for_entry_in_grid(3, version)
			    expect(found_css).to eq(nil)
        end
	end
end

shared_examples "delete a certain firmware with delete button from slideout" do |version|
	describe "Delete a certain firmware from the grid using the delete button on the slideout window" do
		it "Ensure you are on the Firmware tab" do
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click('#backoffice_tab_firmware')
			sleep 1
		end
		it "Focus on the line with version #{version}, open the slideout and press the delete button" do
			sleep 1
			#@ui.grid_action_on_specific_line("3","div",version,"invoke")
			found_css = quicksearch_for_entry_in_grid(3, version)
			@ui.css(found_css + " td:nth-child(2) .mac_chk_label").hover
			sleep 1
			@ui.click(found_css + " td:nth-child(1) .nssg-action-invoke")
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).to be_visible
			sleep 1
			@ui.click('.tabpanel_slideout .ko_slideout_content .top .buttons .blue')
			sleep 1
			@ui.click('#_jq_dlg_btn_1')
        	sleep 1
        	@browser.refresh
        	sleep 5
		end
		it "Verify that the #{version} firmware is not included in the grid" do
        	found_css = quicksearch_for_entry_in_grid(3, version)
			    expect(found_css).to eq(nil)
        	#@ui.get_grid_length
			#while ($grid_length != 0) do
	        #    expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(3)").text).not_to eq(version)
	        #    $grid_length-=1
	        #end
        end
	end
end

shared_examples "verify descending ascending sorting firmware - to be deleted once issue is fixed" do |tab, column|
	describe "Verify the descending / ascending sort feature on the tab #{tab} and column #{column}" do
		it "Ensure you are on the #{tab} tab" do
			case tab
				when "Firmware"
					tab_string = "#backoffice_tab_firmware"
				when "Access Points"
					tab_string = "#backoffice_tab_arrays"
				when "Access Points - My Network"
					tab_string = "#mynetwork_tab_arrays"
				when "AOS Boxes"
					tab_string = "#backoffice_tab_aosboxes"
				when "Circles"
					tab_string = "#backoffice_tab_circles"
				when "Customers"
					tab_string = "#backoffice_tab_customers"
				when "Access Points - Browsing tenant"
					tab_string = "#customerDash_tab_arrays"
				when "User Accounts - Browsing tenant"
					tab_string = "#customerDash_tab_users"
				else
					puts "Tab not recognized!!!"
			end
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click(tab_string)
			sleep 1
		end
		it "Arrange the column '#{column}' in ascending order and take the first 3 and last 3 values in the column" do
			@ui.find_grid_header_by_name(column)

			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"

			if (@ui.css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages').exists?)
				@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
				sleep 4
			end

			@ui.get_grid_length
			if $grid_length > 200
				$bool_several_entries = true
			end
			sleep 2
			sleep 2
			$grid_length_second_last = $grid_length - 1
			$grid_length_third_last = $grid_length - 2
			$desc_min_first_val = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text
			$desc_max_first_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text
			$desc_min_second_val = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text
			$desc_max_second_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text
			$desc_min_third_val = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text
			$desc_max_third_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text
		end
		it "Change the sort feature on the '#{column}' column to descending" do
				@ui.css("#{$column_string} .nssg-th-text").click
				if ($bool_several_entries == true)
					sleep 6
				end
		end

			it "Verify that the descending sort first value is the last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
			end
			it "Verify that the descending sort second value is the second last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
			end
			it "Verify that the descending sort third value is the third last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
			end

		it "Change the sort feature on the '#{column}' column to ascending" do

				@ui.css("#{$column_string} .nssg-th-text").click
				if ($bool_several_entries == true)
					sleep 6
				end

		end


			it "Verify that the ascending sort first value is the first value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
			end
			it "Verify that the ascending sort second value is the second last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
			end
			it "Verify that the ascending sort third value is the third last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
			end

	end
end

shared_examples "verify descending ascending sorting firmware" do |tab, column|
	describe "Verify the descending / ascending sort feature on the tab #{tab} and column #{column}" do
		it "Ensure you are on the #{tab} tab" do
			case tab
				when "Firmware"
					tab_string = "#backoffice_tab_firmware"
				when "Access Points"
					tab_string = "#backoffice_tab_arrays"
				when "Access Points - My Network"
					tab_string = "#mynetwork_tab_arrays"
				when "AOS Boxes"
					tab_string = "#backoffice_tab_aosboxes"
				when "Circles"
					tab_string = "#backoffice_tab_circles"
				when "Customers"
					tab_string = "#backoffice_tab_customers"
				when "Access Points - Browsing tenant"
					tab_string = "#customerDash_tab_arrays"
				when "User Accounts - Browsing tenant"
					tab_string = "#customerDash_tab_users"
				else
					puts "Tab not recognized!!!"
			end
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click(tab_string)
#			sleep 1
#			@ui.css("#{$column_string} .nssg-th-text").click
		end

		it "Arrange the column '#{column}' in ascending order and take the first 3 and last 3 values in the column" do
			@ui.find_grid_header_by_name(column)

			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"

			if (@ui.css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages').exists?)
				@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "1000")
				sleep 4
			end

			@ui.get_grid_length
			if $grid_length > 200
				$bool_several_entries = true
			end
			sleep 2
			if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
				sleep 1
				@ui.css("#{$column_string} .nssg-th-text").click
				if ($bool_several_entries == true)
					sleep 6
				end
				expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				elsif (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
					(1..2).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 1
						if ($bool_several_entries == true)
							sleep 6
						end
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				else
					(1..3).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 1
						if ($bool_several_entries == true)
							sleep 6
						end
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
			end
			sleep 2
			$grid_length_second_last = $grid_length - 1
			$grid_length_third_last = $grid_length - 2
			$desc_min_first_val = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text
			$desc_max_first_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text
			$desc_min_second_val = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text
			$desc_max_second_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text
			$desc_min_third_val = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text
			$desc_max_third_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text
		end

		it "Change the sort feature on the '#{column}' column to descending" do
			if (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
				@ui.css("#{$column_string} .nssg-th-text").click
				if ($bool_several_entries == true)
					sleep 6
				end
				expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to exist
				expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to be_visible
			end
		end

		it "Verify that the descending sort first value is the last value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
		end
		it "Verify that the descending sort second value is the second last value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
		end
		it "Verify that the descending sort third value is the third last value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
		end

		it "Change the sort feature on the '#{column}' column to ascending" do
			if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
				@ui.css("#{$column_string} .nssg-th-text").click
				if ($bool_several_entries == true)
					sleep 6
				end
				expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to be_visible
			end
		end

		it "Verify that the ascending sort first value is the first value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
		end
		it "Verify that the ascending sort second value is the second last value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
		end
		it "Verify that the ascending sort third value is the third last value taken from the ascending sort" do
			expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
			expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
		end
	end
end

shared_examples "verify descending ascending sorting access points" do |column|
	describe "Verify the descending / ascending sort feature on the 'Access Points' tab and column #{column}" do
		it "Ensure you are on the 'Access Points' tab" do
			@ui.click("#backoffice_tab_arrays") and sleep 1
			@ui.span(:text => "Access Points").wait_until_present
			expect(@browser.url).to include('/#backoffice/arrays')
		end
		it "Set the view type to '100'" do
			@ui.click('.nssg-paging-pages .arrow')
			sleep 1
			@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "100")
			sleep 2
		end
		it "Verify that the sort order is set to ascending on the #{column} column" do
			@ui.find_grid_header_by_name_support_management(column)
			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"
			if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
				sleep 2
				@ui.css("#{$column_string} .nssg-th-text").click
				expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				elsif (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
					(1..2).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 2
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				else
					(1..3).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 2
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
			end
			sleep 2
		end
		if ["Online","Licensed AOS","Gig1 MAC","License"].include?(column) == false
			it "Take the first three values from the ascending sort" do
				sleep 1
				$desc_min_first_val = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text
				$desc_min_second_val = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text
				$desc_min_third_val = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text
			end
			it "Change the grid to the last page" do
				last_page = @ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-last')
				last_page.wait_until_present
				last_page.click
				sleep 1
				expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-last')).not_to be_visible
				expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')).to be_visible
			end
			it "Take the last three values from the ascending sort" do
				@ui.get_grid_length
				sleep 1
				$grid_length_second_last = $grid_length - 1
				$grid_length_third_last = $grid_length - 2
				$desc_max_first_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text
				$desc_max_second_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text
				$desc_max_third_val = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text
			end
			it "Change the grid to the first page" do
				first_page = @ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')
				first_page.wait_until_present
				first_page.click
				sleep 10
				expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-last')).to be_visible
				expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')).not_to be_visible
			end
		end
		it "Change the sort feature on the '#{column}' column to descending" do
			if (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
				@ui.css("#{$column_string} .nssg-th-text").click
				sleep 2
				expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to exist
				expect(@ui.css("#{$column_string}.nssg-sorted-desc")).to be_visible
			end
		end
		if ["Online","Licensed AOS","Gig1 MAC","License"].include?(column) == false
			it "Verify that the descending sort first value is the last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq($desc_max_first_val)
			end
			it "Verify that the descending sort second value is the second last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq($desc_max_second_val)
			end
			it "Verify that the descending sort third value is the third last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq($desc_max_third_val)
			end
		end
		it "Change the grid to the last page" do
			@ui.click('newgrid-paging .nssg-paging-controls .nssg-paging-last')
			sleep 1
			expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-last')).not_to be_visible
			expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')).to be_visible
		end
		if ["Online","Licensed AOS","Gig1 MAC","License"].include?(column) == false
			it "Verify that the descending sort first value is the last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{$header_count})").text).to eq($desc_min_first_val)
			end
			it "Verify that the descending sort second value is the second last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_second_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_second_val)
			end
			it "Verify that the descending sort third value is the third last value taken from the ascending sort" do
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_third_last}) td:nth-child(#{$header_count})").text).to eq($desc_min_third_val)
			end
		end
		it "Change the grid to the first page" do
			first_page = @ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')
			first_page.wait_until_present
			first_page.click
			sleep 10
			#expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-last')).to be_visible
			expect(@ui.css('newgrid-paging .nssg-paging-controls .nssg-paging-first')).not_to be_visible
		end
	end
end

shared_examples "verify column does not support sorting" do |tab, column|
	describe "Verify the descending / ascending sort feature on the tab #{tab} and column #{column}" do
		it "Ensure you are on the #{tab} tab" do
			case tab
				when "Firmware"
					tab_string = "#backoffice_tab_firmware"
				when "Access Points"
					tab_string = "#backoffice_tab_arrays"
				when "Access Points - My Network"
					tab_string = "#mynetwork_tab_arrays"
				when "AOS Boxes"
					tab_string = "#backoffice_tab_aosboxes"
				when "Circles"
					tab_string = "#backoffice_tab_circles"
				when "Customers"
					tab_string = "#backoffice_tab_customers"
				when "Access Points - Browsing tenant"
					tab_string = "#customerDash_tab_arrays"
				when "User Accounts - Browsing tenant"
					tab_string = "#customerDash_tab_users"
				else
					puts "Tab not recognized!!!"
			end
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 2
			@ui.click(tab_string)
			sleep 1
		end
		it "Click the '#{column}' column header and ensure that the ascending / descending visual aid does not appear, also ensure that the first 3 values remain the same" do
			@ui.find_grid_header_by_name(column)

			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"

			first_value = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text
			second_value = @ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text
			third_value = @ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text

			@ui.click($column_string)
			sleep 1
			expect(@ui.css("#{$column_string}.nssg-sorted-asc")).not_to exist
			expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq(first_value)
			expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq(second_value)
			expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq(third_value)
			@ui.click($column_string)
			sleep 1
			expect(@ui.css("#{$column_string}.nssg-sorted-desc")).not_to exist
			expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{$header_count})").text).to eq(first_value)
			expect(@ui.css(".nssg-table tbody tr:nth-child(2) td:nth-child(#{$header_count})").text).to eq(second_value)
			expect(@ui.css(".nssg-table tbody tr:nth-child(3) td:nth-child(#{$header_count})").text).to eq(third_value)
		end
	end
end

shared_examples "cant add user accounts on customers dashboard view" do |user_email, first_name, last_name, additional_details, priviledges_xms, priviledges_cloud|
	describe "Verify that an user account line cant be added from the Browsing Tenant view" do
		it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
		it "Try to add the user with the following values: first_name = '#{first_name}' /// last_name = '#{last_name}' /// email = '#{user_email}' /// XMS = '#{priviledges_xms}' /// cloud = '#{priviledges_cloud}'" do
	        @browser.execute_script('$("#suggestion_box").hide()')
			sleep 1
	        @ui.click('#useraccounts_newuser_btn')
	        sleep 1
	        @ui.set_input_val('#usermodal_firstname',first_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_lastname',last_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_email',user_email)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_details',additional_details)
	        sleep 0.5
	        @ui.set_dropdown_entry('ddl_role',priviledges_xms)
	        sleep 0.5
	        @ui.set_dropdown_entry('ddl_backoffice',priviledges_cloud)
	    end
	    it "Save the user" do
	        @ui.click('#users_modal_save_btn')
	        sleep 3
	        expect(@ui.css('.tabpanel_slideout.left.opened')).not_to exist
	    end
	    it "Verify that the user is not created and the application shows a proper error message" do
	        sleep 0.5
	        @ui.css(".error").wait_until_present
        	expect(@ui.css('.error .title span').text).to eq("403 Forbidden")
        end
        it "Verify that the user does not appear in the grid" do
			if priviledges_cloud == "None"
        		priviledges = priviledges_xms
        	else
        		priviledges = priviledges_xms + ", " + priviledges_cloud
        	end
	        expect(user_accounts_grid_actions("verify strings", user_email, first_name, last_name, additional_details, priviledges)).to eq(false)
	    end
	    it "Verify that a user cannot be delete and the application shows a proper error message" do
	    	user_accounts_grid_actions("check",user_email,"","","","")
	    	@ui.click('#useraccounts_delete_btn')
	        sleep 1
	        @ui.confirm_dialog
	        sleep 1
	        @ui.css(".error").wait_until_present
        	expect(@ui.css('.error .title span').text).to eq("403 Forbidden")
	    end
	end
end

shared_examples "cant delete an ap with grid delete button" do |start_of_id|
	describe "Verify Cloud Admin user can't delete an AP from the grid" do
		it "Ensure you are on the Access Points tab" do
			@ui.click("##{start_of_id}_tab_arrays")
			sleep 1
		end
		it "Focus on the grid and place a tick for the first line" do
			@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(2) .mac_chk_label").hover
	        sleep 1
	        @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(2) .mac_chk_label").click
	        sleep 2
        end
        it "Verify that the 'Delete' button is  visible but pressing it shows a 403 Forbidden error message" do
        	expect(@ui.css('#backoffice_arrays_delete_btn')).to be_present
        	sleep 1
        	@ui.click('#backoffice_arrays_delete_btn')
        	sleep 1
        	@ui.click('#_jq_dlg_btn_1')
        	sleep 0.3
        	@ui.css(".error").wait_until_present
        	expect(@ui.css('.error .title span').text).to eq("403 Forbidden")
        end
        it "Hover over the first ten lines and verify that the application does shows the context buttons but the user can't delete an AP and a 403 Forbidden error message is displayed" do
			(1..10).each do |i|
				if start_of_id == "backoffice"
					@ui.css(".nssg-table tbody tr:nth-child(#{i}) .globalSerialNumber").hover
				else
					@ui.css(".nssg-table tbody tr:nth-child(#{i}) .serialNumber").hover
				end
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{i}) .nssg-td-actions")).to exist
				if i == 10
					@ui.click(".nssg-table tbody tr:nth-child(#{i}) .nssg-td-actions .nssg-action-delete")
					sleep 1
		        	@ui.click('#_jq_dlg_btn_1')
		        	sleep 0.3
		        	@ui.css(".error").wait_until_present
		        	expect(@ui.css('.error')).to be_present
		        	expect(@ui.css('.error .title span').text).to eq("403 Forbidden")
				end
			end
		end
	end
end

shared_examples "search for an ap and perform an action" do |ap_sn, action|
	describe "Search the Access Points grid for the entry that has the Serial Number #{ap_sn} then perform the #{action}" do
		it "Ensure you are on the Access Points tab" do
			@ui.click("#backoffice_tab_arrays")
			sleep 1
		end
		it "Search for the '#{ap_sn}' serial number" do
			@ui.set_input_val('.xc-search input', ap_sn)
			sleep 2
			if @ui.css('.btn-search').visible?
      	@ui.click('.btn-search')
      end
			sleep 5
		end
		it "Verify the grid length should be 1 and the entry displayed should have the Serial Number value of #{ap_sn}" do
			sleep 2
			grid_entries = @ui.css('.nssg-table .nssg-tobdy')
			grid_entries.wait_until_present
			expect(grid_entries.trs.length).to eq(1)
			expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(4)").text).to eq(ap_sn)
			sleep 5
		end
		it "Reset search and get grid length" do
			@ui.click('.btn-clear')
			sleep 5
			grid_entries = @ui.css('.nssg-table .nssg-tobdy')
			grid_entries.wait_until_present
			$grid_length = grid_entries.trs.length
		end
		it "Search for the '#{ap_sn}' serial number" do
			@ui.set_input_val('.xc-search input', ap_sn)
			sleep 2
			if @ui.css('.btn-search').visible?
				@ui.click('.btn-search')
			end
			sleep 5
		end
		it "Search trough pages until the #{ap_sn} line is located" do
			if (action == "Command Line Interface")
				@ui.grid_action_on_specific_line("4", "div", ap_sn, "cli")
			elsif (action == "Delete")
				@ui.grid_tick_on_specific_line("4", ap_sn, "div")
			end
		end
		it "Perform the action: #{action}" do
			if (action == "Command Line Interface")
				if (@ui.css('.tab_contents .array-details-cli-agreement').exists?)
					sleep 1
					@ui.click('.array-details-cli-agreement-btn')
				end
			elsif (action == "Delete")
				sleep 1
				@ui.click('#backoffice_arrays_delete_btn')
			end
		end
		it "If the action is: 'Command Line Interface' - send a command and verify it is properly displayed /// If the action is 'Delete' - verify that the AP is deleted" do
			if (action == "Command Line Interface")
				if @ui.css('.slideout_title .online_status').text == 'Offline'
          			expect(@ui.css('#profile_arrays_details_slideout .tab_contents .nodata span').text).to eq('Access Point Commands are unavailable because this Access Point is offline.')
          		else
					cli = @ui.get(:textarea, {id: 'array-details-cli-commands-input'})
	        		cli.wait_until_present
	        		cli.send_keys 'show running-config'
	        		#cli.send_keys :enter
	        		#cli.send_keys 'iaps'
					sleep 1
					@ui.click('#array-details-cli-submit')
					sleep 5
					resp = @ui.get(:textarea, { css: '.array-details-cli-results-response' })
	          		resp.wait_until_present
	       			expect(resp.value).to include(ap_sn)
	       		end
			elsif (action == "Delete")
				sleep 1
				@ui.css('#_jq_dlg_btn_1').hover
				sleep 1
				@ui.click('#_jq_dlg_btn_1')
				sleep 5
				@ui.click('.nssg-refresh')
				sleep 2
			end
			if (@ui.css('#profile_arrays_details_slideout').visible?)
				@ui.click('#arraydetails_close_btn')
			end
		end
		if action == "Delete"
			it "Search for the '#{ap_sn}' serial number and verify the grid length should be 0 and no entry displayed" do
				@browser.refresh
				@ui.css('.xc-search').wait_until_present
				@ui.set_input_val('.xc-search input', ap_sn)
				sleep 2
				if @ui.css('.btn-search').visible?
        	@ui.click('.btn-search')
        end
				sleep 5
				expect(@ui.css('.nssg-table .nssg-tobdy')).not_to be_visible
				expect(@ui.css('#backoffice_arrays xc-grid')).to be_visible
				sleep 2
				@ui.click('.btn-clear')
				sleep 5
			end
		end
	end
end

shared_examples "search for an ap and assign it to customer" do |ap_sn, customer|
	describe "Search the Access Points grid for the entry that has the Serial Number #{ap_sn} then assign it to the #{customer} customer" do
		it "Ensure you are on the Access Points tab" do
			@ui.click("#backoffice_tab_arrays")
			sleep 1
		end
		it "Search for the Access Point with the serial number as '#{ap_sn}'" do
			@ui.set_input_val(".xc-search input", ap_sn)
			sleep 2
			if @ui.css('.btn-search').visible?
				@ui.click(".btn-search")
				sleep 2
			end
		end
		it "Get the grid's length, search trough page until the #{ap_sn} line is located and place a tick for the selected line" do
			grid_entries = @ui.css('.nssg-table .nssg-tobdy')
			grid_entries.wait_until_present
			$grid_length = grid_entries.trs.length
			@ui.grid_tick_on_specific_line("4", ap_sn, "div")
		end
		it "Press the 'Assign to Customer' button and ensure the proper modal is loaded" do
			@ui.click('#backoffice_arrays_assign_tenant_btn')
			sleep 1
			expect(@ui.css('#backoffice_arrays_assign_tenant')).to exist
		end
		it "Get list length" do
			list_length = @ui.css('#backoffice_arrays_assign_tenant .select_list')
			list_length.wait_until_present
			$list_length = list_length.lis.length
			expect($list_length).to eq(50)
		end
		it "Search trough customers until the #{customer} line is located" do
        	list_length_local = $list_length
	        while (list_length_local != -1) do
		            if (@ui.css("#backoffice_arrays_assign_tenant .select_list ul li:nth-child(#{list_length_local})").text == customer)
		                sleep 1
		                @ui.css("#backoffice_arrays_assign_tenant .select_list ul li:nth-child(#{list_length_local})").hover
		                @ui.css("#backoffice_arrays_assign_tenant .select_list ul li:nth-child(#{list_length_local})").click
		                sleep 1
		                @ui.css("#backoffice_arrays_assign_tenant .content .buttons .orange").click
		                sleep 1
		                break
		            end
	            list_length_local-=1
	            if (list_length_local == 0)
		           	@ui.click('.grid_pageLinks .next')
		           	sleep 2
		           	list_length = @ui.css('#backoffice_arrays_assign_tenant .select_list')
					list_length.wait_until_present
					$list_length = list_length.lis.length
					list_length_local = $list_length
		           	redo
	            end
			end
			if @ui.css('#backoffice_arrays_assign_tenant_closemodalbtn').exists?
				if @ui.css('#backoffice_arrays_assign_tenant_closemodalbtn').visible?
					@ui.click('#backoffice_arrays_assign_tenant_closemodalbtn')
				end
			end
			sleep 3
			if @ui.css('.loading').exists?
				if @ui.css('.loading').visible?
					@ui.css('.loading').wait_while_present
				end
			end
		end
		it "Reopen the Assign AP to Customer modal and verify that the customer is #{customer}" do
			grid_entries = @ui.css('.nssg-table .nssg-tobdy')
			grid_entries.wait_until_present
			$grid_length = grid_entries.trs.length
			@ui.grid_tick_on_specific_line("4", ap_sn, "div")
			sleep 2
			@ui.click('#backoffice_arrays_assign_tenant_btn')
			sleep 1
			expect(@ui.css('#backoffice_arrays_assign_tenant')).to exist
			sleep 1
			expect(@ui.css('#backoffice_arrays_assign_tenant .content div:first-child .field_label strong').text).to eq(customer)
		end
		it "Close the Assign AP to Customer modal and refresh the browser" do
			@ui.click('#backoffice_arrays_assign_tenant_closemodalbtn')
			sleep 1
			@browser.refresh
			sleep 4
		end
	end
end

shared_examples "search for an ap and clear its penalty" do |ap_sn|
	describe "Search the Access Points grid for the entry that has the Serial Number #{ap_sn} then clear it's penalty" do
		it "Ensure you are on the Access Points tab" do
			@ui.click("#backoffice_tab_arrays")
			sleep 1
		end
		it "Search for the Access Point with the serial number as '#{ap_sn}'" do
			@ui.set_input_val(".xc-search input", ap_sn)
			sleep 2
			if @ui.css('.btn-search').visible?
				@ui.click(".btn-search")
				sleep 2
			end
		end
		it "Get the grid's length, search trough page until the #{ap_sn} line is located and place a tick for the selected line" do
			grid_entries = @ui.css('.nssg-table .nssg-tobdy')
			grid_entries.wait_until_present
			$grid_length = grid_entries.trs.length
			@ui.grid_tick_on_specific_line("4", ap_sn, "div")
		end
		it "Press the 'Clear Penalty' button and ensure that the message overlay is displayed and that the text is: 'Penalty has been cleared'" do
			@ui.click('#backoffice_arrays_clear_penalty_array_btn')
			sleep 1
			expect(@ui.css('.msgbody')).to exist
			expect(@ui.css('.msgbody')).to be_visible
			expect(@ui.css('.msgbody').text).to eq("Penalty has been cleared")
		end
	end
end

shared_examples "verify grid columns on access points tab" do
	describe "Verify that the columns on the grid are all present" do
		it "Ensure you are on the Access Points tab" do
			@ui.click("#backoffice_tab_arrays")
			sleep 1
		end
		it "Go trough the column names and ensure that all columns are present" do
			for column in ["Tenant ID","Serial Number","Online","Status","Expiration Date","Licensed AOS","Reported AOS Version","Model","Gig1 MAC","IAP MAC","License","First Activation","Last Configured Time"] do
				@ui.find_grid_header_by_name_support_management(column)
				expect($header_column.text).to eq(column)
			end
		end
		it "Set the view type to '10' entries per page" do
			@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
		end
	end
end

shared_examples "cant add edit an AOS Box" do
	describe "Verify that a Cloud Admin user can't add or edit an AOS Box" do
		it "Ensure you are on the AOS Boxes tab" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
		end
		it "Expect the 'New Box' button not to be visible" do
			expect(@ui.css('#bo-fw-new-btn')).not_to be_present
		end
		it "Hover over the first ten lines and verify that the application does not show the context buttons" do
			(1..10).each do |i|
				@ui.css(".nssg-table tbody tr:nth-child(#{i}) .name").hover
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{i}) .nssg-action-delete")).not_to exist
			end
		end
	end
end

shared_examples "add new AOS box" do |name, description, mainline_technology, aos_firmware, xr320_firmware, x2120_firmware, xs6012_firmware, xs6024_firmware, xs6048_firmware|
  describe "Add a new AOS box for AOS-AOSLite-Switch" do
    it "Ensure you are on the AOS Boxes tab" do
      @ui.click('#backoffice_tab_aosboxes')
      sleep 1
      expect(@browser.url).to include('#backoffice/aosboxes')
    end
    it "Press the 'New Box' button" do
      @ui.click('#bo-fw-new-btn')
      sleep 1
      expect(@ui.css('#aosboxes_add_modal')).to exist
    end
    it "Set the #{name} value in the Box Name input field" do
      @ui.set_input_val('#aosbox_name',name)
      sleep 1
    end
    it "Set the #{description} value in the Description input field" do
      @ui.set_textarea_val('#aosbox_description',description)
      sleep 1
    end
    it "Change to the '#{mainline_technology}' tab" do
      if mainline_technology == "mainline"
        @ui.click("xc-tabs .formtabs xc-tab:first-child")
      elsif mainline_technology == "technology"
        @ui.click("xc-tabs .formtabs xc-tab:nth-child(2)")
      end
    end
    it "Set the AOS #{aos_firmware} value in the Firmware dropdown list" do
      @ui.set_dropdown_entry_by_path(".#{mainline_technology} #aosbox_firmware", aos_firmware)
    end
    it "Set the XR320 #{xr320_firmware} value in the Firmware dropdown list" do
      @ui.set_dropdown_entry_by_path(".#{mainline_technology} #xr320box_defaultfirmware", xr320_firmware)
    end
    it "Set the X2-120 #{x2120_firmware} value in the Firmware dropdown list" do
      @ui.set_dropdown_entry_by_path(".#{mainline_technology} #x2120box_defaultfirmware", x2120_firmware)
    end
    it "Set the XS-6012 #{xs6012_firmware} value in the Firmware dropdown list" do
      @ui.set_dropdown_entry_by_path(".#{mainline_technology} #xs6012pbox_defaultfirmware", xs6012_firmware)
    end
    it "Set the XS-6024 #{xs6024_firmware} value in the Firmware dropdown list" do
      @ui.set_dropdown_entry_by_path(".#{mainline_technology} #xs6024mpbox_defaultfirmware", xs6024_firmware)
    end
    # it "Set the XS-6048 #{xs6048_firmware} value in the Firmware dropdown list" do
      # @ui.set_dropdown_entry_by_path(".#{mainline_technology} #xs6048mpbox_defaultfirmware", xs6048_firmware)
    # end
    it "Press the 'Create Box' button" do
      @ui.click('#aosboxes_add_modal_save_btn')
    end
    it "Search for the line with the AOS box named #{name}" do
      @ui.grid_action_on_specific_line("2", "div", name, "invoke")
          sleep 2
    end
    it "Verify the #{name} value in the Box Name input field" do
      expect(@ui.get(:input , {css: '#aosbox_name'}).value).to eq(name)
    end
    it "Set the #{description} value in the Description input field" do
      expect(@ui.get(:textarea , {css: '#aosbox_description'}).value).to eq(description)
    end
    it "Change to the '#{mainline_technology}' tab" do
      if mainline_technology == "mainline"
        @ui.click("xc-tabs .formtabs xc-tab:first-child")
      elsif mainline_technology == "technology"
        @ui.click("xc-tabs .formtabs xc-tab:nth-child(2)")
      end
    end
    it "Verify the AOS #{aos_firmware} value in the Firmware dropdown list" do 
      path= ".#{mainline_technology} #aosbox_firmware .ko_dropdownlist_button .text"
      expect(@ui.css(path).text).to eq(aos_firmware)
    end
    it "Verify the XR320 #{xr320_firmware} value in the Firmware dropdown list" do
      path= ".#{mainline_technology} #xr320box_defaultfirmware .ko_dropdownlist_button .text"
      expect(@ui.css(path).text).to eq(xr320_firmware)
    end
    it "Verify the X2-120 #{x2120_firmware} value in the Firmware dropdown list" do
      path= ".#{mainline_technology} #x2120box_defaultfirmware .ko_dropdownlist_button .text"
      expect(@ui.css(path).text).to eq(x2120_firmware)
    end
    it "Verify the XS-6012 #{xs6012_firmware} value in the Firmware dropdown list" do
      path= ".#{mainline_technology} #xs6012pbox_defaultfirmware .ko_dropdownlist_button .text"
      expect(@ui.css(path).text).to eq(xs6012_firmware)
    end
    it "Verify the XS-6024 #{xs6024_firmware} value in the Firmware dropdown list" do
      path= ".#{mainline_technology} #xs6024mpbox_defaultfirmware .ko_dropdownlist_button .text"
      expect(@ui.css(path).text).to eq(xs6024_firmware)
    end
    # it "Verify the XS-6048 #{xs6048_firmware} value in the Firmware dropdown list" do
      # path= ".#{mainline_technology} #xs6048mpbox_defaultfirmware .ko_dropdownlist_button .text"
      # expect(@ui.css(path).text).to eq(xs6048_firmware)
    # end
    it "Close AOS Box overlay" do
      @ui.css('#aosboxes_add_modal_cancel_btn').click
      sleep 1
    end
  end
end


shared_examples "add an AOS box" do |name, description, mainline_technology, firmware, restriction_count, ap_type, min_fw, max_fw|
	describe "Add a new AOS box" do
		it "Ensure you are on the AOS Boxes tab" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
		end
		it "Press the 'New Box' button" do
			@ui.click('#bo-fw-new-btn')
			sleep 1
			expect(@ui.css('#aosboxes_add_modal')).to exist
		end
		it "Set the #{name} value in the Box Name input field" do
			@ui.set_input_val('#aosbox_name',name)
			sleep 1
		end
		it "Set the #{description} value in the Description input field" do
			@ui.set_textarea_val('#aosbox_description',description)
			sleep 1
		end
		it "Change to the '#{mainline_technology}' tab" do
			if mainline_technology == "mainline"
				@ui.click("xc-tabs .formtabs xc-tab:first-child")
			elsif mainline_technology == "technology"
				@ui.click("xc-tabs .formtabs xc-tab:nth-child(2)")
			end
		end
		it "Set the #{firmware} value in the Firmware dropdown list" do
			@ui.set_dropdown_entry_by_path(".#{mainline_technology} #aosbox_firmware", firmware)
		end
		if restriction_count != 0
			1.upto(restriction_count) do |i|
				it "Add a new restriction" do
					@ui.click("#aosboxes_add_modal .content .#{mainline_technology} .ap_wrap .add") #div:nth-child(2)')
					sleep 1
				end
				it "Set the AP type: #{ap_type} // Min fw: #{min_fw} // Max fw: #{max_fw}" do
					@ui.set_dropdown_entry_by_path(".ap_firmware_entry:nth-child(#{i}) #aosbox_ap_type", ap_type)
				end
				it "Search trough mininum firmware list for the #{min_fw} entry" do
					@ui.click(".ap_firmware_entry:nth-child(#{i}) span:nth-child(7) .ko_dropdownlist_button .arrow")
					sleep 1
					list = @ui.css(".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper")
					list.wait_until_present
					list_length = list.lis.length
		    	    while (list_length != 0) do
				            if (@ui.css(".ko_dropdownlist_list.active ul li:nth-child(#{list_length})").text == min_fw)
				                @ui.css(".ko_dropdownlist_list.active ul li:nth-child(#{list_length})").click
				                sleep 1
				                break
				            end
		    	        list_length-=1
					end
				end
				it "Search trough mininum firmware list for the #{max_fw} entry" do
					#@ui.click(".ap_firmware_entry.last span:nth-child(10) .ko_dropdownlist_button .arrow")
					@ui.click(".ap_firmware_entry:nth-child(#{i}) span:nth-child(10) .ko_dropdownlist_button .arrow")
					sleep 1
					list = @ui.css(".ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper")
					list.wait_until_present
					list_length = list.lis.length
		    	    while (list_length != 0) do
				            if (@ui.css(".ko_dropdownlist_list.active ul li:nth-child(#{list_length})").text == max_fw)
				                @ui.css(".ko_dropdownlist_list.active ul li:nth-child(#{list_length})").click
				                sleep 1
				                break
				            end
		    	        list_length-=1
					end
				end
			end
		end
		it "Press the 'Create Box' button" do
			@ui.click('#aosboxes_add_modal_save_btn')
		end
		it "Search trough pages until the #{name} line is located and verify it exists" do
        	@ui.grid_click_on_specific_line("2", name, "div")
		end
	end
end

shared_examples "change circle from AOS box" do |circle_name, box_name|
	describe "Change the #{circle_name} circle to the AOS box named #{box_name}" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Search for the line with the circle named #{circle_name} and press the 'Invoke' button" do
			@ui.grid_action_on_specific_line("2", "div", circle_name, "invoke")
		end
		it "Set the value #{box_name} on the Box dropdown list and press 'SAVE'" do
			@ui.set_dropdown_entry('edit_boxid', box_name)
			sleep 1
			@ui.click('.ko_slideout_content .bottom_buttons .buttons .orange')
		end
	end
end

shared_examples "change circle firmware scheduling" do |circle_name, start_time, end_time, timezone|
	describe "Change the #{circle_name} circle to the values '#{start_time}, #{end_time} and #{timezone}'" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Search for the line with the circle named #{circle_name} and press the 'Invoke' button" do
			@ui.grid_action_on_specific_line("2", "div", circle_name, "invoke")
		end
		it "Set the values '#{start_time}, #{end_time} and #{timezone}' on the circle and press 'SAVE'" do
			@ui.set_input_val('.xc-time-range-starttime', start_time)
		    sleep 1
		    @ui.set_input_val('.xc-time-range-endtime', end_time)
		    sleep 1
		    @ui.set_dropdown_entry('firmwareupgrades-timezone', timezone)
			sleep 1
			@ui.click('.ko_slideout_content .bottom_buttons .buttons .orange')
		end
	end
end

shared_examples "delete an AOS box" do |name|
	describe "Delete the AOS box named #{name}" do
		it "Ensure you are on the AOS Boxes tab" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
		end

		it "Search for the line with the AOS box named #{name}" do
			@ui.grid_action_on_specific_line("2", "div", name, "delete")
      		sleep 1
		end
		it "Confirm the deletion of the 'AOS Box'" do
			sleep 1
			@ui.click('#_jq_dlg_btn_1')
			sleep 2
		end
		it "Verify that the entry does not appear in the grid anymore" do
			grid_entries = @ui.css('.nssg-table .nssg-tbody')
			grid_entries.wait_until_present
			grid_length_local = grid_entries.trs.length

	        while (grid_length_local != 0) do
		            if (@ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(2) div").text == name)
						puts "The entry #{name} still appears in the grid !!!"
		            end
	            grid_length_local-=1
			end
		end
	end
end

shared_examples "duplicate an AOS box" do |name|
	describe "Duplicate the AOS box named #{name}" do
		it "Ensure you are on the AOS Boxes tab" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
		end
		it "Search for the line with the AOS box named #{name} and press the 'Duplicate' button" do
			@ui.grid_action_on_specific_line("2", "div", name, "duplicate")
		end
		it "Expect that the 'New Box' modal is displayed" do
			expect(@ui.css('#aosboxes_add_modal')).to exist
		end
		it "Press the 'Create Box' button" do
			@ui.click('#aosboxes_add_modal_save_btn')
		end
		it "Get the grid's length" do
			grid_entries = @ui.css('.nssg-table .nssg-tbody')
			grid_entries.wait_until_present
			$grid_length = grid_entries.trs.length
		end
		it "Search trough pages until the '#{name} (1)' line is located" do
			@ui.grid_click_on_specific_line("2", name + ' (1)', "div")
		end
	end
end

shared_examples "add circle to AOS box" do |box_name, circle_name|
	describe "Assign the circle '#{circle_name}' to the AOS box named '#{box_name}' " do
		it "Ensure you are on the AOS Boxes tab" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
		end
		it "Open the 'Assign Circle to AOS box hyperlink' for the line #{box_name}" do
			grid_entries = @ui.css('.nssg-table .nssg-tbody')
			grid_entries.wait_until_present
			grid_length_local = grid_entries.trs.length
	        while (grid_length_local != 0) do
		            if (@ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(2) div").text == box_name)
		                sleep 1
		                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(2)").hover
		                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(2)").click
		                sleep 1
		                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(3) a").click
		                break
		            end
	            grid_length_local-=1
			end
		end
		it "Ensure that the 'Set Circles' modal overlay is displayed" do
			expect(@ui.css('#aosboxes_addcircles_modal')).to be_present
		end
		it "Select the circle entry named #{circle_name}" do
			list = @ui.css('#add_circles .lhs .select_list .ko_container.ui-sortable')
			list.wait_until_present
			list_length = list.lis.length
			puts list_length

	        while (list_length != 0) do
		            if (@ui.css(".lhs ul li:nth-child(#{list_length})").text == circle_name)
		                sleep 1
		                @ui.css(".lhs ul li:nth-child(#{list_length})").click
		                sleep 1
		                break
		            end
	            list_length-=1
			end
		end
		it "Press the 'Move' button" do
			@ui.click('#circles_add_modal_move_btn')
		end
		it "Press the 'Save Circles' button" do
			@ui.click('#aosbox_add_modal_addcircles_btn')
		end
	end
end

shared_examples "cant add edit an circle" do
	describe "Verify that a Cloud Admin user can't add or edit an Circle" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Expect the 'New Circle' button not to be visible" do
			expect(@ui.css('#backoffice_circles_addnew_btn')).not_to be_present
		end
		it "Hover over the first ten lines and verify that the application does not show the context buttons" do
			(1..10).each do |i|
				@ui.css(".nssg-table tbody tr:nth-child(#{i}) .name").hover
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{i}) .nssg-action-delete")).not_to exist
			end
		end
	end
end

shared_examples "create a circle" do |circle_name, circle_description, box_name, tenant_name|
	describe "Create a circle with the name as #{circle_name}" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Press the 'New Circle' button" do
			@ui.click('#backoffice_circles_addnew_btn')
			sleep 1
		end
		it "Set the name value to #{circle_name} and the description value to #{circle_description}" do
			@ui.set_input_val('#edit_name', circle_name)
			sleep 1
			@ui.set_textarea_val('#edit_description', circle_description)
			sleep 1
		end
		it "Set the box dropdown list value to '#{box_name}" do
			@ui.set_dropdown_entry('edit_boxid', box_name)
			sleep 1
		end
		it "Assign the tenant #{tenant_name} to the circle" do
			@ui.click('#circledetails_addtentant')
			sleep 1
			expect(@ui.css('#add_tenants')).to exist
			@ui.set_input_val('#profile_tenants_add_modal_search_input', tenant_name)      
      sleep 1
      @browser.element(css: '#profile_tenants_add_modal_search_input').send_keys(:backspace)
			@ui.click('#profile_tenants_add_modal_search_btn')
			sleep 3
			@ui.click('#add_tenants .lhs .select_list ul li:first-child')
			sleep 3
			@ui.click('#tenants_add_modal_move_btn')
			sleep 2
			@ui.click('#circles_add_modal_addtenants_btn')
		end
		it "Press the 'Save' button" do
			@ui.click('.ko_slideout_content .bottom_buttons .buttons .orange')
			sleep 2
		end
		it "Search trough entries in the grid until the '#{circle_name}' line is located" do
			@ui.grid_click_on_specific_line("2", circle_name, "div")
		end
		it "Expect that the circle name is '#{circle_name}', tenant count is '1', the AOS Box name is '#{box_name}' and that the description is '#{circle_description}'" do
			sleep 1
			@ui.grid_verify_strig_value_on_specific_line("2", circle_name, "div","2", "div", circle_name)
			@ui.grid_verify_strig_value_on_specific_line("2", circle_name, "div","3", "a", "1 Tenant")
			@ui.grid_verify_strig_value_on_specific_line("2", circle_name, "div","4", "div", box_name)
			@ui.grid_verify_strig_value_on_specific_line("2", circle_name, "div","5", "div", circle_description)

		end
		it "Go to the AOS Boxes tab and ensure that the box shows '1 Circle' assigned" do
			@ui.click('#backoffice_tab_aosboxes')
			sleep 1
			expect(@browser.url).to include('#backoffice/aosboxes')
			sleep 1
			@ui.grid_verify_strig_value_on_specific_line("2", box_name, "div", "3", "a", "1 Circle")

		end
		it "Go to the Customers tab and ensure that the customer shows the '#{circle_name}' assigned" do
			@ui.click('#backoffice_tab_customers')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			sleep 4
			@ui.set_input_val('.xc-search input', tenant_name)
			sleep 5
			@ui.grid_verify_strig_value_on_specific_line("3", tenant_name, "a", "4", "div", circle_name)
		end
	end
end

shared_examples "add tenant to a circle" do |circle_name, tenant_name|
	describe "Assign the tenant '#{tenant_name}' to the circle named '#{circle_name}'" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Search trough entries in the grid until the '#{circle_name}' line is located and hover over it" do
			hover_over_specific_line_from_grid_without_paging("2", "div", circle_name)
		end
		it "Get the number of tenants assigned to the circle" do
			tenants_link_text = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").text

	        length = tenants_link_text.length
	        puts length
	        if (length == 8)
	        	$number_of_tenants = tenants_link_text[0]
	        elsif (length == 9)
	            $number_of_tenants = tenants_link_text[0]
	        elsif (length == 10)
	            $number_of_tenants = tenants_link_text[0..1]
	        end
	        puts "NUMBER OF TENANTS = #{$number_of_tenants}"
		end
		it "Click the tenants hyperlink for the line '#{circle_name}'" do
			@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").click
		end
		it "Expect that the 'Add Tenants modal overlay is displayed" do
			expect(@ui.css('#circles_add_modal')).to exist
		end
		it "Expect that the 'Current tenants for #{circle_name}' list contains the proper number of tenants" do
			list = @ui.css('#add_tenants .rhs .select_list .ko_container.ui-sortable')
			list.wait_until_present
			list_length = list.lis.length
			puts "LIST LENGTH = #{list_length}"
			puts "NUMBER OF TENANTS = #{$number_of_tenants}"
			expect(list_length).to eq($number_of_tenants.to_i)
		end
		it "Expect the 'all tenants' link not to be present and search for the entry named '#{tenant_name}'" do
			expect(@ui.css('#add_tenants .lhs .select_list .none_selected a')).not_to exist
			sleep 5
			@ui.set_input_val('#profile_tenants_add_modal_search_input', tenant_name)
			sleep 2
			@browser.element(css: '#profile_tenants_add_modal_search_input').send_keys(:backspace)
			sleep 1
			@ui.click('#profile_tenants_add_modal_search_btn')
			sleep 3
			list = @ui.css('#add_tenants .lhs .select_list .ko_container.ui-sortable')
			list.wait_until_present
			list_length = list.lis.length
			puts list_length

	        while (list_length != 0) do
		            if (@ui.css(".lhs ul li:nth-child(#{list_length})").text == tenant_name)
		                sleep 1
		                @ui.css(".lhs ul li:nth-child(#{list_length})").click
		                sleep 1
		                break
		            end
	            list_length-=1
			end
		end
		it "Press the 'Move' button" do
			@ui.click('#tenants_add_modal_move_btn')
		end
		it "Press the 'Set Tenants' button" do
			@ui.click('#circles_add_modal_addtenants_btn')
		end
		it "Get the number of tenants assigned to the circle" do
			tenants_link_text = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").text

	        length = tenants_link_text.length
	        if (length == 9 or length == 8)
	            $number_of_tenants_new = tenants_link_text[0]
	        elsif (length == 10)
	            $number_of_tenants_new = tenants_link_text[0..1]
	        end
		end
		it "Reopen the 'Add Tenants' modal for the '#{circle_name}' line " do
			@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").click
		end
		it "Expect that the 'Current tenants for #{circle_name}' list contains the proper number of tenants" do
			list = @ui.css('#add_tenants .rhs .select_list .ko_container.ui-sortable')
			list.wait_until_present
			list_length = list.lis.length
			puts "LIST LENGTH = #{list_length}"
			puts "NUMBER OF TENANTS = #{$number_of_tenants}"
			expect(list_length).to eq($number_of_tenants_new.to_i)
		end
		it "Verify that the '#{tenant_name}' entry appears in the 'Current tenants for #{circle_name}' column" do
			list = @ui.css('#add_tenants .rhs .select_list .ko_container.ui-sortable')
			list.wait_until_present
			list_length = list.lis.length
			puts list_length

	        while (list_length != 0) do
		            if (@ui.css(".rhs ul li:nth-child(#{list_length})").text == tenant_name)
		                sleep 1
		                @ui.css(".rhs ul li:nth-child(#{list_length})").click
		                sleep 1
		                break
		            end
	            list_length-=1
			end
		end
		it "Close the 'Add Tenants' modal" do
			# @ui.click('#circles_add_modal_closemodalbtn')
			@ui.click('#circles_add_modal_cancel_btn');
		end
	end
end

#shared_examples "remove all tenants from a certain circle" do |circle_name|
#	describe "Remove all the tenants that are assigned to a certain circle" do
#		it "Ensure you are on the Circles tab" do
#			@ui.click('#backoffice_tab_circles')
#			sleep 1
#			expect(@browser.url).to include('#backoffice/circles')
#		end
#		it "Search trough entries in the grid until the '#{circle_name}' line is located and hover over it" do
#			hover_over_specific_line_from_grid_without_paging("2", "div", circle_name)
#		end
#		it "Get the number of tenants assigned to the circle" do
#			tenants_link_text = @ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").text
#
#	        length = tenants_link_text.length
#	        if (length == 9)
#	            $number_of_tenants = tenants_link_text[0]
#	        elsif (length == 10)
#	            $number_of_tenants = tenants_link_text[0,1]
#	        end
#		end
#		it "Click the tenants hyperlink for the line '#{circle_name}'" do
#			@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) td:nth-child(3) a").click
#		end
#		it "Expect that the 'Add Tenants modal overlay is displayed" do
#			expect(@ui.css('#circles_add_modal')).to exist
#		end
#		it "Expect that the 'Current tenants for #{circle_name}' list contains the proper number of tenants" do
#			list = @ui.css('#add_tenants .rhs .select_list .ko_container.ui-sortable')
#			list.wait_until_present
#			$list_length = list.lis.length
#			expect($list_length).to eq($number_of_tenants.to_i)
#		end
#		it "" do
#	        while ($list_length != 0) do
#	        	@ui.css(".rhs ul li:nth-child(#{list_length})").click
#		        sleep 1
#		        a = @ui.css(".rhs ul li:nth-child(#{list_length})").text
#	            $list_length-=1
#			end
#		end
#	end
#end

shared_examples "cannot delete a circle with tenant" do |circle_name|
	describe "Ensure that the circle with the name #{circle_name} cannot be deleted because it has a tenant assigned" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Search trough entries in the grid until the '#{circle_name}' line is located" do
			grid_entries = @ui.css('.nssg-table .nssg-tbody')
			grid_entries.wait_until_present
			grid_length = grid_entries.trs.length

	        while (grid_length != 0) do
		            if (@ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(2) div").text == circle_name)
		                sleep 1
		                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(2)").hover
		                @ui.css(".nssg-table tbody tr:nth-child(#{grid_length}) td:nth-child(2)").click
		                sleep 1
		                $grid_length_global = grid_length
		                break
		            end
	            grid_length-=1
			end
		end
		it "Try to delete the circle named '#{circle_name}' and ensure that an error message is received by the user, also verify the text string" do
			sleep 1
			@ui.css(".nssg-table tbody tr:nth-child(#{$grid_length_global}) .nssg-actions-container .nssg-action-delete").click
			sleep 0.3
			expect(@ui.css('.msgbody')).to be_visible
			expect(@ui.css('.msgbody div').text).to eq('Error removing circle. Please remove all tenants from the circle before removing the circle.')
		end
	end
end

shared_examples "delete a circle" do |circle_name|
	describe "Delete the circle with the name as #{circle_name}" do
		it "Ensure you are on the Circles tab" do
			@ui.click('#backoffice_tab_circles')
			sleep 1
			expect(@browser.url).to include('#backoffice/circles')
		end
		it "Search trough entries in the grid until the '#{circle_name}' line is located and delete the line" do
			@ui.grid_action_on_specific_line("2", "div", circle_name, "delete")
      		sleep 1
		end
		it "Accept the delete prompt" do
			sleep 1
			@ui.click('#_jq_dlg_btn_1')
			sleep 1
		end
		it "Verify that the entry '#{circle_name}' does not appear in the grid anymore" do
			grid_entries = @ui.css('.nssg-table .nssg-tbody')
			grid_entries.wait_until_present
			grid_length_local = grid_entries.trs.length

	        while (grid_length_local != 0) do
		            if (@ui.css(".nssg-table tbody tr:nth-child(#{grid_length_local}) td:nth-child(2) div").text == circle_name)
						puts "The entry #{circle_name} still appears in the grid !!!"
		            end
	            grid_length_local-=1
			end
		end
	end
end

shared_examples "cant edit a customer" do
	describe "Verify Cloud Admin user can't edit a customer" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 4
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Focus on the grid and place a tick for the first line" do
			@ui.css(".nssg-table tbody tr:nth-child(1) td:first-child .mac_chk_label").hover
	        sleep 1
	        @ui.css(".nssg-table tbody tr:nth-child(1) td:first-child .mac_chk_label").click
	        sleep 2
        end
        it "Verify that the 'Set as Scope' button is visible" do
        	expect(@ui.css('#bo-cu-scope-btn')).to be_present
        end
        it "Hover over the first ten lines and verify that the application does not show the context buttons" do
			(1..10).each do |i|
				@ui.css(".nssg-table tbody tr:nth-child(#{i}) .name").hover
				expect(@ui.css(".nssg-table tbody tr:nth-child(#{i}) .nssg-td-actions")).not_to exist
			end
		end
	end
end

shared_examples "cant edit browsing tenant area" do |tenant_name, grid_length|
	describe "Search for the customer named '#{tenant_name}' and open it for browsing" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Search for the customer named '#{tenant_name}'" do
			@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', tenant_name)
		end
		it "Ensure that the search yealds at least '#{grid_length}' results" do
			@ui.get_grid_length
			expect($grid_length).to be >= grid_length
		end
		it "Press the '#{tenant_name}' hyperlink" do
			@ui.grid_click_on_specific_line("2", tenant_name, "a")
			sleep 2
		end
		it "Ensure that the application is on the #{tenant_name} customer's dashboard" do
			expect(@ui.css('#customerDash_view')).to exist
			expect(@ui.css('#customerDash_view')).to be_visible
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Expect that the Browsing Tenant: value is #{tenant_name}" do
			expect(@ui.css('#customerDash_view div:nth-child(2) span:nth-child(2)').text).to eq(tenant_name)
		end
		it "Expect that the view contains two tabs: Access Points and User Accounts" do
			expect(@ui.css('#customerDash_tab_arrays')).to exist
			expect(@ui.css('#customerDash_tab_arrays')).to be_visible
			expect(@ui.css('#customerDash_tab_users')).to exist
			expect(@ui.css('#customerDash_tab_users')).to be_visible
		end
	end
end


shared_examples "change customer from one circle to another" do |tenant_name, to_circle|
	describe "Change the customer '#{tenant_name}' to the circle named '#{to_circle}'" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 4
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Open the details slideout for the customer named '#{tenant_name}'" do
			@ui.set_input_val('.xc-search input', tenant_name)
			sleep 5
			@ui.grid_action_on_specific_line("3", "a", tenant_name, "invoke")
      		sleep 1
		end
		it "Change the circle dropdown list to the value #{to_circle} and save the change" do
			sleep 3
			@ui.set_dropdown_entry('customerdetails_config_curcle', to_circle)
			sleep 1
			@ui.click('.ko_slideout_content .bottom_buttons .buttons .orange')
		end
		it "Verify that the entry '#{to_circle}' is assigned for the customer '#{tenant_name}'" do
			@ui.grid_verify_strig_value_on_specific_line("3", tenant_name, "a", "4", "div", to_circle)
			sleep 3
			@ui.click('#backoffice-customers .commonTitle')
		end
	end
end

shared_examples "verify customer slideout details" do |tenant_name, erp_id, circle_name|
	describe "Verify the details on the slideout window for the customer named #{tenant_name}" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Open the details slideout for the customer named '#{tenant_name}'" do
			@ui.grid_action_on_specific_line("3", "a", tenant_name, "invoke")
      		sleep 1
		end
		it "Verify that the slideout is opened and the details are: Name = #{tenant_name}, ERP ID = #{erp_id} and Circle = #{circle_name}" do
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).to exist
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).to be_visible
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content .tab_contents .info_block div:nth-child(2) div').text).to eq(tenant_name)
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content .tab_contents .info_block div:nth-child(3) div').text).to eq(erp_id)
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content .tab_contents .info_block div:nth-child(4) div span a span:first-child').text).to eq(circle_name)
		end
		it "Close the slideout" do
			@ui.click('#customerdetails_close_btn')
			sleep 0.5
			expect(@ui.css('.tabpanel_slideout .ko_slideout_content')).not_to be_visible
		end
	end
end

shared_examples "search for customer and verify grid responds" do |tenant_name, expected_entries|
	describe "Search for the customer named '#{tenant_name}' and verify that the displayed entries equal '#{expected_entries}'" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Set the View option to '500' entries per page" do
			@ui.css(".nssg-paging-selector-container").wait_until_present
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","500")
		end
		it "Search for the customer named '#{tenant_name}'" do
			@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', tenant_name)
		end
		it "Ensure that the search yealds the number of results as '#{expected_entries}'" do
			if (@ui.css(".nssg-table .nssg-tbody").visible?)
				@ui.get_grid_length
				expect($grid_length).to be >= expected_entries
			else
				expect(@ui.css(".nssg-table .nssg-tbody")).not_to be_visible
			end
		end
		it "Ensure that the information bubble displays the string '#{expected_entries} Search results'" do
			expect(@ui.css('.push-down .v-center .clearfix search .xc-search div:first-child span:first-child').text.to_i).to be >= expected_entries
		end
		it "Set the View option to '1000' entries per page" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul","1000")
		end
		it "Cancel the search" do
			@ui.click('.push-down .v-center .clearfix search .xc-search .btn-clear')
		end
		it "Expect that the grid length is not equal to '250'" do
			@ui.get_grid_length
			expect($grid_length).not_to eq(250)
		end
		it "Search for the customer named '#{tenant_name}'" do
			@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', tenant_name)
		end
		it "Ensure that the search yealds the number of results as #{expected_entries}" do
			if (@ui.css(".nssg-table .nssg-tbody").visible?)
				@ui.get_grid_length
				expect($grid_length).to be >= expected_entries
			else
				expect(@ui.css(".nssg-table .nssg-tbody")).not_to be_visible
			end
		end
		it "Cancel the search" do
			@ui.click('.push-down .v-center .clearfix search .xc-search .btn-clear')
		end
	end
end

shared_examples "open a customers dashboard view" do |tenant_name, grid_length|
	describe "Search for the customer named '#{tenant_name}' and open it for browsing" do
		it "Ensure you are on the Customers tab" do
			@ui.click('#backoffice_tab_customers')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
		end
		it "Search for the customer named '#{tenant_name}'" do
			@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', tenant_name)
		end
		it "Ensure that the search yealds at least '#{grid_length}' results" do
			@ui.get_grid_length
			expect($grid_length).to be >= grid_length
		end
		it "Press the '#{tenant_name}' hyperlink" do
			@ui.grid_click_on_specific_line("3", tenant_name, "a")
			sleep 2
		end
		it "Ensure that the application is on the #{tenant_name} customer's dashboard" do
			expect(@ui.css('#customerDash_view')).to exist
			expect(@ui.css('#customerDash_view')).to be_visible
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Expect that the Browsing Tenant: value is #{tenant_name}" do
			expect(@ui.css('#customerDash_view div:nth-child(2) span:nth-child(2)').text).to eq(tenant_name)
		end
		it "Expect that the view contains two tabs: Access Points and User Accounts" do
			expect(@ui.css('#customerDash_tab_arrays')).to exist
			expect(@ui.css('#customerDash_tab_arrays')).to be_visible
			expect(@ui.css('#customerDash_tab_users')).to exist
			expect(@ui.css('#customerDash_tab_users')).to be_visible
		end
	end
end

shared_examples "verify acces points grid on customers dashboad view command line interface" do |ap_sn, ap_name, server, cloud_server|
	describe "Verify the access points functions work on the AP grid from the customers dashboard view" do
		it "Ensure you are on the Access Points tab" do
			@ui.click('#customerDash_tab_arrays')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Focus on the line with the Serial Number value of #{ap_sn} and open the Command Line Interface" do
			@ui.grid_action_on_specific_line("3","div",ap_sn,"cli")
			sleep 1
			expect(@ui.css('#profile_arrays_details_slideout .ko_slideout_content')).to be_visible
			sleep 1
		end
		it "Test the AP CLI" do
			@ui.click('#arraydetails_tab_cli')
	      	sleep 1

		   	status = @ui.css('.slideout_title .online_status')
		   	status.wait_until_present
		   	if status.text=="Online"
		   	    @ui.click('.array-details-cli-agreement-btn')
		   	    cli = @ui.get(:textarea, {id: 'array-details-cli-commands-input'})
		   	    cli.wait_until_present
		   	    cli.send_keys 'show running-config'
		   	    #cli.send_keys :enter
		   	    #cli.send_keys 'iaps'

	     	    @ui.click('#array-details-cli-submit')
	     	    sleep 10

	     	    resp = @ui.get(:textarea, { css: '.array-details-cli-results-response' })
	     	    resp.wait_until_present

	     	    expect(resp.value).to include('hostname ' + ap_name)
	     	    expect(resp.value).to include(server)
	     	    expect(resp.value).to include('cloud enable')
	     	    expect(resp.value).to include(cloud_server)
	     	else
	     	  puts "Access Point is offline !"
		    end
	      	@ui.click('#arraydetails_close_btn')
		end
	end
end

shared_examples "verify acces points grid on customers dashboad view delete from grid" do |ap_sn|
	describe "Verify that an access point can be deleted using the context delete button on the AP grid from the customers dashboard view" do
		it "Ensure you are on the Access Points tab" do
			@ui.click('#customerDash_tab_arrays')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Focus on the line with the Serial Number value of #{ap_sn} and press the delete context button" do
			@ui.grid_action_on_specific_line("3","div",ap_sn,"delete")
			sleep 1
		end
		it "Confirm the deletion" do
			@ui.click('#_jq_dlg_btn_1')
		end
		it "Search for the AP with the Serial Number #{ap_sn}" do
			if @ui.css('.push-down .v-center .clearfix search .xc-search input').present?
				@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', ap_sn)
				sleep 1
				@ui.click('.push-down .v-center .clearfix search .xc-search .btn-search')
			end
		end
		#it "Expect that the application displays an error message with the string 'No array found matching the search'" do
		#	expect(@ui.css(".msgbody")).to be_visible
		#	expect(@ui.css('.msgbody div').text).to eq('No array found matching the search.')
		#end
		it "Expect that the application does not display any lines in the grid" do
			expect(@ui.css(".nssg-table .nssg-tbody")).not_to be_visible
		end
		it "Cancel the search" do
			if @ui.css('.push-down .v-center .clearfix search .xc-search input').present?
				@ui.click('.push-down .v-center .clearfix search .xc-search .btn-clear')
			end
		end
	end
end

shared_examples "verify acces points grid on customers dashboad view delete from button" do |ap_sn|
	describe "Verify that an access point can be deleted using the grid's delete button on the AP grid from the customers dashboard view" do
		it "Ensure you are on the Access Points tab" do
			@ui.click('#customerDash_tab_arrays')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Focus on the line with the Serial Number value of #{ap_sn} and place a tick" do
			@ui.grid_tick_on_specific_line("3",ap_sn,"div")
			sleep 1
		end
		it "Focus on the information bubble and verify it displays 1 AP selected" do
			expect(@ui.css('#backoffice_arrays .bubble .count').text).to eq("1")
		end
		it "Ensure that the 'Delete' and 'Clear Penalty' buttons are displayed " do
			expect(@ui.css('#backoffice_arrays_delete_btn')).to be_visible
			expect(@ui.css('#backoffice_arrays_clear_penalty_array_btn')).to be_visible
		end
		it "Press the 'Delete' button" do
			@ui.click('#backoffice_arrays_delete_btn')
		end
		it "Confirm the deletion" do
			@ui.click('#_jq_dlg_btn_1')
		end
		it "Search for the AP with the Serial Number #{ap_sn}" do
			if @ui.css('.push-down .v-center .clearfix search .xc-search input').present?
				@ui.set_input_val('.push-down .v-center .clearfix search .xc-search input', ap_sn)
				sleep 1
				@ui.click('.push-down .v-center .clearfix search .xc-search .btn-search')
				sleep 1
			end
		end
		#it "Expect that the application displays an error message with the string 'No array found matching the search'" do
		#	expect(@ui.css(".msgbody")).to be_visible
		#	expect(@ui.css('.msgbody div').text).to eq('No array found matching the search.')
		#end
		it "Expect that the application does not display any lines in the grid" do
			expect(@ui.css(".nssg-table .nssg-tbody")).not_to be_visible
		end
		it "Cancel the search" do
			if @ui.css('.push-down .v-center .clearfix search .xc-search input').present?
				@ui.click('.push-down .v-center .clearfix search .xc-search .btn-clear')
			end
		end
	end
end

shared_examples "verify acces points grid on customers dashboad view clear penalty on ap" do |ap_sn1|
	describe "Verify that several access points can be deleted on the AP grid from the customers dashboard view" do
		it "Ensure you are on the Access Points tab" do
			@ui.click('#customerDash_tab_arrays')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
		end
		it "Focus on the line with the Serial Number value of #{ap_sn1} and place a tick" do
			@ui.grid_tick_on_specific_line("3",ap_sn1,"div")
			sleep 1
		end
		it "Focus on the information bubble and verify it displays 1 AP selected" do
			expect(@ui.css('#backoffice_arrays .bubble .count').text).to eq("1")
		end
		it "Ensure that the 'Delete' and 'Clear Penalty' buttons are displayed " do
			expect(@ui.css('#backoffice_arrays_delete_btn')).to be_visible
			expect(@ui.css('#backoffice_arrays_clear_penalty_array_btn')).to be_visible
		end
		it "Press the 'Clear Penalty' button" do
			@ui.click('#backoffice_arrays_clear_penalty_array_btn')
		end
		it "Press the 'Clear Penalty' button and ensure that the clear penaly message is displayed" do
			@ui.click('#backoffice_arrays_clear_penalty_array_btn')
			sleep 0.5
			expect(@ui.css('.msgbody')).to exist
			expect(@ui.css('.msgbody div').text).to eq("Penalty has been cleared")
		end
	end
end

shared_examples "verify acces points grid on customers dashboad view clear penalty several aps" do |ap_sn1, ap_sn2|
	describe "Verify the access points' penalties can be cleared on the AP grid from the customers dashboard view" do
		it "Ensure you are on the Access Points tab" do
			@ui.click('#customerDash_tab_arrays')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/arrays')
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "100")
			@browser.refresh
			sleep 2
		end
		it "Focus on the line with the Serial Number value of #{ap_sn1} and place a tick" do
			@ui.grid_tick_on_specific_line("3",ap_sn1,"div")
			sleep 1
		end
		it "Focus on the line with the Serial Number value of #{ap_sn2} and place a tick" do
			@ui.grid_tick_on_specific_line("3",ap_sn2,"div")
			sleep 1
		end
		it "Focus on the information bubble and verify it displays 2 APs selected" do
			expect(@ui.css('#backoffice_arrays .bubble .count').text).to eq("2")
		end
		it "Ensure that the 'Clear Penalty' button is displayed " do
			expect(@ui.css('#backoffice_arrays_delete_btn')).not_to be_visible
			expect(@ui.css('#backoffice_arrays_clear_penalty_array_btn')).to be_visible
		end
		it "Press the 'Clear Penalty' button and ensure that the clear penaly message is displayed" do
			@ui.click('#backoffice_arrays_clear_penalty_array_btn')
			sleep 0.5
			expect(@ui.css('.msgbody')).to exist
			expect(@ui.css('.msgbody div').text).to eq("Penalty has been cleared")
			sleep 1
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "10")
		end
	end
end

shared_examples "customers dashboard view delete all user accounts" do |lastname_not_to_del|
  describe "delete all user accounts except the one with the last name: #{lastname_not_to_del}" do
    it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
    it "Set the view per page to '1000' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "1000")
    end
    it "Delete all User Accounts except from #{lastname_not_to_del} (last name)" do
      abc = @ui.css('.nssg-paging-count').text

      i = abc.index('of')
      length = abc.length
      number = abc[i + 3, abc.length]
      number2 = number.to_i

      while (number2 != 0) do
        if (@ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(5)").text.strip != lastname_not_to_del)
            sleep 1
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) td:nth-child(3)").hover
            sleep 1
            @ui.css(".nssg-table tbody tr:nth-child(#{number2}) .nssg-actions-container .nssg-action-delete").click
            sleep 1
            @ui.click('#_jq_dlg_btn_1')
            sleep 4
            @ui.click('.globalTitle')
            sleep 1
        end
        number2-=1
      end
    end
    it "Set the view per page to '10' entries" do
      @ui.click('.nssg-paging .nssg-paging-selector-container .ko_dropdownlist_button .arrow')
      @ui.ul_list_select_by_string('.ko_dropdownlist_list.active .ko_dropdownlist_list_wrapper ul', "10")
    end
  end
end

shared_examples "verify user accounts grid on customers dashboard view add user" do |user_email, first_name, last_name, additional_details, priviledges_xms, priviledges_cloud|
	describe "Verify that an user account line can be added from the Browsing Tenant view" do
		it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
		it "Add the user with the following values: first_name = '#{first_name}' /// last_name = '#{last_name}' /// email = '#{user_email}' /// XMS = '#{priviledges_xms}' /// cloud = '#{priviledges_cloud}'" do
	        @browser.execute_script('$("#suggestion_box").hide()')
			sleep 1
	        @ui.click('#useraccounts_newuser_btn')
	        sleep 1
	        @ui.set_input_val('#usermodal_firstname',first_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_lastname',last_name)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_email',user_email)
	        sleep 0.5
	        @ui.set_input_val('#usermodal_details', additional_details)
	        sleep 0.5
	        @ui.set_dropdown_entry('ddl_role',priviledges_xms)
	        sleep 0.5
	        if !priviledges_cloud.nil?
	         @ui.set_dropdown_entry('ddl_backoffice',priviledges_cloud)
	        end
	    end
	    it "Save the user" do
	        @ui.click('#users_modal_save_btn')
	        sleep 3
	        expect(@ui.css('.tabpanel_slideout.left.opened')).not_to exist
	    end
	    it "Verify that the user is properly created and has the values: '#{first_name}' + '#{last_name}' + '#{user_email}' + '#{priviledges_xms}' + '#{priviledges_cloud}'" do
	        sleep 0.5
	        case priviledges_cloud
	        when nil
              priviledges = priviledges_xms
	        	when "None"
	        		priviledges = priviledges_xms
	        	when "Admin"
	        		if priviledges_xms == "Domain Admin" or priviledges_xms == "XMS User" or priviledges_xms == "XMS Read Only" or priviledges_xms == "XMS-E Guest Admin"
	        			priviledges = "Backoffice " + priviledges_cloud + ", " + priviledges_xms
	        		else
	        			priviledges = priviledges_xms + ", Backoffice " + priviledges_cloud
	        		end
	        	when "Super Admin"
	        		if priviledges_xms == "Domain User"
	        			priviledges = priviledges_xms + ", Backoffice " + priviledges_cloud
	        		else
	        			priviledges = "Backoffice " + priviledges_cloud + ", " + priviledges_xms
	        		end
	        end
	        user_accounts_grid_actions("verify strings", user_email, first_name, last_name, additional_details, priviledges)
	    end
	end
end

shared_examples "verify user accounts grid on customers dashboard view edit user" do |user_email, first_name, last_name, additional_details, priviledges|
	describe "Verify that an user account line can be edited" do
	    it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
	    it "edit a user" do
	        @browser.execute_script('$("#suggestion_box").hide()')
	        user_accounts_grid_actions("invoke",user_email,"","","","")

	        @ui.set_input_val('#usermodal_firstname',first_name)
	        sleep 1
	        @ui.click('#users_modal_save_btn')
	        sleep 2
	        @ui.click('#user_grid .base_top .nssg-paging .nssg-refresh')
	        sleep 2
	        @ui.css('.nssg-table tbody tr:nth-child(1)').hover
			user_accounts_grid_actions("verify strings",user_email,first_name,last_name,additional_details,priviledges)
	    end
	end
end

shared_examples "verify user accounts grid on customers dashboard view delete user from context button" do |user_email|
	describe "Verify that an user account line can be deleted from the context 'Delete' button" do
	    it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
	    it "delete a user" do
	        @browser.execute_script('$("#suggestion_box").hide()')
	        tbody = @ui.css('.nssg-table tbody')
	        tbody.wait_until_present
	        len = tbody.trs.length

	        user_accounts_grid_actions("delete",user_email,"","","","")
	        sleep 2
	        @ui.confirm_dialog
	        sleep 1

	        tbody = @ui.css('.nssg-table tbody')
	        expect(tbody.trs.length).to eq(len - 1)
	        sleep 1
	        if (@ui.css('.tabpanel_slideout.left.opened').exists?)
	        	@ui.click('#guestdetails_close_btn')
	        end
	        #@browser.refresh
	        (0..3).each do
	        	@ui.css('.nssg-paging .nssg-refresh').click
	        	sleep 0.5
	    	end
	    end
	end
end

shared_examples "verify user accounts grid on customers dashboard view delete user from grid button" do |user_email|
	describe "Verify that an user account line can be deleted from the 'Delete' button above the grid" do
		it "Ensure you are on the Users tab" do
			@ui.click('#customerDash_tab_users')
			sleep 1
			expect(@browser.url).to include('#backoffice/customers')
			expect(@browser.url).to include('/users')
		end
	    it "delete a user" do
	        @browser.execute_script('$("#suggestion_box").hide()')
	        tbody = @ui.css('.nssg-table tbody')
	        tbody.wait_until_present
	        len = tbody.trs.length

	        user_accounts_grid_actions("check",user_email,"","","","")
	        sleep 1
	        @ui.click('#useraccounts_delete_btn')
	        sleep 1
	        @ui.confirm_dialog
	        sleep 1

	        tbody = @ui.css('.nssg-table tbody')
	        expect(tbody.trs.length).to eq(len - 1)
	        sleep 1
	        @browser.refresh
	    end
	end
end

shared_examples "verify go back from browsing tenant view" do
	describe "Verify the 'GO BACK' hyperlink from the browsing tenant view area navigates to the proper place" do
		it "Verify that the location is on the 'Browsing Tenant' and that the 'Go Back' hyperlink exists" do
			if(@browser.url.include?("#backoffice/customers") and @browser.url.include?("/users"))
				expect(@ui.css('#customerDash_view a.globalSubtitle')).to be_visible
			elsif (@browser.url.include?("#backoffice/customers") and @browser.url.include?("/arrays"))
				expect(@ui.css('#customerDash_view a.globalSubtitle')).to be_visible
			else
				puts "Skipping this ..."
			end
		end
		it "Press the 'Go Back' link" do
			@ui.click('a.globalSubtitle')
			sleep 1
		end
		it "Verify that the location is Support Management / Customers tab" do
			expect(@browser.url).to include("#backoffice/customers")
			expect(@ui.css('#customerDash_view')).not_to exist
		end
		it "Change to the Access Points tab" do
			@ui.click('#backoffice_tab_arrays')
			sleep 2
			expect(@browser.url).to include('#backoffice/arrays')
		end
		it "Click the first AP line's tenant link" do
			@ui.css('.nssg-table tbody tr:first-child td:nth-child(3) a').click
		end
		it "Verify that the location is on the 'Browsing Tenant' area" do
			expect(@browser.url).to include("#backoffice/arrays")
			expect(@ui.css('#customerDash_view')).to be_visible
		end
		it "Press the 'Go Back' link" do
			@ui.click('a.globalSubtitle')
			sleep 1
		end
		it "Verify that the location is Support Management / Customers tab" do
			expect(@browser.url).to include("#backoffice/arrays")
			expect(@ui.css('#customerDash_view')).not_to exist
		end
	end
end

shared_examples "aa" do
	describe "aaa" do
		it "Ensure you are on the 'Access Points' tab" do
			@ui.click("#backoffice_tab_arrays") and sleep 1
			@ui.span(:text => "Access Points").wait_until_present
			expect(@browser.url).to include('/#backoffice/arrays')
		end
		it "Set the view type to '50'" do
			if @ui.css('.nssg-paging-pages .text') != "10"
				@ui.click('.nssg-paging-pages .arrow')
				sleep 1
				@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "10")
				sleep 2
			end
		end
		it "Verify that the sort order is set to ascending on the 'Status' column" do
			@ui.find_grid_header_by_name_support_management("Status")
			$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"
			if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
				sleep 2
				@ui.css("#{$column_string} .nssg-th-text").click
				expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				elsif (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
					(1..2).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 2
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
				else
					(1..3).each do |i|
						@ui.css("#{$column_string} .nssg-th-text").click
						sleep 2
					end
					expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
			end
			sleep 2
		end
		it 'Go to the end of the list' do
			@ui.click('.nssg-paging-last')
			sleep 2
			@ui.css('.nssg-table tbody').wait_until_present
		end
		#it "Verify 'STATUS' column entries, find 'Error' status and verify the 'Show More' / 'Show Less' links" do
		#	find_error_status_lines_and_peform_action("Verify 'Show More' / 'Show Less'")
		#end
		it "Verify 'STATUS' column entries, find 'Error' status and go to the needed tenant and verify the 'Show More' / 'Show Less' links and error message on the My network -> Access points tab" do
			find_error_status_lines_and_peform_action("Go to needed tenant and verify 'Show More' / 'Show Less'")
		end
	end
end

def find_error_status_lines_and_peform_action(action)
	needed_entries = find_lines_with_certain_value(6, "Error")
	puts "NEEDED ENTRIES #{needed_entries}"
	while needed_entries == []
		original_page = @ui.get(:input , {css: '.nssg-paging-current'}).value
		@ui.click('.nssg-paging-prev')
		until @ui.get(:input , {css: '.nssg-paging-current'}).value != (original_page.to_i - 1).to_s
			sleep 0.5
		end
		sleep 1
		needed_entries = find_lines_with_certain_value(6, "Error")
		puts "NEEDED ENTRIES on the page '#{@ui.get(:input , {css: '.nssg-paging-current'}).value}' #{needed_entries}"
		sleep 1
		if needed_entries != []
			@is_init = true
			@new_page_number = @ui.get(:input , {css: '.nssg-paging-current'}).value
			puts "NEW page number #{@new_page_number}"
			break
		end
	end
	while needed_entries != []
		sleep 2
		if !@is_init
			@ui.click('.nssg-paging-prev')
			until @ui.get(:input , {css: '.nssg-paging-current'}).value != (original_page.to_i - 1).to_s
				sleep 0.5
			end
			sleep 1
			needed_entries = find_lines_with_certain_value(6, "Error")
			@new_page_number = @ui.get(:input , {css: '.nssg-paging-current'}).value
			puts "NEEDED ENTRIES (ON THE NEW PAGE '#{@new_page_number}).value}' ) #{needed_entries}"
		end
		if needed_entries == []
			break
		end
		@is_init = false
		puts "@@PAGE I CURRENTLY AM ON '#{@ui.get(:input , {css: '.nssg-paging-current'}).value}'"
		needed_entries.each do |i|
			puts "i = #{i}"
			@ui.click(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(6) .info_cell")
			sleep 0.5
			# expect(@ui.css(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(6) .info_cell").attribute_value("class")).to include("ko_tooltip_active")
			# sleep 0.5
			expect(@ui.css(".ko_tooltip .ko_tooltip_content")).to be_present
			expect(@ui.css(".ko_tooltip .ko_tooltip_content .title").text).to eq("Error")
			if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").exists?
				if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").visible?
					if action == "Verify 'Show More' / 'Show Less'"
						@ui.click(".ko_tooltip .ko_tooltip_content .show-more-info")
						sleep 1
						expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox")).to be_present
						sleep 2
						@ui.click(".ko_tooltip .ko_tooltip_content .show-less-info")
					elsif action == "Go to needed tenant and verify 'Show More' / 'Show Less'"
						@ui.click(".ko_tooltip .ko_tooltip_content .show-more-info")
						sleep 1
						expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox")).to be_present
						@needed_serial_number = @ui.css(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(4) div").text
						@needed_string = @ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox").text
						@ui.click(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(3) a")
						sleep 1
						@ui.css('#bcustomerDash_scope_btn').wait_until_present
						sleep 2
						if @ui.css('.nssg-paging-pages .text') != "100"
							@ui.click('.nssg-paging-pages .arrow')
							sleep 1
							@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "100")
							sleep 2
						end
						new_needed_entries = find_lines_with_certain_value(4, "Error")
						#puts "NEW NEEDED ENTRIES #{new_needed_entries}"
						new_needed_entries.each do |u|
							#puts "u = #{u}"
							@ui.click(".nssg-table tbody tr:nth-child(#{u}) td:nth-child(4) .info_cell")
							sleep 0.5
							expect(@ui.css(".ko_tooltip .ko_tooltip_content")).to be_present
							expect(@ui.css(".ko_tooltip .ko_tooltip_content .title").text).to eq("Error")
							if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").exists?
								if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").visible?
									@ui.click(".ko_tooltip .ko_tooltip_content .show-more-info")
									sleep 1
									expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox")).to be_present
									if @ui.css(".nssg-table tbody tr:nth-child(#{u}) td:nth-child(3) div").text == @needed_serial_number
										expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox").text).to eq(@needed_string)
										sleep 2
									end
									sleep 2
									@ui.click(".ko_tooltip .ko_tooltip_content .show-less-info")
								end
							end
						end
						sleep 1
						@ui.click('#bcustomerDash_scope_btn')
						sleep 5
						@ui.css('#header_mynetwork_link').wait_until_present
						if @ui.css('.toast-message').exists?
							@ui.click('.btn.clear')
							sleep 2
						end
						@ui.click('#header_mynetwork_link')
						sleep 1
						@ui.css('#mynetwork_tab_arrays').wait_until_present
						@ui.click('#mynetwork_tab_arrays')
						sleep 1
						@ui.css('.nssg-table tbody').wait_until_present
						@ui.find_grid_header_by_name("Status")
						@status_column_number = $header_count
						@ui.find_grid_header_by_name("Serial Number")
						@serial_column_number = $header_count
						new_new_needed_entries = find_lines_with_certain_value(@status_column_number, "Error")
						#puts "NEW NEW NEEDED ENTRIES #{new_new_needed_entries}"
						new_new_needed_entries.each do |o|
							#puts "o = #{o}"
							@ui.click(".nssg-table tbody tr:nth-child(#{o}) td:nth-child(#{@status_column_number}) .info_cell")
							sleep 0.5
							expect(@ui.css(".ko_tooltip .ko_tooltip_content")).to be_present
							expect(@ui.css(".ko_tooltip .ko_tooltip_content .title").text).to eq("Error")
							if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").exists?
								if @ui.css(".ko_tooltip .ko_tooltip_content .show-more-info").visible?
									if @ui.css(".nssg-table tbody tr:nth-child(#{o}) td:nth-child(#{@serial_column_number}) a").text == @needed_serial_number
										@ui.click(".ko_tooltip .ko_tooltip_content .show-more-info")
										sleep 1
										expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox")).to be_present
										expect(@ui.css(".ko_tooltip .ko_tooltip_content .subtitle.greybox").text).to eq(@needed_string)
										sleep 2
										@ui.click(".ko_tooltip .ko_tooltip_content .show-less-info")
										sleep 1
										puts 'GOING BACK'
										@ui.click('#header_nav_user')
										sleep 1
										@ui.click('#header_backoffice_link')
										sleep 3
										@ui.click("#backoffice_tab_arrays") and sleep 1
										@ui.span(:text => "Access Points").wait_until_present
										expect(@browser.url).to include('/#backoffice/arrays')
										@ui.css('.nssg-paging-pages .arrow').wait_until_present
										if @ui.css('.nssg-paging-pages .text') != "50"
											@ui.click('.nssg-paging-pages .arrow')
											sleep 1
											@ui.ul_list_select_by_string(".ko_dropdownlist_list.active ul", "10")
											sleep 2
										end
										@ui.find_grid_header_by_name_support_management("Status")
										$column_string = ".nssg-thead tr:nth-child(1) th:nth-child(#{$header_count})"
										if (@ui.css("#{$column_string}.nssg-sorted-desc").exists?)
											sleep 2
											@ui.css("#{$column_string} .nssg-th-text").click
											expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
											elsif (@ui.css("#{$column_string}.nssg-sorted-asc").exists?)
												(1..2).each do |i|
													@ui.css("#{$column_string} .nssg-th-text").click
													sleep 2
												end
												expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
											else
												(1..3).each do |i|
													@ui.css("#{$column_string} .nssg-th-text").click
													sleep 2
												end
												expect(@ui.css("#{$column_string}.nssg-sorted-asc")).to exist
										end
										sleep 2
										@ui.click('.nssg-paging-last')
										sleep 2
										@ui.css('.nssg-table tbody').wait_until_present
										sleep 2
										puts "NEEDED page number #{@new_page_number}"
										puts "ACTUAL NEW page number #{@ui.get(:input , {css: '.nssg-paging-current'}).value}"
										until @ui.get(:input , {css: '.nssg-paging-current'}).value == @new_page_number
											sleep 0.5
											@ui.click('.nssg-paging-prev')
											puts "CLICKED THE PAGE CHANGE"
											sleep 5
											puts "ACTUAL NEW page number #{@ui.get(:input , {css: '.nssg-paging-current'}).value}"
										end
										puts "HERE'S JOHNNY !"
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

def find_lines_with_certain_value(what_column, what_value)
	puts "intrat in find lines"
	@ui.css('.nssg-table tbody').wait_until_present
	grid_entries = @ui.css('.nssg-table tbody').trs.length
	expect(grid_entries).to be >= 1
	@needed_entries = []
	(1..grid_entries).each do |i|
		if @ui.css(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(#{what_column})").text == what_value
			@needed_entries << i
		end
	end
	return @needed_entries
end

shared_examples "search for an Switch and perform an action" do |switch_sn, action|
  describe "Search the Access Points grid for the entry that has the Serial Number #{switch_sn} then perform the #{action}" do
    it "Ensure you are on the Switch tab" do
      go_to_tab_support_management("Switches")
      sleep 1
    end
    it "Search for the '#{switch_sn}' serial number" do
      @ui.set_input_val('.xc-search input', switch_sn)
      sleep 2
      if @ui.css('.btn-search').visible?
        @ui.click('.btn-search')
      end
      sleep 5
    end
    it "Verify the grid length should be 1 and the entry displayed should have the Serial Number value of #{switch_sn}" do
      sleep 2
      grid_entries = @ui.css('.nssg-table .nssg-tobdy')
      grid_entries.wait_until_present
      expect(grid_entries.trs.length).to eq(1)
      expect(@ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(3)").text).to eq(switch_sn)
      sleep 5
    end
    it "Search trough pages until the #{switch_sn} line is located" do
      if (action == "Command Line Interface")
        @ui.grid_action_on_specific_line("3", "div", switch_sn, "cli")
      elsif (action == "Delete")
        @ui.grid_tick_on_specific_line("3", switch_sn, "div")
      end
    end
    it "Perform the action: #{action}" do
      if (action == "Command Line Interface")
        if (@ui.css('.tab_contents .switch-details-cli-agreement').exists?)
          sleep 1
          @ui.click('.switch-details-cli-agreement-btn')
        end
      elsif (action == "Delete")
        sleep 1
        @ui.click('#backoffice_arrays_delete_btn')
      end
    end
    it "If the action is: 'Command Line Interface' - send a command and verify it is properly displayed /// If the action is 'Delete' - verify that the AP is deleted" do
      if (action == "Command Line Interface")
        if @ui.css('.slideout_title .online_status').text == 'Offline'
                expect(@ui.css('#profile_switches_details_slideout .tab_contents .nodata span').text).to eq('Switch Commands are unavailable because this Switch is offline.')
              else
          cli = @ui.get(:textarea, {id: 'switch-details-cli-commands-input'})
              cli.wait_until_present
              cli.send_keys 'show system information'
              #cli.send_keys :enter
              #cli.send_keys 'iaps'
          sleep 1
          @ui.click('#switch-details-cli-submit')
          sleep 5
          resp = @ui.get(:textarea, { css: '.switch-details-cli-results' })
                resp.wait_until_present
              expect(resp.value).to include(switch_sn)
            end
      elsif (action == "Delete")
        sleep 1
        @ui.css('#_jq_dlg_btn_1').hover
        sleep 1
        @ui.click('#_jq_dlg_btn_1')
        sleep 5
        @ui.click('.nssg-refresh')
        sleep 2
      end
      if (@ui.css('#profile_switches_details_slideout').visible?)
        @ui.click('#switchdetails_close_btn')
      end
    end
    if action == "Delete"
      it "Search for the '#{switch_sn}' serial number and verify the grid length should be 0 and no entry displayed" do
        @browser.refresh
        @ui.css('.xc-search').wait_until_present
        @ui.set_input_val('.xc-search input', switch_sn)
        sleep 2
        if @ui.css('.btn-search').visible?
          @ui.click('.btn-search')
        end
        sleep 5
        expect(@ui.css('.nssg-table .nssg-tobdy')).not_to be_visible
        expect(@ui.css('#backoffice_arrays xc-grid')).to be_visible
        sleep 2
        @ui.click('.btn-clear')
        sleep 5
      end
    end
  end
end