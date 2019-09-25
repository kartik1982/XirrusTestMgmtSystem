module Tenants
  # GET /tenants.json
  def get_tenants   
    get_api("tenants.json", {})  
  end  
  #GET /tenants.json/search
  def get_search_tenants(filter)   
    get_api("tenants.json/search", params={search: filter})  
  end
  #GET /tenants.json/name/{tenantName}
  def tenant_by_name(tenant_name)   
    get_api("tenants.json/name/#{tenant_name}", {})  
  end
  #PUT /tenants.json/{tenantId}
  def put_update_tenant_by_tenantid(tenant_id, tenant_load)
    put_api("tenants.json/#{tenant_id}", tenant_load)
  end
end