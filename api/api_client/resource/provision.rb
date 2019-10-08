module Provision
  # POST /provision.json/ap
  def post_add_aps(aps_load)
    post_api("provision.json/ap", aps_load)
  end

  #DELETE /provision.json/ap/{apId}
  def delete_ap_byapid(ap_id)
    delete_api("provision.json/ap/#{ap_id}")
  end

  #POST /provision.json/ap/upload
  def post_upload_aps(file_path)
    post_api("provision.json/ap/upload", {:file => File.new(file_path), :content => :text})
  end

  #GET /provision.json/ap/counts
  def get_ap_counts(load)
    get_api("provision.json/ap/counts", load)
  end

  #GET /provision.json/ap
  def get_list_pending_deployed_aps
    get_api("provision.json/ap",{})
  end

  #GET /provision.json/ap/search/{search}
  def get_search_ap(search_filter)
    get_api("provision.json/ap/search/#{search_filter}", {})
  end
end