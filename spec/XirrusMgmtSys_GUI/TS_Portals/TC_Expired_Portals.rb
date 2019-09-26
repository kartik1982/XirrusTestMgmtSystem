require_relative "./local_lib/portals_lib.rb"
require_relative "../TS_MSP/local_lib/msp_lib.rb"

tenant_name = "expired-portal-automation-xms-admin"
tenant_body={}
portal_exp=nil
tenant_id=nil


describe "********** TEST CASE: PORTAL EXPIRATION - Modify the tenant's 'easypassPortalExpiration', 'easypassExpirationEnforcement' and 'allowEasypass' values **********" do
  context "********** Set tenant expiration for fature date **********" do
      it "Set tenant expiration for feature date to verify will expired mesage" do        
        tenant_body = JSON.parse(@api.get_tenant_by_name(tenant_name).body)['data'].first
        tenant_id = tenant_body['id']
        tenant_body.update({'tenantProperties' => {'easypassPortalExpiration' => DateTime.now + 30}})
        response = @api.put_update_tenant_by_tenantid(tenant_id, tenant_body)
        expect(response.code).to eq(200)
      end
    end
  context "********** Verify Eassy pass will expire message alert windows **********" do
    include_examples "verify limited time offer on portals"
  end
  context "********** Set tenant expiration for past date **********" do
    it "Set tenant expiration for feature date to verify will expired mesage" do  
      tenant_body.update({'tenantProperties' => {'easypassPortalExpiration' => DateTime.now - 93, 'easypassExpirationEnforcement' =>DateTime.now - 2, 'allowEasypass' => false}})
      response = @api.put_update_tenant_by_tenantid(tenant_id, tenant_body)
      expect(response.code).to eq(200)
    end
  end
  
  context "********** Verify Eassy pass will expire message alert windows **********" do
    include_examples "verify limited time offer expired on portals"
    include_examples "verify the portal creation modal"
  end
  
  context "********** Reset tenant expiration to null **********" do
    it "Set tenant expiration for feature date to verify will expired mesage" do
      tenant_body.update({'tenantProperties' => {'easypassPortalExpiration' => nil, 'easypassExpirationEnforcement' => nil, 'allowEasypass' => true}})
      response = @api.put_update_tenant_by_tenantid(tenant_id, tenant_body)
      expect(response.code).to eq(200)
    end
  end
end