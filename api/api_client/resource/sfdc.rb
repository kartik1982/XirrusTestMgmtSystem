module Sfdc
  # GET /sfdc.json/apeController
  def get_apr_controller
    get_api("sfdc.json/apeController")
  end   
  #GET /sfdc.json/customerData
  def get_cutomer_data_sync
    get_api("sfdc.json/customerData", {})
  end   
end