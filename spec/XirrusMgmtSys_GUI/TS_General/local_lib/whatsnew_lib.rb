shared_examples "Test what's new" do
  describe "Test what's new" do
    whats_new_url = ""
    
    it "click on what's new and verify url" do
      @ui.click('#header_nav_user_firstname')
      sleep 1
      @ui.click('#header_news_link')
      sleep 1
      @browser.window(:url => /https:\/\/www.riverbed.com\//).wait_until_present
      @browser.window(:url => /https:\/\/www.riverbed.com\//).use do
        expect(@browser.url).to eq("https://www.riverbed.com/products/xirrus/xirrus-management-system-cloud.html")
      end
    end
  end
end