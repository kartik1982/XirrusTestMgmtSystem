def verify_troubleshooting_page_contents(commonTitle, commonSubtitle)
	expect(@ui.css(".globalTitle").text).to eq("Troubleshooting")
	expect(@ui.css(".tab-item-container .commonSubtitle").text).to eq(commonSubtitle)
	if commonSubtitle == "System Messages"
		expect(@ui.css(".tab-item-container .commonTitle").text).to include(commonTitle)
		expect(@ui.css(".xc-messages")).to be_present
	else
		expect(@ui.css(".tab-item-container .commonTitle").text).to eq(commonTitle)
		expect(@ui.css("#ts-al-export-btn")).to be_present
		expect(@ui.css('.xc-search')).to be_present
		expect(@ui.css('.nssg-refresh')).to be_present
		expect(@ui.css(".nssg-table")).to be_present
	end
	expect(@ui.css('.nssg-paging-selector-container')).to be_present
	expect(@ui.css('.nssg-paging-count')).to be_present
	expect(@ui.css('.nssg-paging-controls')).to be_present
	expect(@ui.css("#troubleshooting_tab_auditlog")).to be_present
	expect(@ui.css("#troubleshooting_tab_commandlinehistory")).to be_present
	expect(@ui.css("#troubleshooting_tab_messages")).to be_present
end

def on_specific_line_verify_all_details(line_number,date,action,details,tab)
	if @ui.css('.ko_dropdownlist.nssg-paging-pages .ko_dropdownlist_button .text').text != "10"
		@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
	end
	if tab == "Audit Trail"
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(1)').text).to eq("User")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').text).to eq("Time")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').text).to eq("Action")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(4)').text).to eq("Detail")
		if !@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class").include?("nssg-sorted-desc")
			while !@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class").include?("nssg-sorted-desc")
				@ui.click('.nssg-table .nssg-thead tr th:nth-child(2)')
				sleep 1
			end
		end
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class")).to include("nssg-sorted-desc")
		full_string = @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(4) .nssg-td-text").text
	elsif tab == "Command Line History"
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').text).to eq("User")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').text).to eq("Time")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(4)').text).to eq("Access Point")
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(5)').text).to eq("Command")
		if !@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').attribute_value("class").include?("nssg-sorted-desc")
			while !@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').attribute_value("class").include?("nssg-sorted-desc")
				@ui.click('.nssg-table .nssg-thead tr th:nth-child(3)')
				sleep 1
			end
		end
		expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').attribute_value("class")).to include("nssg-sorted-desc")
		full_string = @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(5) .nssg-td-text").text
	end
	puts "WHAT VALUE TO VERIFY STRING = " + full_string
	if full_string.include? ", "
		strings = full_string.split(", ")
		strings.each do |string|
			puts "STRING: #{string}"
			details_length = details.length - 1
			while details_length > -1
				if details[details_length].include?("FIND FROM PREVIOUS ASSIGN METHOD")
					puts "REDO DETAILS"
					details[details_length] = details[details_length].gsub("FIND FROM PREVIOUS ASSIGN METHOD", $added_first_access_point_sn)
				end
				puts "VALUE TO VERIFY WITH : #{details[details_length]}"
				if details[details_length].include?(string)
					expect(details[details_length]).to include(string)
					puts "Break -> #{details[details_length]}"
					break
				end
				details_length-=1
				if details_length == -1
					puts "Failed the test -> Detail (#{details[details_length]}) not found - '#{string}' !!!"
					expect(true).to eq(false)
				end
			end
		end
	else
		if details[0].include?("FIND FROM PREVIOUS ASSIGN METHOD")
			puts "REDO DETAILS"
			details[0] = details[0].gsub("FIND FROM PREVIOUS ASSIGN METHOD", $added_first_access_point_sn)
		end
		expect(full_string).to include(details[0])
	end
	if tab == "Audit Trail"
		expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(3) .nssg-td-text").attribute_value("title")).to eq(action)
		expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(2) .nssg-td-text").attribute_value("title")).to include(date)
	elsif tab == "Command Line History"
		expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(4) .nssg-td-text").attribute_value("title")).to eq(action)
		expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_number}) td:nth-child(3) .nssg-td-text").attribute_value("title")).to include(date)
	end
