module Tenants
  # GET /tenants.json
  def get_tenants   
    get_api("tenants.json", {})  
  end  
  #GET /tenants.json/search
  def get_search_tenants(filter)   
    get_api("tenants.json/search", params={search: filter})  
  end
end