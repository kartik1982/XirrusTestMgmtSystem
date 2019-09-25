require_relative "../../TS_MSP/local_lib/msp_lib.rb"

shared_examples "go to groups tab" do # Created on : 25/04/2017
	describe "Go to the Groups tab" do
		it "Ensure that the navigation to the Groups tab of My Network functions properly" do
			@ui.click('#header_mynetwork_link') and sleep 1
			Watir::Wait.until { @browser.url.include? "#mynetwork/overview" }
			@ui.css('#mynetwork_tab_arrays').wait_until_present and @ui.click('#mynetwork_tab_arrays')
			sleep 2
			until @browser.url.include?("/#mynetwork/aps") do sleep 1 end
			@ui.css('#profile_config_tab_groups').wait_until_present and @ui.click('#profile_config_tab_groups')
			sleep 2
			until @browser.url.include?("/#mynetwork/aps/groups") do sleep 1 end
			@ui.css('#mynetwork-arrays-groups-new-btn').wait_until_present
		end
		it "Set the view type to 'grid' (if needed)" do
			if @ui.css('#mynetwork-arrays-groups xc-tile-grid').exists?
				@ui.click('#mynetwork-arrays-groups .tile-grid-bar .toggle-view') and sleep 2
			end
			expect(@ui.css('#mynetwork-arrays-groups .arrays-tile-grid')).not_to exist
			expect(@ui.css('#mynetwork-arrays-groups xc-grid')).to exist
		end
	end
end

shared_examples "simple navigation go to sub tab" do |sub_tab|
	describe "Simply go to the sub-tab named '#{sub_tab}' (no refresh or area change)" do
		if sub_tab == "Access Points"
			it "Go to the Access Points tab" do
				@ui.css('#profile_config_tab_aps').wait_until_present and @ui.click('#profile_config_tab_aps') and sleep 3
				until @browser.url.include?("/#mynetwork/aps/aps") do sleep 1 end
			end
		elsif sub_tab == "Groups"
			it "Go to the Groups tab" do
				@ui.css('#profile_config_tab_groups').wait_until_present and @ui.click('#profile_config_tab_groups') and sleep 1
				until @browser.url.include?("/#mynetwork/aps/groups") do sleep 1 end
			end
			it "Set the view type to 'grid' (if needed)" do
				if @ui.css('#mynetwork-arrays-groups xc-tile-grid').exists?
					@ui.click('#mynetwork-arrays-groups .tile-grid-bar .toggle-view') and sleep 2
				end
				expect(@ui.css('#mynetwork-arrays-groups .arrays-tile-grid')).not_to exist
				expect(@ui.css('#mynetwork-arrays-groups xc-grid')).to exist
			end
		end
	end
end

