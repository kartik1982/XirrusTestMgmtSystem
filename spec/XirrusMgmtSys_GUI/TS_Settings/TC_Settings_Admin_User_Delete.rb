# require_relative '../../arrays/context.rb'
###############################################################################
#############TEST CASE: UI - User Accounts#####################################
###############################################################################
describe "TEST CASE: UI - User Accounts" do 
    email = UTIL.random_email
    password = "pazzword"
    tenant_id = ""

    before :all do
        @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
        @ng = API::ApiClient.new(token: @token)
        user_json = {
            "lastName": "banner_last",
            "phone": "111-222-3333",
            "tenantUsers": [ ],
            "status": "ACTIVE",
            "showWelcome": "false",
            "password": {
                "isSet": "true",
                "value": password
            },
            "email": email,
            "acceptedEula": "true",
            "description": "string",
            "roles": [
                "ROLE_XMS_ADMIN", "ROLE_BACKOFFICE_ADMIN"
            ],
            "forceResetPassword": "false",
            "firstName": "banner_first"
        }
        
        # Add user
        res = @ng.add_user(user_json)
        user = res.body
        user_id = user['id']
        puts "User " + email + " added - " + user_id

        # Add tenant
        name_erp = UTIL.random_title
        res = @ng.post("/tenants.json/", {name: name_erp, erpId: name_erp, products: ["XMS"]})
        tenant_id = res.body['id']
        puts "Tenant " + name_erp + " added - " + tenant_id

        # Add tenant user
        @ng.post("/tenants.json/#{tenant_id}/users", user)

        @ui.logout()
        sleep 1

        @ui.login(@login_url, email, password)
        sleep 2
    end
    
    let(:grid){@ui.user_grid}

    it "UI - Delete Admin User" do 
        @ui.goto_user_accounts
        sleep 2
        row = grid.row_div(email)
        row.wait_until_present

        row.hover 

        row.delete_icon.click

        @ui.confirm_dialog

        sleep 3
        
        @ui.forgot_password_link.wait_until_present
        expect(@ui.forgot_password_link).to be_visible
    end

    it "Delete Tenant" do 
        res = @ng.delete_tenant(tenant_id)
        puts "Tenant deleted - " + tenant_id
    end
end