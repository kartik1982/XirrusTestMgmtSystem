require 'net/ssh'
require 'json'

require_relative "./resource/arrays.rb"

module VMD
 
  class FogSession
    include Arrays
    
    attr_accessor :ip, :username, :password, :session, :hostname, :device_type, :env
    def initialize(args = {})
      fog_srvr_ip = args[:fog_srvr_ip] ||"10.100.185.59"
      fog_srvr_user = args[:fog_srvr_user] || "xirrus"
      fog_srvr_password= args[:fog_srvr_password] || "Xirrus!23"
      @env = args[:env]
      @username = args[:username]
      @password = args[:password]
      @session = ssh_session(fog_srvr_ip,fog_srvr_user,fog_srvr_password)
    end

    def ssh_session(ip, username, password)
      stop_recursion = nil
      begin
        Net::SSH.start(ip, username,
        :password => password,
        :auth_methods => ["password"],
        :keepalive => true,
        :keepalive_interval => 100)
      rescue Net::SSH::HostKeyMismatch => e
        puts "Clear old fingerprint : #{e.fingerprint}"
        clear_rsa_fingerprint(ip)
        puts "One more Retry"
        ssh_session(ip, username, password) unless stop_recursion
      stop_recursion = true
      end
    end
    def execute(command)  
      puts "COMMAND: #{command}"    
      output= session.exec!("cd test-tools/fog/; nohup node cli.js #{command}")
      puts "OUTPUT FROM SSH COMMAND: #{output}"
      return output
    end
    def stop_all_process_running_for_ap_serial(ap_sn)
      sessions = session.exec!("ps -aux|grep '#{ap_sn}'")
      pids = sessions.split('xirrus')
      pids.each do |pid|
        if !pid.strip.empty?
          id =pid.strip.split(' ')[0]
          session.exec!("kill -9 #{id}")
        end  
      end
    end
  end
end