shared_examples "groups tab general features" do # Created on : 25/04/2017
	describe "Verify the general features on the groups tab of my network - view set to 'Grid'" do
		it "Verify all elements of the groups tab are properly displayed" do
			arrays_tab_css = '#mynetwork-arrays-groups'
			arrays_tab_table_header_css = arrays_tab_css + ' .nssg-container table thead'
			verify_elements_hash = Hash[arrays_tab_css + ' .commonTitle' => "Groups", arrays_tab_css + ' .commonSubtitle' => 'Manage your Groups.', 'columnpicker .blue' => true, arrays_tab_css + ' .xc-search .btn-search' => true, arrays_tab_css + ' .nssg-refresh' => true, "#mynetwork-arrays-groups-new-btn" => true, "#groups-export-btn" => false, arrays_tab_table_header_css + ' tr th:nth-child(3) .nssg-th-text' => "Group Name", arrays_tab_table_header_css + ' tr th:nth-child(4) .nssg-th-number' => "Access Point Count", arrays_tab_table_header_css + ' tr th:nth-child(5) .nssg-th-text' => "Description" , arrays_tab_table_header_css + ' tr th:nth-child(6) .nssg-th-text' => "Status", arrays_tab_table_header_css + ' tr th:nth-child(3)' => "nssg-sortable", arrays_tab_table_header_css + ' tr th:nth-child(4)' => "nssg-sortable", arrays_tab_table_header_css + ' tr th:nth-child(5)' => "nssg-sortable" , arrays_tab_css + ' .xc-search input' => true , arrays_tab_css + ' .xc-search input' => ["placeholder", "Search groups"], arrays_tab_table_header_css + ' tr th:nth-child(6)' => "nssg-sortable"]
			verify_elements_hash.keys.each do |key|
				if verify_elements_hash[key] == 'Groups' then expect(@ui.css(key).text).to include(verify_elements_hash[key])
				elsif verify_elements_hash[key] == "nssg-sortable" then expect(@ui.css(key).attribute_value("class")).to include(verify_elements_hash[key])
				elsif verify_elements_hash[key].class == Array then expect(@ui.css(key).attribute_value(verify_elements_hash[key][0])).to eq(verify_elements_hash[key][1])
				elsif [TrueClass, FalseClass].include? verify_elements_hash[key].class then expect(@ui.css(key).present?).to eq(verify_elements_hash[key])
				else expect(@ui.css(key).text).to eq(verify_elements_hash[key])
				end
			end
		end
	end
	it_behaves_like "change the view type", "Tile"
	describe "Verify the general features on the groups tab of my network - view set to 'Tile'" do
		it "Verify all elements of the groups tab are properly displayed" do
			arrays_tab_css = '#mynetwork-arrays-groups'
			verify_elements_hash = Hash[arrays_tab_css + ' .commonTitle' => "Groups", arrays_tab_css + ' .commonSubtitle' => 'Manage your Groups.', arrays_tab_css + ' .tile-grid-bar .xc-search .btn-search' => true, "#mynetwork-arrays-groups-new-btn" => true, "#groups-export-btn" => false, arrays_tab_css + ' .xc-search input' => true, arrays_tab_css + ' .xc-search input' => ["placeholder", "Search groups"]]
			verify_elements_hash.keys.each do |key|
				if verify_elements_hash[key] == 'Groups' then expect(@ui.css(key).text).to include(verify_elements_hash[key])
				elsif verify_elements_hash[key].class == Array then expect(@ui.css(key).attribute_value(verify_elements_hash[key][0])).to eq(verify_elements_hash[key][1])
				elsif [false, true].include? verify_elements_hash[key] then expect(@ui.css(key).present?).to eq(verify_elements_hash[key])
				else expect(@ui.css(key).text).to eq(verify_elements_hash[key])
				end
			end
		end
	end
	it_behaves_like "change the view type", "Grid"
end

def open_the_group_modal(what_modal) # Created on : 25/04/2017
	if what_modal == "New Group"
		it "Press the '+ NEW GROUP' button and wait for the modal to be loaded" do
			expect(@browser.url).to include('/#mynetwork/aps/groups')
			@ui.click('#mynetwork-arrays-groups-new-btn')
			exit_int = 0
			until @ui.css('#groups_newGroup').present? do
				sleep 1
				exit_int+=1
				if exit_int == 60
					expect(@ui.css('#groups_newGroup')).to be_present
				end
			end
		end
	else
	end
end

def dual_list_grids_action_using_included_string(modal_css, lhs_rhs, included_string, action) # Created on : 25/04/2017
	entries = @ui.css("#{modal_css} #{lhs_rhs} ul").lis
	puts entries
	puts entries.length
	found_entry = false
	entries.each do |entry|
		puts entry
		puts entry.text
		if entry.text.include?included_string
			found_entry = true
			if action == "click"
				entry.click
			end
			break
		end
	end
	expect(found_entry).to eq(true)
end

