require_relative "local_lib/entitlement_api_lib.rb"
describe "*********TESTCASE: ENTITLEMENT API FOR CUSTOMER***********" do
  erp_id = nil
  tenant_name = nil
  email_address = nil

  before :all do
    @eapi = entitlement_api  
    current_tenant =  JSON.parse(@api.get_current_tenant.body)
    erp_id = current_tenant['erpId']
    tenant_name = current_tenant['name']
    email_address = "api+automation+xms+admin@xirrus.com"
  end
  it "verify entitlement API for get cusomter using erpid" do    
    response = @eapi.get_eapi_tenant_by_erpid(erp_id)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body)
    expect(tenant['erpId']).to eq(erp_id)
    expect(tenant['name']).to eq(tenant_name)  
  end

  it "verify entitlement API for get customer using email address" do
    response = @eapi.get_eapi_tenant_by_email(email_address)
    expect(response.code).to eq(200)
    tenant= JSON.parse(response.body).first
    expect(tenant['erpId']).to eq(erp_id)
    expect(tenant['name']).to eq(tenant_name)
  end  
end