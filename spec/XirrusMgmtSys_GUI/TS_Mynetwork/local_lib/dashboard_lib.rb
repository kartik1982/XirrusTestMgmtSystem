shared_examples "verify overview tab has filtered icon" do
	describe "Focus on the 'Overview' tab and verify that it has the filtered icon" do
		it "The 'Overview' tab properly shows that it is filtered" do
			sleep 1
			tab = @ui.css("#mynetwork_tab_overview")
      		tab.wait_until_present
      		expect(tab.attribute_value("class")).to include("filtered")
      		sleep 1
		end
	end
end

shared_examples "verify overview tab does not have filtered icon" do
	describe "Focus on the 'Overview' tab and verify that it does not have the filtered icon" do
		it "The 'Overview' tab does not show that it is filtered" do
			sleep 1
			tab = @ui.css("#mynetwork_tab_overview")
      		tab.wait_until_present
      		expect(tab.attribute_value("class")).not_to include("filtered")
      		sleep 1
		end
	end
end

shared_examples "verify overview tab is filtered by profile" do |profile_name|
	describe "Focus on the 'Overview' tab and verify that it is filtered by the #{profile_name}" do
		it "The 'Overview' tab properly shows that it is filtered by the profile named #{profile_name}" do
			sleep 1
			tab = @ui.css("#mynetwork_overview_scopetoprofile .ko_dropdownlist_button")
      		tab.wait_until_present
      		expect(tab.attribute_value("text")).to eq(profile_name)
      		sleep 1
		end
	end
end

shared_examples "verify dashboard data" do |dashboard_id, first_value, green_value, blue_value|
	describe "Verify the data displayed for the #{dashboard_id} control" do
		it "verify access points dashboard data" do
			sleep 1
			@ui.css(dashboard_id).wait_until_present
			if @ui.css("#dashboard4 .grey").exists?
				colour = "grey"
			elsif @ui.css("#dashboard4 .orange").exists?
				colour = "orange"
			end
			first = @ui.css("#dashboard4 .#{colour} .value").text
			green = @ui.css("#dashboard4 .green .value").text
			blue = @ui.css("#dashboard4 .blue .value").text
      		expect(first).to eq(first_value)
      		expect(green).to eq(green_value)
      		expect(blue).to eq(blue_value)
      		sleep 1
		end
	end
end

shared_examples "change to a certain profile from dashboard" do |profile_name|
	describe "Set the dashboard filter to display the information related to the #{profile_name}" do
		before :all do
			sleep 1
			@ui.click('#header_mynetwork_link')
			sleep 1
		end
		it "Verify that the user is located on the 'My Network' / 'Dashboard' page" do
			sleep 2
			@browser.execute_script('$("#suggestion_box").hide()')
			sleep 1
			expect(@browser.url).to include("/#mynetwork/overview/")
		end
		it "Set the value #{profile_name} to the 'Filter to profile' dropdown list" do
			sleep 1
			@ui.set_dropdown_entry('mynetwork_overview_scopetoprofile', profile_name)
			sleep 1
		end
		it_behaves_like "verify overview tab has filtered icon"
		it_behaves_like "verify overview tab is filtered by profile", profile_name
		after :each do
			sleep 1
		end
	end
end