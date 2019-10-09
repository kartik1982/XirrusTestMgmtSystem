module Tenants
  def get_eapi_tenant_by_erpid(erpid)
    get_eapi("entitlements/customer.json/erpid/#{erpid}")
  end
  def get_eapi_tenant_by_email(email_address)
    get_eapi("entitlements/customer.json/email/#{email_address}")
  end
  def post_eapi_add_tenant(load)
    post_eapi("entitlements/customer.json/add", load)
  end
  def post_eapi_renew_tenant(load)
    post_eapi("entitlements/customer.json/renew", load)
  end
    def put_eapi_upgrade_tenant(load)
    put_eapi("entitlements/customer.json/upgrade", load)
  end
end