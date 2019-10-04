module Arrays
  def post_add_array_into_account(array_load)
    post("apexrest/automated-cloud-integration", array_load)
  end
  def delete_array_by_serial(ap_sn)
    delete("apexrest/automated-cloud-integration", {serialNumber: ap_sn})
  end
end