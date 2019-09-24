shared_examples "verify domain admin general features" do
	describe "Verify the general features of the application using a domain administrator" do
		it "Verify that the report menu does not appear on the parent tenant" do
			@ui.css('#main_content_wrapper').wait_until_present
			sleep 1
			@ui.css('#header_nav_profiles').wait_until_present
			sleep 1
			expect(@ui.css('#header_nav_reports')).not_to be_visible
		end
		it "(Domain Admin account on Parent Tenant) Verify that the 'Command Center' option is visible and navigates to the proper place" do
			expect(@ui.css('#header_mynetwork_link').text).to eq("COMMANDCENTER")
			@ui.click('#header_nav_user .user-icon')
			@ui.css('#header_nav_user .profile_nav').wait_until_present
			expect(@ui.css('#header_msp_link').text).to eq('CommandCenter')
			@ui.click('#header_msp_link')
			@ui.css('#msp_tab_dashboard').wait_until_present
			expect(@browser.url).to include('/#msp/dashboard')
		end
	end
end

shared_examples "verify commandcenter entry not available" do
	describe "Verify that the CommandCenter entry is not available for Domain Administrators assigned only to CHILD TENANTS" do
		it "(Domain Admin account on Child Tenant) Verify that the 'Command Center' option is not visible" do
			expect(@ui.css('#header_mynetwork_link').text).not_to eq("COMMANDCENTER")
			expect(@ui.css('#header_mynetwork_link').text).to eq("MY NETWORK")
			@ui.click('#header_nav_user .user-icon')
			@ui.css('#header_nav_user .profile_nav').wait_until_present
			expect(@ui.css('#header_msp_link')).not_to exist
		end
	end
end