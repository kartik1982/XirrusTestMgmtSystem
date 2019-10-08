module Arrays
  def add_N_number_Arrays(count, expiration=1541870296000)
    command = "addArray -n #{count} --arrayModel XR620 --expirationDate #{expiration} --env #{@env} --username #{@username} --password #{@password}"
    execute(command)
  end
  def add_array_into_tenant(tenant_id, array_sn)
    # execute("setTenantScope --tenantId #{tenant_id} --env #{@env}")
    execute("addArray --tenantId #{tenant_id} --serialNumber #{array_sn} --arrayModel XR620 --env #{@env}") #--expirationDate 1541870296000 --location Moon --licensedAosVersion 8.5
  end

  def add_array_into_tenant_to_current_tenant(array_sn)
    execute("addArray --serialNumber #{array_sn} --arrayModel XR620 --env #{@env} --username #{@username} --password #{@password}") #--expirationDate 1541870296000 --location Moon --licensedAosVersion 8.5
  end

  def delete_array_from_tenant_from_current_tenant(ap_sn)
    stop_all_process_running_for_ap_serial(ap_sn)
    execute("deleteArray --serialNumber #{ap_sn} --env #{@env} --username #{@username} --password #{@password}")
  end

  def activate_array_by_serial(ap_sn)
    execute("activateArray --serialNumber #{ap_sn} --env #{@env}")
  end

  def add_Provision_array_by_serial_with_erpid(tenant_erpid, ap_sn)
    execute("addProvisionAps --erpId #{tenant_erpid} --serialNumber #{ap_sn} --env #{@env}")
  end

  def delete_array_from_tenant(tenant_id, array_sn)
    execute("setTenantScope --tenantId #{tenant_id} --env #{@env}")
    execute("deleteArray --serialNumber #{array_sn} --env #{@env}")
  end
  def tun_on_array_with_station(ap_sn, station_host, station_mac)
    stop_all_process_running_for_ap_serial(ap_sn)
    command = "turnOnArray --serialNumber #{ap_sn} --stationHostname #{station_host} --stationMac #{station_mac} --stationHost Kartik --env #{@env}"
    session.exec!("cd test-tools/fog/; nohup node cli.js #{command} &>/dev/null &")
  end
  def tun_on_array(ap_sn)
    stop_all_process_running_for_ap_serial(ap_sn)
    command = "turnOnArray --serialNumber #{ap_sn} --env #{@env} --stations 0"
    session.exec!("cd test-tools/fog/; nohup node cli.js #{command} &>/dev/null &")
  end
end