shared_examples "verify add new group edit group modal" do |what_modal, group_name, description, ap_count, close| # Created on : 25/04/2017
	describe "Verify the '#{what_modal}' modal's features" do
		if what_modal == "New Group"
			open_the_group_modal("New Group")
		else
			it "Open the 'Edit Group' modal for the group named '#{group_name}'" do
				exit_int = 0
				until @ui.css('#groups_newGroup').present? do
					sleep 1
					exit_int+=1
					if exit_int == 60
						expect(@ui.css('#groups_newGroup')).to be_present
					end
				end
			end
		end
		it "Verify the modal features" do
			group_modal_css = "#groups_newGroup"
			if what_modal == 'New Group' then modal_title = "New Group" else  modal_title = "Edit Group" end
			verify_elements_hash = Hash[group_modal_css + " .commonTitle" => modal_title, group_modal_css + ' .content .row:first-child span' => 'Group Name*', group_modal_css + ' .content .row:first-child input' => true, group_modal_css + ' .content .row:nth-child(2) span' => 'Description', group_modal_css + ' .content .row:nth-child(2) textarea' => true, '#dual_lists .lhs .lhs_top label' => "Access Points", '#dual_lists .lhs .lhs_top .search' => true,  '#dual_lists .lhs .select_list.scrollable' => true, '#column_selector_modal_moveall_btn' => "exist", '#column_selector_modal_move_btn' => "exist", '#dual_lists .rhs .select_list.scrollable' => true, '#newpgroup_cancel' => true, '#newpgroup_create' => true, '#groups_newGroup_closemodalbtn' => true]
			#XMSC-4763- Changing to profile instead of access points
			verify_elements_hash.keys.each do |key|
				if verify_elements_hash[key] == 'exist' then expect(@ui.css(key)).to exist
				elsif verify_elements_hash[key].class != String then expect(@ui.css(key).present?).to eq(verify_elements_hash[key])
				else expect(@ui.css(key).text).to eq(verify_elements_hash[key])
				end
			end
			if what_modal == "Edit Group"
				verify_elements_hash = Hash[group_modal_css + ' .content .row:first-child input' => group_name, group_modal_css + ' .content .row:nth-child(2) textarea' => description, '#dual_lists .rhs .rhs_top label' => group_name, '#dual_lists .rhs .select_list.scrollable ul' => ap_count]
				verify_elements_hash.keys.each do |key|
					if key.include? "input" then expect(@ui.get(:input , {css: key}).value).to eq(verify_elements_hash[key])
					elsif key.include? "textarea" then expect(@ui.get(:textarea , {css: key}).value).to eq(verify_elements_hash[key])
					elsif key.include? ".select_list.scrollable ul" then expect(@ui.css(key).lis.length.to_s).to eq(verify_elements_hash[key])
					else expect(@ui.css(key).text).to eq(verify_elements_hash[key])
					end
				end
			end
		end
		if close == true
			it "Close the modal" do
				@ui.click('#groups_newGroup_closemodalbtn')
				while @ui.css('#groups_newGroup').present? do sleep 1 end
			end
		end
	end
end

shared_examples "add a group" do |group_name, group_description, ap_or_aps| # Created on : 25/04/2017
	describe "Add a group named '#{group_name}' that has " do
		open_the_group_modal("New Group")
		it "Set the name to '#{group_name}'" do
			input_css = '#groups_newGroup .content .row:first-child input'
			@ui.set_input_val(input_css, group_name) and sleep 1
			@ui.click('#groups_newGroup .commonTitle') and sleep 1
			expect(@ui.get(:input , {css: input_css}).value).to eq(group_name)
			expect(@ui.css('#dual_lists .rhs .rhs_top label').text).to eq(group_name)
		end
		if group_description != ""
			it "Set the description to '#{group_description}'" do
				description_css = '#groups_newGroup .content .row:nth-child(2) textarea'
				@ui.set_textarea_val(description_css, group_description) and sleep 0.6
				@ui.click('#groups_newGroup .commonTitle') and sleep 0.6
				expect(@ui.get(:textarea , {css: description_css}).value).to eq(group_description)
			end
		end
		if ap_or_aps != ""
			it "Copy the following AP(s) to the group: '#{ap_or_aps}'" do
			  #Select Unassigned access point from dropdown
			  @ui.set_dropdown_entry_by_path("#dual_lists .lhs .search .ko_dropdownlist", "Unassigned Access Points")
			  sleep 4
				expect(@ui.css('#dual_lists .lhs .select_list ul').lis.length).to be >= 1
				if ap_or_aps.class == String
					if ap_or_aps == "Copy All"
						lhs_entries = @ui.css("#dual_lists .lhs ul").lis.length
						@ui.click('#dual_lists #column_selector_modal_moveall_btn') and sleep 2
						rhs_entries = @ui.css("#dual_lists .rhs ul").lis.length
						expect(lhs_entries).to eq(rhs_entries)
					else
						dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap_or_aps, "click") and sleep 1
						@ui.click('#dual_lists #column_selector_modal_move_btn') and sleep 1
						dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap_or_aps, "verify")
					end
				elsif ap_or_aps.class == Array
					skip_first_two_entrie_bool = false
					if ap_or_aps[0] == "Change Search"
						@ui.set_dropdown_entry_by_path("#dual_lists .lhs .search .ko_dropdownlist", ap_or_aps[1]) and sleep 4
						expect(@ui.css('#dual_lists .lhs .select_list ul').lis.length).to be > 0 and sleep 3
						skip_first_two_entrie_bool = true
					end
					ap_or_aps.each_with_index do |ap, i|
						if skip_first_two_entrie_bool == true
							if i >= 2
								dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "click") and sleep 1
								@ui.click('#dual_lists #column_selector_modal_move_btn') and sleep 2
								dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "verify")
							end
						else
							dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "click") and sleep 1
							@ui.click('#dual_lists #column_selector_modal_move_btn') and sleep 2
							dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "verify")
						end
					end
				end
			end
		end
		it "Press the 'APPLY' button" do
			@ui.click('#newpgroup_create')
			while @ui.css('#groups_newGroup').present? do sleep 1 end
		end
	end