end

def search_for_correct_values_on_certain_line_in_grid(date,action,detail,line_position)
	@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
	expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(1)').text).to eq("User")
	expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').text).to eq("Time")
	expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(3)').text).to eq("Action")
	expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(4)').text).to eq("Detail")
	if !@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class").include?("nssg-sorted-desc")
		while !@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class").include?("nssg-sorted-desc")
			@ui.click('.nssg-table .nssg-thead tr th:nth-child(2)')
			sleep 1
		end
	end
	expect(@ui.css('.nssg-table .nssg-thead tr th:nth-child(2)').attribute_value("class")).to include("nssg-sorted-desc")
	grid_length = @ui.css('.nssg-table .nssg-tbody').trs.length
	found = false
	found_count = 0
	i = 1
	while i <= grid_length do
		if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(1) .nssg-td-text").text == @username
			if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(2) .nssg-td-text").text.include?(date)
				if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(3) .nssg-td-text").text == action
					if detail.length > 1
						if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text.include?(detail[0]) and @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text.include?(detail[1]) and @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text.include?(detail[2])
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(1) .nssg-td-text").text).to eq(@username)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(2) .nssg-td-text").text).to include(date)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(3) .nssg-td-text span:nth-child(2)").text).to eq(action)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text).to include(detail[0])
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text).to include(detail[1])
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text).to include(detail[2])
							found_count+=1
							found = true
							found_line_number = i
						end
					else
						if @ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text == detail[0]
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(1) .nssg-td-text").text).to eq(@username)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(2) .nssg-td-text").text).to include(date)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(3) .nssg-td-text span:nth-child(2)").text).to eq(action)
							expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{i}) td:nth-child(4) .nssg-td-text").text).to eq(detail[0])
							found_count+=1
							found = true
							found_line_number = i
						end
					end
				end
			end
		end
		if i == grid_length
			expect(found_count).to be <= 1
			if found != true
				puts "Entry not found -> Failing the test"
				if detail.length > 1
					expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_position}) td:nth-child(4) .nssg-td-text").text).to include(detail[0])
					expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_position}) td:nth-child(4) .nssg-td-text").text).to include(detail[1])
					expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_position}) td:nth-child(4) .nssg-td-text").text).to include(detail[2])
				else
					expect(@ui.css(".nssg-table .nssg-tbody tr:nth-child(#{line_position}) td:nth-child(4) .nssg-td-text").text).to eq(detail[0])
				end
				expect(found).not_to eq(false)
			end
		end
		i+=1
	end
	expect(found_line_number).to eq(line_position)
end

shared_examples "go to the troubleshooting area" do
	describe "Navigate to the Troubleshooting Area" do
		it "Open the User Dropdown list and select the button named 'Troubleshooting', then verify that the proper tab is displayed" do
			@ui.click('#header_nav_user .user-icon')
			sleep 1
			expect(@ui.css('#header_nav_user .profile_nav.drop_menu_nav.active')).to be_present
			@ui.click('#header_troubleshooting')
			proper_url = @ui.wait_while_browser_url_matches_certain_string("#troubleshooting/auditlog")
			expect(@browser.url).to include("/#troubleshooting/auditlog")
			expect(proper_url).to eq(true)
		end
	end
end

def get_all_entries_from_grid_on_certain_column(column_name)
	array_used = []
	grid_length = @ui.css(".nssg-tbody").trs.length
	(1..grid_length).each do |grid_length_position|
		cell_text = @ui.css(".nssg-tbody tr:nth-child(#{grid_length_position}) .#{column_name} .nssg-td-text").attribute_value("title")
		array_used.push(cell_text)
	end
	array_used.uniq!
	puts array_used.length
	return array_used
end

shared_examples "go to tab command line history" do
	describe "go to the tab command line history" do
		it "go to the tab" do
			@ui.click('#troubleshooting_tab_commandlinehistory')
			sleep 1
			@ui.css('.nssg-table').wait_until(&:present?)
			expect(@browser.url).to include("/#troubleshooting/commandlinehistory")
		end
	end
end

