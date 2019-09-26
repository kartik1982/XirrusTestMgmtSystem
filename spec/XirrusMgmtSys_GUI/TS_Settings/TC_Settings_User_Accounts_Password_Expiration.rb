############################################################################################################
#############TEST CASE: User Account - Password expiration by every 90 Days ################################
############################################################################################################

describe "*******************TEST CASE: User Account - Password expiration by every 90 Days*************" do
 user_email = nil
 user_id = nil
 tenant_id = nil
 user_body={}
 before :all do
   user_email = @username
   resp = @api.get_global_user_by_email(user_email)
   user_body = JSON.parse(resp.body)
   user_id = user_body['id']
   tenant_id = user_body['defaultTenantId']   
 end
 it "update expired date to two days before" do
   user_body.update({'passwordChangedDate' => DateTime.now - 91})#1745702194000
   resp = @api.put_update_user_for_tenant(tenant_id, user_id, user_body)
   expect(resp.code).to eq(200)
 end
 it "verify password expire window message" do
   @ui.logout()
   sleep 1
   @ui.login_without_url(@username, @password)
   sleep 2
   expect(@browser.url).to include("changepassword")
   expect(@ui.css('.submitBtn').attribute_value("value")).to eq("Change Password")
   expect(@ui.css('.login_form .info').text).to eq("Your password has expired. Please change your password now to login.\nNote: your password must be changed every 90 days. It can be changed at any time by using the Settings > My Account tab")
 end
 it "verify that user can not set same password" do
   @browser.element(name: "j_currentpassword").send_keys @password
   @browser.element(name: "j_newpassword").send_keys @password
   @browser.element(name: "j_newpassword_confirm").send_keys @password
   @ui.css('.submitBtn').click
   sleep 1
   expect(@ui.css('.login_form .error').text).to eq("New Password cannot be the same as Current Password")
   @browser.element(name: "j_currentpassword").send_keys @password
   @browser.element(name: "j_newpassword").send_keys "Xirrus!23"
   @browser.element(name: "j_newpassword_confirm").send_keys "Xirrus!23"
   @ui.css('.submitBtn').click
   sleep 1
   expect(@ui.error_dialog.present?).to eq(false)
 end
 
 it "Change password through Settings My account" do
    @ui.click('#header_nav_user')
    sleep 2
    @ui.css('#header_settings_link').wait_until_present
    @ui.click('#header_settings_link')
    sleep 1
    @ui.click('#settings_tab_myaccount')
    sleep 1
    @ui.css('#myaccount_changepassword_btn').click
    sleep 1
    @ui.set_input_val("#myaccount_changepassword_current .password", "Xirrus!23")
    @ui.set_input_val("#myaccount_changepassword_new .password", @password)
    @ui.set_input_val("#myaccount_changepassword_confirm .password", @password)
    @ui.css('xc-modal-buttons .orange').click
    sleep 2
 end

  after :all do
   @api.put_update_user_password_by_userid(user_id, @password)
   user_body.update({'passwordChangedDate' => "1745702194000"})
   resp = @api.put_update_user_for_tenant(tenant_id, user_id, user_body)
   expect(resp.code).to eq(200)

 end
end
