# require_relative '../../arrays/context.rb'
###############################################################################
#############TEST CASE: UI - User Accounts#####################################
###############################################################################
describe "TEST CASE: UI - User Accounts" do 
    email = UTIL.random_email
    password = "pazzword"
    tenant_id = nil
    user_id = nil

    before :all do
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

        # Add tenant
        name_erp = UTIL.random_title
        res = @api.post_add_tenant({name: name_erp, erpId: name_erp, products: ["XMS"]})
        tenant_id = JSON.parse(res.body)['id']
        puts "Tenant " + name_erp + " added - " + tenant_id

        # Add tenant user
        resp = @api.post_add_user_to_tenant(tenant_id, user_json)
        user_id = JSON.parse(resp.body)['id']
        puts "User " + email + " added - " + user_id
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
        res = @api.delete_tenant_by_tenantid(tenant_id)
        expect(JSON.parse(res.body)).to eq("Tenant deleted")
    end
end