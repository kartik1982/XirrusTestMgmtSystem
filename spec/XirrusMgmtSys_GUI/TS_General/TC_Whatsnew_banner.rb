#################################################################################
##############TEST CASE: What's new banner behavior#############################
#################################################################################
describe "TEST CASE: What's new banner behavior" do
  new_user_email = "banner_test@testing.com"
  new_user_password = "pazzword"
  new_user_id = ""
  before :all do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
  end
  user_json = {
       "lastName": "banner_last",
       "phone": "111-222-3333",
       "tenantUsers": [ ],
       "status": "ACTIVE",
       "showWelcome": "false",
       "password": {
           "isSet": "true",
           "value": "pazzword"
       },
       "email": "banner_test@testing.com",
       "acceptedEula": "true",
       "description": "string",
       "roles": [
           "ROLE_XMS_ADMIN", "ROLE_BACKOFFICE_ADMIN"
       ],
       "forceResetPassword": "false",
       "firstName": "banner_first"
   }
  
    it "created user with given password" do
        resp = @ng.add_user(user_json)
        new_user_id = resp.body['id']
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
        @ng.reset_whats_new_for_all_users()
        sleep 1
        @ui.logout()
        @ui.login_without_url(new_user_email, new_user_password)
        sleep 2
    end

    it "checked that whats new banner was visible" do
      expect(@ui.css('.news-banner').visible?).to eq(true)
    end

    it "deleted newly created user" do
        @ng.delete_user(userId: new_user_id)
    end
end