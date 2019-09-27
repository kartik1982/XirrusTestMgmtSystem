require_relative "./local_lib/whatsnew_lib.rb"
#################################################################################
##############TEST CASE: Test what's new URL#####################################
#################################################################################
describe "Test what's new URL" do
  before :all do
   news_load = {
      url: "https://www.riverbed.com/products/xirrus/xirrus-management-system-cloud.html",
      message: "Automation Test Message for Waht's New",
      brand: "XIRRUS"
    }
   @api.post_set_whats_new_url_and_message(news_load) 
   response = @api.get_reset_news_all_users  
   expect(JSON.parse(response.body)).to eq("Reset What's New read flag for all Users") 
  end
  include_examples "Test what's new"
end