end

shared_examples "from access point tab add remove certain aps to a certain group" do |group_name, add_remove, ap_or_aps, use_search| # Created on : 14/09/2017
	describe "FROM THE ACCESS POINT TAB - '#{add_remove}' certain aps (#{ap_or_aps}) to a certain group (#{group_name})" do
		if ap_or_aps != ""
			it "Select the following AP(s) to be moved: '#{ap_or_aps}'" do
				grid_length = @ui.css('.nssg-table tbody').trs.length
				expect(grid_length).to be >= 1
				if ap_or_aps.class == String
					if ap_or_aps == "Copy All"
						for i in 1..grid_length
							@ui.click("tbody tr:nth-child(#{i}) td:nth-child(2) input + .mac_chk_label") and sleep 1
						end
						expect(@ui.css('#arrays_grid .bubble .count').text).to eq(grid_length.to_s)
					else
						@ui.grid_action_on_specific_line(3, "a", ap_or_aps, "tick") and sleep 1
						expect(@ui.css('#arrays_grid .bubble .count').text).to eq("1")
					end
				elsif ap_or_aps.class == Array
					ap_or_aps.each do |ap|
						while @ui.css('#arrays_grid .nssg-paging-selector-container .nssg-paging-pages .text').text != "100" do @ui.set_paging_view_for_grid(".ko_dropdownlist_list.active ul", "100") and sleep 2 end
						@ui.grid_action_on_specific_line(3, "a", ap, "tick") and sleep 1
						if ap == ap_or_aps.last
							expect(@ui.css('#arrays_grid .bubble .count').text).to eq("#{ap_or_aps.size}")
						end
					end
				end
			end
		end
		if ap_or_aps != ""
			it "Open the 'Groups' dropdown window" do
				expect(@ui.css('.groups_button')).to be_present and sleep 1
				@ui.click('.groups_button .icon')
				until @ui.css('.groups_button .drop_menu_nav.active').exists? do sleep 1 end
			end
			it "Set the action to '#{add_remove}'" do
				if add_remove == "ADD"
					until @ui.css('.groups_button .drop_menu_nav .groups_add_remove_toggle .add.selected').exists? do @ui.click('.groups_button .drop_menu_nav .groups_add_remove_toggle .add') and sleep 1 end
				elsif add_remove == "REMOVE"
					until @ui.css('.groups_button .drop_menu_nav .groups_add_remove_toggle .remove.selected').exists? do @ui.click('.groups_button .drop_menu_nav .groups_add_remove_toggle .remove') and sleep 1 end
				end
			end
			it "Find the proper group (#{group_name}) and place a tick for it" do
				if use_search == true
					@ui.set_input_val('.groups_button .drop_menu_nav .xc-search input', group_name) and sleep 1
					while @ui.css('.groups_button .drop_menu_nav .buttons .orange.disabled').exists? do @ui.click(".groups_button .drop_menu_nav .items .item label") and sleep 1 end
					expect(@ui.get(:elements, {css: '.groups_button .drop_menu_nav .items label'}).size).to eq(1)
				else
					items_count = @ui.get(:elements, {css: '.groups_button .drop_menu_nav .items label'}).size
					for i in 1..items_count
						if @ui.css(".groups_button .drop_menu_nav .items .item:nth-child(#{i}) label").text == group_name
							while @ui.css('.groups_button .drop_menu_nav .buttons .orange.disabled').exists? do @ui.click(".groups_button .drop_menu_nav .items .item:nth-child(#{i}) label") and sleep 1 end
						end
					end
				end
			end
			it "Press the 'SUBMIT' button" do
				@ui.click('.groups_button .drop_menu_nav .buttons .orange') and sleep 2
			end
		end
	end
end

