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
  def get_tenant_by_name(tenant_name)   
    get_api("tenants.json/name/#{tenant_name}", {})  
  end
  #PUT /tenants.json/{tenantId}
  def put_update_tenant_by_tenantid(tenant_id, tenant_load)
    put_api("tenants.json/#{tenant_id}", tenant_load)
  end
  #GET /tenants.json/current
  def get_current_tenant
    get_api("tenants.json/current", {})
  end
  #POST /tenants.json/{tenantId}/arrays
  def post_add_arrays_to_tenant(tenant_id, arrays_load)
    post_api("tenants.json/#{tenant_id}/arrays", arrays_load)
  end
  #DELETE /tenants.json/{tenantId}
  def delete_tenant_by_tenantid(tenant_id)
    delete_api("tenants.json/#{tenant_id}")
  end
  def delete_tenant_by_name(tenant_name)
    tenant_id= JSON.parse(get_tenant_by_name(tenant_name).body)['data'][0]['id']
    delete_tenant_by_tenantid(tenant_id)
  end
end