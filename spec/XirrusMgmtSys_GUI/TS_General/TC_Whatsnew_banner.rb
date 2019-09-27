#################################################################################
##############TEST CASE: What's new banner behavior#############################
#################################################################################
describe "TEST CASE: What's new banner behavior" do
  new_user_email = "banner_test@testing.com"
  new_user_password = "pazzword"
  new_user_id = ""

  user_json = {
       "lastName": "banner_last",
       "phone": "111-222-3333",
       "tenantUsers": [ ],
       "status": "ACTIVE",
       "showWelcome": "false",
       "password": {
           "isSet": "true",
           "value": new_user_password
       },
       "email": new_user_email,
       "acceptedEula": "true",
       "description": "string",
       "roles": [
           "ROLE_XMS_ADMIN", "ROLE_BACKOFFICE_ADMIN"
       ],
       "forceResetPassword": "false",
       "firstName": "banner_first"
   }
   before :all do
     news_load = {
        url: "https://www.riverbed.com/products/xirrus/xirrus-management-system-cloud.html",
        message: "Automation Test Message for Waht's New",
        brand: "XIRRUS"
      }
     @api.post_set_whats_new_url_and_message(news_load)
   end
  
    it "created user with given password" do
        resp = @api.post_add_user(user_json)
        new_user_id = JSON.parse(resp.body)['id']
        expect(JSON.parse(resp.body)['email']).to eq(new_user_email)
    end

    it "logged out, logged new user in" do
        @ui.logout()
        sleep 1
        @ui.login_without_url(new_user_email, new_user_password)
        sleep 2
    end

    it "checked that whats new banner was not visible" do
        expect(@ui.css('.news-banner').visible?).to eq(false) 
    end
    
    it "reset news for all users, logged out, logged in" do
        @api.get_reset_news_all_users()
        sleep 1
        @ui.logout()
        @ui.login_without_url(new_user_email, new_user_password)
        sleep 2
    end

    it "checked that whats new banner was visible" do
      expect(@ui.css('.news-banner').visible?).to eq(true)
    end

    it "deleted newly created user" do
        resp = @api.delete_user_using_userid(new_user_id)
        expect(resp.code).to eq(200)
    end
end