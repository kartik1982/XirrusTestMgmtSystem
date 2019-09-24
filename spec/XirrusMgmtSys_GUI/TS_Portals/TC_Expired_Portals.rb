require_relative "./local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"

tenant_name = "expired-portal-automation-xms-admin"


describe "********** TEST CASE: PORTAL EXPIRATION - Modify the tenant's 'easypassPortalExpiration', 'easypassExpirationEnforcement' and 'allowEasypass' values **********" do
  context "********** Set tenant expiration for fature date **********" do
      it "Set tenant expiration for feature date to verify will expired mesage" do
        @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
        @ng = API::ApiClient.new(token: @token)
        @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
        @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
        @get_tenant_by_name["data"][0]["tenantProperties"]["easypassPortalExpiration"]=DateTime.now + 30
        @update_tenant = @ng.update_tenant2(@needed_tenent_id, @get_tenant_by_name["data"][0])
        expect(@update_tenant.code).to eq(200)
      end
    end
  context "********** Verify Eassy pass will expire message alert windows **********" do
    include_examples "verify limited time offer on portals"
  end
  context "********** Set tenant expiration for past date **********" do
      it "Set tenant expiration for feature date to verify will expired mesage" do
        @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
          @ng = API::ApiClient.new(token: @token)
          @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
          @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
          @get_tenant_by_name["data"][0]["tenantProperties"]["easypassPortalExpiration"]=DateTime.now - 93
          @get_tenant_by_name["data"][0]["tenantProperties"]["easypassExpirationEnforcement"]= DateTime.now - 2
          @get_tenant_by_name["data"][0]["tenantProperties"]["allowEasypass"]=false
          @update_tenant = @ng.update_tenant2(@needed_tenent_id, @get_tenant_by_name["data"][0])
          expect(@update_tenant.code).to eq(200)
      end
    end
  context "********** Verify Eassy pass will expire message alert windows **********" do
    include_examples "verify limited time offer expired on portals"
    include_examples "verify the portal creation modal"
  end
  
  context "********** Reset tenant expiration to null **********" do
      it "Set tenant expiration for feature date to verify will expired mesage" do
        @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
        @ng = API::ApiClient.new(token: @token)
        @get_tenant_by_name = @ng.tenant_by_name(tenant_name).body
        @needed_tenent_id = @get_tenant_by_name.to_s[18..53]
        @get_tenant_by_name["data"][0]["tenantProperties"]["easypassPortalExpiration"]= nil
        @get_tenant_by_name["data"][0]["tenantProperties"]["easypassExpirationEnforcement"]= nil
        @get_tenant_by_name["data"][0]["tenantProperties"]["allowEasypass"]=true
        @update_tenant = @ng.update_tenant2(@needed_tenent_id, @get_tenant_by_name["data"][0])
        expect(@update_tenant.code).to eq(200)
      end
    end
end