module Ssodomain
  #GET /ssodomain.json/allTenants
  def get_all_ssodomains_for_all_tenants
    get_api("ssodomain.json/allTenants", {})
  end
  #DELETE /ssodomain.json/{ssoDomainId}
  def delete_ssodomain_by_ssodomainid(ssodomain_id)
    delete_api("ssodomain.json/#{ssodomain_id}")
  end
end