shared_examples "verify groups assign dropdown properly responds to changes on the groups tab" do # Created on : 14/09/2017
	describe "Verify that the 'Groups assign' dropdown properly responds when the user deletes all the Groups" do
		it "Verify the 'Groups assign' dropdown" do
			@ui.click("tbody tr:first-child td:nth-child(2) input + .mac_chk_label") and sleep 1
			expect(@ui.css('.groups_button')).to be_present and sleep 1
			@ui.click('.groups_button .icon')
			until @ui.css('.groups_button .drop_menu_nav.active').exists? do sleep 1 end
			expect(@ui.css('.groups_button .drop_menu_nav .items .item')).not_to exist
			@ui.click('.groups_button .drop_menu_nav .buttons button') and sleep 1
			while @ui.css('.groups_button .drop_menu_nav.active').exists? do sleep 1 end
		end
	end
end

def find_column_header_by_name(column_header_name) # Created on : 25/04/2017
	column_number = 0
	columns = @ui.css('#mynetwork-arrays-groups table thead:nth-child(2) tr').ths
	columns.each do |column|
		column_number+=1
		if column.element(:css => 'th .nssg-th-content .nssg-th-text').exists?
			if column.element(:css => 'th .nssg-th-content .nssg-th-text').text == column_header_name
				return column_number
			end
		end
	end
end

def specific_action_on_grid_entry(grid_entry_name, action, verify_values_hash) # Created on : 25/04/2017
	expect(@ui.css('#mynetwork-arrays-groups table tbody tr')).to exist
	grid_elements = @ui.css('#mynetwork-arrays-groups table tbody').trs
	column_number = find_column_header_by_name(grid_entry_name.keys[0])
	grid_elements.each do |grid_element|
		if grid_element.element(:css => "tr td:nth-child(#{column_number}) .nssg-td-text").text == grid_entry_name.values[0]
			case action
			when "verify values"
				verify_values_hash.keys.each do |key|
					new_column_number = find_column_header_by_name(key)
					if key == "Status"
						expect(grid_element.element(:css => "tr td:nth-child(#{new_column_number}) .nssg-td-text span:nth-child(2)").text).to eq(verify_values_hash[key])
					elsif key == "Access Point Count"
						# expect(grid_element.element(:css => "tr td:nth-child(#{new_column_number}) div").text).to eq(verify_values_hash[key])
					else
						expect(grid_element.element(:css => "tr td:nth-child(#{new_column_number}) .nssg-td-text").text).to eq(verify_values_hash[key])
					end
				end
			when "edit line"
				grid_element.element(:css => "tr td:nth-child(#{column_number}) .nssg-td-text").click
				grid_element.element(:css => "tr td:nth-child(#{column_number}) .nssg-td-text").hover
				expect(grid_element.element(:css => "tr .nssg-td-actions .nssg-actions-container")).to be_present
				grid_element.element(:css => "tr .nssg-td-actions .nssg-actions-container .nssg-action-edit").click
			when "delete line"
				grid_element.element(:css => "tr td:nth-child(#{column_number}) .nssg-td-text").click
				grid_element.element(:css => "tr td:nth-child(#{column_number}) .nssg-td-text").hover
				expect(grid_element.element(:css => "tr .nssg-td-actions .nssg-actions-container")).to be_present
				grid_element.element(:css => "tr .nssg-td-actions .nssg-actions-container .nssg-action-delete").click
			end
		end
	end
end

shared_examples "verify group" do |group_name, verify_values_hash| # Created on : 25/04/2017
	describe "Verify the group named '#{group_name}' in the grid" do
		it "Find the entry in the grid and verify all values" do
			specific_action_on_grid_entry(Hash["Group Name" => group_name], "verify values", verify_values_hash)
		end
	end
	describe "Verify the group named '#{group_name}' in the edit group modal" do
		it "Open the edit group modal for the group" do
			specific_action_on_grid_entry(Hash["Group Name" => group_name], "edit line", verify_values_hash)
		end
	end
	it_behaves_like "verify add new group edit group modal", "Edit Group", group_name, verify_values_hash["Description"], verify_values_hash["Access Point Count"], true
end

