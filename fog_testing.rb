require_relative 'vmd/fog/fog_session.rb'
@username= "general+time+format+automation+xms+admin@xirrus.com"
@password = "Qwerty1@"
@env = "test03"

fog = VMD::FogSession.new({username: @username, password: @password, env: @env, aosVersion: "8.4.9-7335"})
fog.add_N_number_Arrays(4)
time = Time.now + 10.days
fog.add_N_number_Arrays(4, time.to_i*1000)
fog.add_Provision_array_by_serial_with_erpid(erp_id, "NAUTO0000000001")
sleep 2
fog.activate_array_by_serial("NAUTO0000000001")
sleep 2
# fog.session.exec!("nohup sleep 10 &>/dev/null &")
# sleep 1
# output = fog.session.exec!("hostname")
# fog.add_array_into_tenant_to_current_tenant("NAUTO0000000001")
fog.add_array_into_tenant("0a60d9d0-8f5d-11e8-a180-06494a71b581", "NAUTO0000000001")
# fog.activate_array_by_serial("NAUTO0000000001")
# sleep 4
fog.tun_on_array_with_station("NAUTO0000000001", "Kartik-station","00:00:00:00:00:01")
fog.tun_on_array("NAUTO0000000001")
sleep 30
fog.delete_array_from_tenant_from_current_tenant("NAUTO0000000001")
# sleep 1
fog.stop_all_process_running_for_ap_serial("NAUTO0000000001")

sleep 1