shared_examples "export audit trail" do |entries_count|
	it_behaves_like "go to the troubleshooting area"
	describe "Export the Audit Trail to .csv and verify the first '#{entries_count}' entries" do
		it "Get the first page of the grid's entries" do
			@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", entries_count)
			sleep 2
			@@user_name_array = get_all_entries_from_grid_on_certain_column("userName")
			@@user_action_array = get_all_entries_from_grid_on_certain_column("userOperation")
			@@user_detail_array = get_all_entries_from_grid_on_certain_column("affectedUiDomainObjects")
		end
		it "Export Audit Trail" do
	        @ui.click('#ts-al-export-btn')
	        sleep 20
	        fname = @download + "/AccessLogs-" + "All" + "-" + (Date.today.to_s) + ".csv"
	        file = File.open(fname, "r")
	        data = file.read
	        file.close
	        @@user_name_array.each do |user_name|
	        	expect(data.include?(user_name)).to eq(true)
	        end
	        @@user_action_array.each do |user_action|
	        	expect(data.include?(user_action)).to eq(true)
	        end
	        @@user_detail_array.each do |user_detail|
	        	expect(data.include?(user_detail)).to eq(true)
	        end
	        File.delete(@download +"/AccessLogs-" + "All" + "-" + (Date.today.to_s) + ".csv")
	        sleep 2
	        @ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
	    end
	end
end

shared_examples "search for certain audit trail detail" do |audit_detail, grid_entries_view, expected_displayed_entries, min_value, max_value, empty_search|
	describe "Search for the 'Audit Detail' named '#{audit_detail}' in the grid and verify the displayed elements" do
		it "Set the grid display view to '#{grid_entries_view}'" do
			@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", grid_entries_view)
			sleep 1
		end
		it "Search for the string '#{audit_detail}'" do
			@ui.set_input_val(".xc-search input", audit_detail)
			sleep 3
			expect(@ui.css('.xc-search .btn-search')).not_to be_visible
		end
		it "Verify that the grid now shows the proper entries" do
			if empty_search != true
				expect(@ui.css('.xc-search .bubble .count').text).not_to eq("0") # expect(@ui.css('.xc-search .bubble .count').text).to eq(expected_displayed_entries)
				user_detail_array = get_all_entries_from_grid_on_certain_column("affectedUiDomainObjects")
				expect(user_detail_array.length).to be_between(min_value, max_value)
			else
				expect(@ui.css('.xc-search .bubble .count').text).to eq("0")
				expect(@ui.css('.nssg-table tbody tr')).not_to exist
				expect(@ui.css('.noresults')).to be_present
				expect(@ui.css('.noresults').text).to eq("No results found")
			end
		end
		it "Cancel the search and set the grid display view to '10'" do
			if empty_search != true
				@ui.set_dropdown_entry_by_path(".ko_dropdownlist.nssg-paging-pages", "10")
			end
			sleep 3
			@ui.click('.xc-search .btn-clear')
			sleep 2
		end
	end
end

shared_examples "verify main features" do
	describe "Verify the Main Features of the 'Troubleshooting' area" do
		it "Verify Global Title, tab Titles, tab Subtitles and Navigation Tabs texts" do
			@ui.click("#troubleshooting_tab_auditlog")
			sleep 1
			verify_troubleshooting_page_contents("Audit Trail","System Activities Records")
			sleep 1
			@ui.click("#troubleshooting_tab_commandlinehistory")
			sleep 1
			verify_troubleshooting_page_contents("Command Line History","Manage and view recent command line history")
			sleep 1
			@ui.click("#troubleshooting_tab_messages")
			sleep 1
			verify_troubleshooting_page_contents("Messages","System Messages")
			sleep 1
		end
	end
end

def verify_grid(search_box, export_btn, refresh_btn, other_grid)
	if export_btn == true
		expect(@ui.css("#ts-al-export-btn")).to be_present
	end
	if search_box == true
		expect(@ui.css('.xc-search')).to be_present
	end
	if refresh_btn == true
		expect(@ui.css('.nssg-refresh')).to be_present
	end
	if other_grid != ""
		expect(@ui.css(other_grid)).to be_present
	else
		expect(@ui.css(".nssg-table")).to be_present
	end
	expect(@ui.css('.nssg-paging-selector-container')).to be_present
	expect(@ui.css('.nssg-paging-count')).to be_present
	expect(@ui.css('.nssg-paging-controls')).to be_present
end

