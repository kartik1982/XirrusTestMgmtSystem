shared_examples "verify max number of profiles reached" do
	describe "Verify that on XMS-Light tenants the max limit of profiles is '2'" do
		it "Go to the Profiles landing page" do
			@ui.click('#header_mynetwork_link')
			sleep 2
			@ui.click('#header_nav_profiles')
			sleep 2
			expect(@ui.css('#header_profiles_arrow .profile_nav')).to be_visible
			@ui.click('#view_all_nav_item .title')
			sleep 2
			expect(@browser.url).to include("#profiles")
		end
		it "Try to create a new profile" do
			@ui.click("#new_profile_btn")
			sleep 2
			expect(@ui.css('#profiles_newprofile')).to be_present
			@ui.set_input_val("#profile_name_input", "TEST VALUE")
			sleep 1
			@ui.click('#newprofile_create')
		end
		it "Verify that the application properly shows the error message and error text as 'You have reached the limit of available Profiles for this tenant. Please remove existing Profile(s) or upgrade your service to continue creating additional Profiles.'" do
			expect(@ui.css('.error .msgbody div').text).to eq("You have reached the limit of available Profiles for this tenant. Please remove existing Profile(s) or upgrade your service to continue creating additional Profiles.")
		end
		it "If the error prompt is still open, close it" do
			if @ui.css('.error .dialog-close').exists?
				if @ui.css('.error .dialog-close').visible?
					@ui.click('.error .dialog-close')
					sleep 2
				end
			end
		end
		it "Open the first profile and try to duplicate it and verify the error message" do
			@ui.click('.ko_container .tile:nth-child(1) .title')
			sleep 5
			@ui.click('#profile_menu_btn')
			sleep 3
			@browser.a(:text => 'Duplicate Profile').click
			@ui.css('.error').wait_until(&:present?)
			expect(@ui.css('.error .msgbody div').text).to eq("You have reached the limit of available Profiles for this tenant. Please remove existing Profile(s) or upgrade your service to continue creating additional Profiles.")
		end
	end
end

shared_examples "verify widget top applications drilldown disabled" do |widget_name, application_name|
	describe "Verify that on the XMS-Light tenant, the widget 'Top Applications (by Usage)' has the drilldown function disabled " do
		it "Find the widget named '#{widget_name}' then Search for '#{application_name}' (in any view) and click on it then verify that the drilldown is not opened" do
			@ui.click('#header_nav_mynetwork')
			sleep 3
			widget_string_path = find_widget_with_certain_name(widget_name, false, false)
			sleep 0.5
			application_name_string_path = find_application_on_widget_and_click_on_it(application_name, widget_string_path)
			sleep 1
			expect(application_name_string_path).not_to eq(nil)
			@ui.click(application_name_string_path)
			sleep 1
			@ui.click(application_name_string_path)
			sleep 2
			application_name_string_path = find_application_on_widget_and_click_on_it(application_name, widget_string_path)
			sleep 1
			expect(application_name_string_path).not_to eq(nil)
		end
	end
end