shared_examples "edit group" do |location, group_name, edit_values_hash| # Created on : 26/04/2017
	describe "Edit the group named '#{group_name}' using the edit group modal" do
		if location == "Grid view"
			it "Open the edit group modal for the group" do
				specific_action_on_grid_entry(Hash["Group Name" => group_name], "edit line", "")
			end
		elsif location == "Tile view"
			it "Search for the domain named '#{group_name}' in the dashboard grid and open it" do
	            @browser.refresh
	            sleep 4
	            tiles = @ui.get(:elements , {css: 'xc-tile-grid xc-tile-container .tile'}).length
	            while tiles > 0
	                string = "xc-tile-grid xc-tile-container xc-tile:nth-child(#{tiles})"
	                puts string
	                if @ui.css(string + " .tile").attribute_value("title") == group_name
	                    @ui.click(string + " .tile")
	                    sleep 2
	                    expect(@ui.css('.koProgrammaticPopupContent')).to be_visible
	                    break
	                end
	                tiles-= 1
	            end
            end
            it "Open the edit view modal" do
            	@ui.click('.koProgrammaticPopupContent .content .links li:nth-child(3) a')
            	sleep 2
            end
		end
		it "Change the following values for the group '#{edit_values_hash}'" do
			edit_values_hash.keys.each do |key|
				if edit_values_hash[key] != nil
					case key
					when "Group Name"
						input_css = '#groups_newGroup .content .row:first-child input'
						@ui.set_input_val(input_css, edit_values_hash[key]) and sleep 1
						@ui.click('#groups_newGroup .commonTitle') and sleep 1
						expect(@ui.get(:input , {css: input_css}).value).to eq(edit_values_hash[key])
						expect(@ui.css('#dual_lists .rhs .rhs_top label').text).to eq(edit_values_hash[key])
					when "Group Description"
						description_css = '#groups_newGroup .content .row:nth-child(2) textarea'
						@ui.set_textarea_val(description_css, edit_values_hash[key]) and sleep 0.6
						@ui.click('#groups_newGroup .commonTitle') and sleep 0.6
						expect(@ui.get(:textarea , {css: description_css}).value).to eq(edit_values_hash[key])
					when "Group AP(s)"
					  #Select Unassigned access point from dropdown
            @ui.set_dropdown_entry_by_path("#dual_lists .lhs .search .ko_dropdownlist", "Unassigned Access Points")
            sleep 2
						already_added_aps = @ui.css('#dual_lists #rhs_selector ul').lis
						if already_added_aps.length > 0
							already_added_aps.each do |ap|
								if !edit_values_hash[key].include? ap.text
									ap.click and sleep 2
									expect(ap.attribute_value("class")).to eq('selected')
									@ui.click('#dual_lists #column_selector_modal_remove_btn') and sleep 2
								end
							end
						end
						if edit_values_hash[key] != [""]
							skip_first_two_entrie_bool = false
							if edit_values_hash[key][0] == "Change Search"
								@ui.set_dropdown_entry_by_path("#dual_lists .lhs .search .ko_dropdownlist", edit_values_hash[key][1])
								sleep 4
								expect(@ui.css('#dual_lists .lhs .select_list ul').lis.length).to be > 0
								skip_first_two_entrie_bool = true
							end
							edit_values_hash[key].each_with_index do |ap, i|
								if skip_first_two_entrie_bool == true
									if i >= 2
										dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "click") and sleep 1
										@ui.click('#dual_lists #column_selector_modal_move_btn') and sleep 2
										dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "verify")
									end
								else
									dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "click") and sleep 1
									@ui.click('#dual_lists #column_selector_modal_move_btn') and sleep 2
									dual_list_grids_action_using_included_string("#dual_lists", ".lhs", ap, "verify")
								end
							end
						end
					end
				end
			end
		end
		it "Press the 'APPLY' button" do
			@ui.click('#newpgroup_create')
			while @ui.css('#groups_newGroup').present? do sleep 1 end
		end
	end
end

