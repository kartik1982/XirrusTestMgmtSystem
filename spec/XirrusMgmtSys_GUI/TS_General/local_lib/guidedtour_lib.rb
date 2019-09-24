require_relative "../../TS_Profile/local_lib/profile_lib.rb"
shared_examples "run guided tour" do |profile_name, profile_description|
  describe "Running a guided tour" do
    it "Open the profile dropdown list and press the Start Guided Tour button -> ensure that the tour step is My Network" do
      sleep 2
      if @ui.css('#header_mynetwork_link').exists?
        @ui.click('#header_mynetwork_link')
      end
      sleep 2
      @ui.click('#header_nav_user')
      sleep 1
      @ui.click('#header_start_tour')
      sleep 1

      expect(@ui.id('tour_bubble_wrapper')).to be_visible
      sleep 2
      expect(@browser.url).to include("mynetwork/overview/")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(1)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is on the Profiles landing page" do
      @ui.click('#tour_next')
      sleep 1
      expect(@browser.url).to include("profiles")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(2)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure it shows the user how to create a new Profile" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_next').text).to eq("HELP ME CREATE A PROFILE")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(3)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is on the New Profile form" do
      sleep 2
      @ui.click('#tour_next')
      sleep 5

      @ui.set_input_val('#profile_name_input', profile_name)
      @ui.set_textarea_val('#guestprofile_new_description_input', profile_description)

      @ui.click('#newprofile_create')
      sleep 6

      expect(@browser.url).to include("config/general")
      expect(@ui.get(:text_field, {id: "profile_config_basic_profilename"}).value).to eq(profile_name)
      expect(@ui.get(:textarea, {id: "profile_config_basic_description"}).value).to eq(profile_description)
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(1)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - Ensure the user is on the General tab of his newly created profile" do
      @ui.click('#tour_next')
      sleep 1
      expect(@browser.url).to include("config/ssids")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(2)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is on the SSIDs tab" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_next').text).to eq("ADD A NEW SSID")

      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(3)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is shown how to add a SSID and cofigure it" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.css(".nssg-table").trs.length).to eq(2)

      @ui.set_input_val('#profile_ssids_grid_ssidName_inline_edit_0', 'ssid')

      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(4)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure that the user is taken to the network tab" do
      @ui.click('#tour_next')
      sleep 4
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(5)
      expect(@browser.url).to include("config/network")
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure that the user is taken to the policies tab" do
      @ui.click('#tour_next')
      sleep 4
      expect(@browser.url).to include("config/policies")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(6)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is taken to the Policies tab and showed how to add a policy" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(7)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is taken to the Bonjour tab" do
      @ui.click('#tour_next')
      sleep 1
      expect(@browser.url).to include("config/bonjour")
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(8)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is showed how to use the Bojour fowarding" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(9)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is taken to the Admin tab" do
      @ui.click('#tour_next')
      sleep 1
      expect(@browser.url).to include("config/admin")
      @ui.set_input_val("#profile_config_admin_email", "test@email.com")
      sleep 1
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(10)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure that the user is informed about the existance of additional tabs" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(11)
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure that the user is informed about how to save the progress" do
      @ui.click('#tour_next')
      sleep 1
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(12)

      # @ui.click('#profile_config_save_btn')
      press_profile_save_config_no_schedule
      sleep 1
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure that the user is taken to the Access Points tab" do
      @ui.click('#tour_next')
      sleep 4
      expect(@ui.id('tour_bubble_wrapper').divs(:css => '.dot.active').length).to eq(13)
      sleep 1
      sleep 2
    end
    it "Go to the next step in the Guided Tour - ensure the user is taken to the Profiles landing page" do
      @ui.click('#tour_next')
      sleep 1
      expect(@browser.url).to include("profiles")
      sleep 2
    end
    it "Ensure the user can end the Guided Tour" do
      tour_window = @ui.id('tour_bubble_wrapper')
      tour_window.wait_until_present

      @ui.click('#tour_next')
      sleep 1

      expect(tour_window.class_name).to eq("isExit left")

      sleep 8

      tour_window.wait_while_present
    end
  end
end

shared_examples "verify guided tour hidden for msp parent domain" do
  describe "Verify that a domain that is MSP PARENT does not have the Guidet Tour function" do
    it "Verify that the domain (and account) are MSP Parent related and that the 'Start Guided Tour' option is not displayed" do
      expect(@ui.css('#header_mynetwork_link').text).to eq("COMMANDCENTER")
      sleep 2
      @ui.click('#header_mynetwork_link')
      sleep 2
      @ui.click('#header_nav_user')
      sleep 1
      expect(@ui.css('#header_msp_link')).to be_present
      expect(@ui.css('#header_start_tour')).not_to be_present
      sleep 1
    end
  end
end