shared_examples "verify grid pagination" do |search_box, export_btn, refresh_btn, other_grid, page_view|
	describe "Verify the pagination and navigation of the grid controls" do
		it "Expect the grid is displayed and all controls are visible" do
			verify_grid(search_box, export_btn, refresh_btn, other_grid)
		end
		it "Set the page view to '#{page_view}' (if only one page is displayed gradually decrease the view number) and change all pages" do
			@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", page_view)
			pages_total = @ui.css('.nssg-paging-total').text.tr("of ","").to_i
			if pages_total == 1
				page_view_array = ["100", "50", "10"]
				page_view_array.each do |page_view|
					@ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", page_view)
					pages_total = @ui.css('.nssg-paging-total').text.tr("of ","").to_i
					if pages_total != 1
						break
					end
				end
			end
			if pages_total != 1
				pages_total = pages_total-1
				pages_total.times do
					@ui.click('.nssg-paging-next')
					sleep 1
					if other_grid != ""
						@ui.css(other_grid).wait_until(&:present?)
					else
						@ui.css('.nssg-table tbody').wait_until(&:present?)
					end
					sleep 1
					if @ui.css('.error').exists?
						expect(@ui.css('.error .msgbody .div').text).to eq("This error message should not have been displayed!")
					end
					if @ui.css('.temperror').exists?
						expect(@ui.css('.temperror .msgbody .div').text).to eq("This error message should not have been displayed!")
					end
					if @ui.css('.loading').exists?
						@ui.css(".loading").wait_while_present
					end
				end
			end
			expect(@ui.get(:input, {css: '.nssg-paging-current'}).value.to_i).to eq(@ui.css('.nssg-paging-total').text.tr("of ","").to_i)
		end
	end
end

shared_examples "perform action verify audit trail" do |action, detail, line_position|
	describe "Perform the action '#{action}' and then verify that the 'Audit Trail' properly displays the correct entry" do
		it "Refresh the grid and search for the correct line '#{line_position}' and details <<<'#{detail}'>>> for the action <<<'#{action}'>>>" do
			@ui.click(".nssg-refresh")
			sleep 1
			date = DateTime.now.strftime('%-m/%-d/%Y') # - %H:%M %P"
			#search_for_correct_values_on_certain_line_in_grid(date,action,detail,line_position)
			on_specific_line_verify_all_details(line_position,date,action,detail,"Audit Trail")
		end
	end
end

shared_examples "perform action verify command line history" do |action, detail, line_position|
	describe "Run a CLI command and then verify that the 'Command Line History' properly displays the correct entry" do
		it "Refresh the grid and search for the correct line and details" do
			@ui.click(".nssg-refresh")
			sleep 1
			date = DateTime.now.strftime('%-m/%-d/%Y') #.strftime("%m/%d/%Y")
			on_specific_line_verify_all_details(line_position,date,action,detail,"Command Line History")
		end
	end
end

shared_examples "go to tab messages" do
	describe "Verify the Troubleshooting area, 'Messages' tab" do
		it "Go to the 'Messages' tab" do
			@ui.click("#troubleshooting_tab_messages")
			sleep 1
			verify_troubleshooting_page_contents("Messages","System Messages")
			sleep 1
		end
	end
end

shared_examples "verify troubleshooting messages tab" do #|a|
	it_behaves_like "go to the troubleshooting area"
	describe "Verify the Troubleshooting area, 'Messages' tab" do
		it "Go to the 'Messages' tab" do
			@ui.click("#troubleshooting_tab_messages")
			sleep 1
			verify_troubleshooting_page_contents("Messages","System Messages")
			sleep 1
		end
		it "Verify the XC-Messages grid contents" do
			expect(@ui.get(:elements , {css:'.xc-messages .xc-message'}).length).to be > 0
			string = ".xc-messages .xc-message:nth-child(1)"
			expect(@ui.css(string + " .xc-message-title").text).to include("XMS-Cloud System")
			# expect(@ui.css(string + " .xc-message-message").text).to include("maintenance")
			expect(@ui.css(string + " .xc-message-timestamps .xc-message-timestamp .label").text).to include("Posted:")
			expect(@ui.css(string + " div:nth-child(4) .xc-message-timestamp .label").text).to include("Expiry:")
		end
	end
end