shared_examples "delete all groups from the grid" do # Created on : 25/04/2017
	describe "Delete all Groups from the grid using the 'All Grid Entries' checkbox" do
		it "Click the 'All Grid Entries' checkbox" do
			@@groups_in_grid = @ui.css('#mynetwork-arrays-groups table tbody').trs.length
			if @@groups_in_grid > 1
				groups_in_grid_text = @@groups_in_grid.to_s + "\nGroups Selected"
			else
				groups_in_grid_text = @@groups_in_grid.to_s + "\nGroup Selected"
			end
			if @@groups_in_grid != 0
				@ui.click('#mynetwork-arrays-groups table thead tr th:nth-child(2) input + .mac_chk_label') and sleep 2
				expect(@ui.css('#mynetwork-arrays-groups .xc-grid-selection-bubble').text).to eq(groups_in_grid_text)
			end
		end
		it "Click the 'Delete' button and verify that the 'Delete Group(s)?' modal is displayed" do
			puts @@groups_in_grid
			if @@groups_in_grid != 0
				expect(@ui.css('#mynetwork-arrays-groups-delete')).to be_present
				until @ui.css('.dialogOverlay.confirm').present?
					@ui.click('#mynetwork-arrays-groups-delete')
					sleep 2
				end
				sleep 1
				if @@groups_in_grid > 1
					expect(@ui.css('.dialogOverlay.confirm .title span').text).to eq('Delete Groups?') and expect(@ui.css('.dialogOverlay.confirm .msgbody div').text).to eq('Are you sure you want to delete the selected groups?')
				else
					expect(@ui.css('.dialogOverlay.confirm .title span').text).to eq('Delete Group?') and expect(@ui.css('.dialogOverlay.confirm .msgbody div').text).to eq('Are you sure you want to delete the selected group?')
				end
				@ui.click('#_jq_dlg_btn_1') and sleep 1
				expect(@ui.css('.temperror')).not_to be_present
			end
		end
		it "Verify all entries are properly removed from the grid" do
			expect(@ui.css('#mynetwork-arrays-groups table tbody').trs.length).to eq(0)
		end
	end
end

# US 5126 - AP Groups | Drill-down into groups
shared_examples "change the view type" do |view_type| # Created on 22/08/2017
	describe "Change the Groups sub-tab view to '#{view_type}'" do
		if view_type == "Tile"
			it "If needed change the view type to 'tile'" do
				if @ui.css('#mynetwork-arrays-groups xc-grid').exists?
					@ui.click('#mynetwork-arrays-groups xc-grid .toggle-view') and sleep 2
				end
				expect(@ui.css('#mynetwork-arrays-groups .arrays-tile-grid')).to exist
				expect(@ui.css('#mynetwork-arrays-groups xc-grid')).not_to exist
			end
		elsif view_type == "Grid"
			it "If needed change the view type to 'grid'" do
				if @ui.css('#mynetwork-arrays-groups xc-tile-grid').exists?
					@ui.click('#mynetwork-arrays-groups .tile-grid-bar .toggle-view') and sleep 2
				end
				expect(@ui.css('#mynetwork-arrays-groups .arrays-tile-grid')).not_to exist
				expect(@ui.css('#mynetwork-arrays-groups xc-grid')).to exist
			end
		end
		it "Verify no error message is displayed" do
			3.times do
				sleep 0.5
				expect(@ui.css('.error')).not_to exist
				expect(@ui.css('.temperror')).not_to exist
			end
		end
	end
end

shared_examples "verify group tile elements" do |group_name, status, reason, warning_message| # Created on 16/08/2017
	it_behaves_like "change the view type", "Tile"
	describe "Verify the Group named '#{group_name}' and it's tile elements" do
		search_for_tile_name_and_verify_status_and_reason(group_name, status, reason, warning_message)
	end
end

shared_examples "verify access points tab filter value" do |value| # Created on 21/08/2017
	describe "Go to the Access Points tab and verify the AP filter dropdown value" do
		it "Go to the Access Points tab" do
			@ui.click('#profile_config_tab_aps')
			sleep 3
			expect(@browser.url).to include('/#mynetwork/aps/aps')
		end
		it "Verify the AP filter dropdown value" do
			expect(@ui.css('#mynetwork-aps-filter .text').text).to eq(value)
		end
		if value != "All Devices"
			it "Verify that the AP main tab shows the filtered icon" do
				expect(@ui.css('#mynetwork_tab_arrays').attribute_value("class")).to include("filtered")
			end
		else
			it "Verify that the AP main tab does not show the filtered icon" do
				expect(@ui.css('#mynetwork_tab_arrays').attribute_value("class")).not_to include("filtered")
			end
		end
	end
end

shared_examples "verify access points and groups columns" do # Created on 22/08/2017
	describe "Verify the Access Points sub-tabs' available columns" do
		it "Go to the Access Points tab" do
			@ui.click('#profile_config_tab_aps')
			sleep 3
			expect(@browser.url).to include('/#mynetwork/aps/aps')
		end
	end
	it_behaves_like "go to groups tab"
	describe "Verify the Groups sub-tabs' grid columns" do
	end
end

