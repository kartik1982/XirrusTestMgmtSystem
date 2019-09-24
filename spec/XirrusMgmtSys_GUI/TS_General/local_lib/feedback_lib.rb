require_relative "../../TS_Help_Links/local_lib/helplinks_lib.rb"

def find_new_tab_and_verify_contact_support
  sleep 2
  @browser.window(:url => /cambiumnetworks.com\/support\/contact-support/) do
    expect(@browser.url).to include("cambiumnetworks.com")
    @browser.window(:url => /cambiumnetworks.com\/support\/contact-support/).close
  end   
end

shared_examples "test support request to riverbed" do
  describe "Test the Support Request url to riverbed" do
    it "Open the suggestion box container, choose Support Request" do
        @browser.execute_script('$("#suggestion_box").show()')
        sleep 1
        if !@ui.css('.suggestionTitle').visible?
          @ui.css('#header_nav_user_firstname').click
          sleep 0.5
          @ui.css('#header_suggestion_box').click
          sleep 0.5
          @ui.css('#suggestion_box .suggestionTitle').click
        end
        @ui.click('#suggestion_box .suggestionTitle')
        sleep 1
        @ui.click('#suggestion_box .suggestion_types xc-big-icon-button:nth-child(1)')
        sleep 1
        find_new_tab_and_verify_contact_support
    end
  end
end

shared_examples "test support request" do |name, phone, text|
  describe "Test the Support Request area" do
    it "Open the suggestion box container, choose Support Request and set the following values: '#{name}', '#{phone}' and '#{text}'" do
        @browser.execute_script('$("#suggestion_box").show()')
        @ui.click('#suggestion_box .suggestionTitle')
        sleep 1
        @ui.click('#suggestion_box .suggestion_types xc-big-icon-button:nth-child(1)')
        sleep 1
        @ui.set_input_val('#suggestion_box .suggestionContent .support.content input:nth-of-type(1)',name)
        @ui.set_input_val('#suggestion_box .suggestionContent .support.content input:nth-of-type(2)',phone)
        @ui.set_textarea_val('#suggestion_box .suggestionContent .support.content textarea',text)
        @ui.click('#suggestion_box .support.content .button')
        sleep 1
        expect(@ui.css('#suggestion_box .suggestionContainer .overlay')).to be_visible
        expect(@ui.css('#suggestion_box .suggestionContainer .overlay .data .subtitle').text).to include('Thank you for reporting your issue.')
        @ui.click('.suggestionOverlay')
        sleep 1
    end
    it "Verify that the 'chat with Support ...' link is removed" do # US 5211 - 8.28 Enhancements - Removing the support link
        @browser.execute_script('$("#suggestion_box").show()')
        @ui.click('#suggestion_box .suggestionTitle')
        sleep 1
        @ui.click('#suggestion_box .suggestion_types xc-big-icon-button:nth-child(1)')
        sleep 1
        expect(@ui.css('.chatlink').present?).to eql(false)
        sleep 0.5
        @ui.click('.suggestionOverlay')
        sleep 1
    end
  end
end

shared_examples "test feedback" do
  describe "Test the Feedback area" do
    it "Open the suggestion box container, choose Feedback and set the following value: ''Some feedback''" do
        @ui.click('#suggestion_box .suggestionTitle')
        sleep 1
        @ui.click('#suggestion_box .suggestion_types xc-big-icon-button:nth-child(2)')
        sleep 1
        @ui.set_textarea_val('#suggestion_box .suggestionContent .feedback.content textarea','Some feedback')
        @ui.click('#suggestion_box .feedback.content .button')
        sleep 1
        expect(@ui.css('#suggestion_box .suggestionContainer .overlay')).to be_visible
        expect(['Thanks for your feedback!', "Thank you!", "Thanks for your feedback!\nIf the idea is of interest, a member of the Xirrus team may elect to reach out to you personally to discuss further!"]).to include(@ui.css('#suggestion_box .suggestionContainer .overlay .data .subtitle').text)
        #expect(@ui.css('#suggestion_box .suggestionContainer .overlay .data .subtitle').text).to include('Thanks for your feedback!')
        @ui.click('.suggestionOverlay')
        sleep 1
    end
  end
end