def search_for_group_depending_on_view_type(view_type, searched_item, expected_results_count)
	if view_type == "Grid"
 		grid = @ui.css('.nssg-table tbody')
 		if expected_results_count == 0
 			expect(grid).not_to be_present
 		else
   	grid.wait_until_present
   	expect(grid.trs.length).to eq(expected_results_count)
   	expected_results_count.times do |i|
   		if i != 0
    		cell = @ui.css(".nssg-table tbody tr:nth-child(#{i}) td:nth-child(3) div")
	    	cell.wait_until_present
	    	expect(cell.title).to include(searched_item)
	    end
   	end
   end
   #expect(@ui.css('.xc-search .bubble .count').text).to eq(expected_results_count.to_s)
  elsif view_type == "Tile"
  	tiles = @ui.css('xc-tile-container')
  	if expected_results_count == 0
 			expect(tiles.element(css: 'xc-tile')).not_to exist
 		else
   	tiles.wait_until_present
   	#expect(tiles.elements(css: "xc-tile").length).to eq(expected_results_count)
   	expected_results_count.times do |i|
   		if i != 0
    		tile = @ui.css("xc-tile-container xc-tile:nth-child(#{i}) .content .fullname")
	    	tile.wait_until_present
	    	expect(tile.span.text).to include(searched_item)
	    end
   	end
   end
   #expect(@ui.css('.xc-search .bubble')).to be_present
  end
  if expected_results_count == 0
  	expect(@ui.css('#mynetwork-arrays-groups .commonTitle').text).to eq("No results found")
  else
  	expect(@ui.css('#mynetwork-arrays-groups .commonTitle').text).to eq("Search results (#{expected_results_count})")
  end
end

shared_examples "verify groups search" do |view_type, searched_item, expected_results_count, change_view_before_finish| # Created on 22/09/2017
	describe "Verify the 'Search' properly works on the Groups area set to '#{view_type}' view" do
		it "Verify searching for '#{searched_item}' shows '#{expected_results_count}' results" do
			@ui.set_input_val('.xc-search input', searched_item)
    	sleep 2
    	search_for_group_depending_on_view_type(view_type, searched_item, expected_results_count)
	  end
	end
	if change_view_before_finish == true
		if view_type == "Grid"
			describe "Change the view for the search accordingly" do
				it "Set the view to 'Tile'" do
					@@new_view_type = "Tile"
				end
			end
			it_behaves_like "change the view type", "Tile"
		elsif view_type == "Tile"
			describe "Change the view for the search accordingly" do
				it "Set the view to 'Grid'" do
					@@new_view_type = "Grid"
				end
			end
			it_behaves_like "change the view type", "Grid"
		end
		describe "Verify that the search criteria is persisted" do
			it "Verify that the search elements are properly kept" do
				expect(@ui.get(:input , {css: '.xc-search input'}).value).to eq(searched_item)
				search_for_group_depending_on_view_type(@@new_view_type, searched_item, expected_results_count)
			end
		end
	else
		describe "Close the search" do
			it "Close the search" do
	    	sleep 1
	    	@ui.click('.btn-clear')
    	end
    end
	end
	describe "Verify the remaining entries" do
		it "Verify the available list contains more (or equal) results than '#{expected_results_count}'" do
			if change_view_before_finish == false
				puts "SCHIMBAM???"
				@@new_view_type = view_type
			end
			puts "NEW VIEW TYPE = #{@@new_view_type}"
			if @@new_view_type == "Grid"
	    	sleep 2
	    	grid = @ui.css('.nssg-table tbody')
	    	if grid.exists?
	    		expect(grid.trs.length).to be >= expected_results_count
	    	end
	    elsif @@new_view_type == "Tile"
	    	sleep 2
	    	tiles = @ui.css('xc-tile-container')
	     	if tiles.exist?
		   		expect(tiles.elements(css: "xc-tile").length).to be >= expected_results_count
		   	end
	    end
		end
	end
end

shared_examples "verify add button properly disbled" do
	describe "Verify that the 'ADD' group button is properly disabled" do
		it "Verify the 'ADD' group button" do
			expect(@ui.css('#mynetwork-arrays-groups-new-btn')).to be_present
			expect(@ui.css('#mynetwork-arrays-groups-new-btn').attribute_value("disabled")).to eq("true")
			# expect{@ui.click('#mynetwork-arrays-groups-new-btn')}.to raise_error(Watir::Exception::ObjectDisabledException)
			@ui.css('#mynetwork-arrays-groups-new-btn').hover
			sleep 1
			expect(@ui.css('.ko_tooltip .ko_tooltip_content').text).to eq("You have reached the maximum number of groups. Remove existing group(s) to create an additional group.")
		end
	end
end