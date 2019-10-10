require 'net/ssh'

class SSHSession

    def initialize(args = {})
      srvr_ip = args[:srvr_ip] ||"10.100.185.59"
      srvr_user = args[:rvr_user] || "xirrus"
      srvr_password= args[:srvr_password] || "Xirrus!23"
      @session = ssh_session(srvr_ip,srvr_user,srvr_password)
    end

    def ssh_session(ip, username, password)
      stop_recursion = nil
      begin
        Net::SSH.start(ip, username,
        :password => password,
        :auth_methods => ["password"],
        :keepalive => true,
        :keepalive_interval => 600)
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
      output= @session.exec!("cd XirrusTestMgmtSystem; sudo -S <<< 'Xirrus!23' #{command}")
      puts "OUTPUT FROM SSH COMMAND: #{output}"
      return output
    end  
    def bundle_install
      execute("bundle install")
    end  
    def get_latest_code
      execute("git pull origin master")
    end
    def install_essentials
      execute("apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev")
    end
  end
  #UPDATE ALL LINUX SERVERS - 10-10-2019
  begin
    linux_servers =["10.100.185.35", "10.100.185.49", "10.100.185.45", "10.100.185.48", "10.100.185.52"]
    linux_servers.each do |server_ip|
      session = SSHSession.new({srvr_ip: server_ip, srvr_user: "xirrus", srvr_password: "Xirrus!23"})
      session.get_latest_code
      session.install_essentials
      session.bundle_install
    end  
    puts "Updated all Linux servers #{linux_servers.to_s}"
  rescue  => e
    puts "server update failed:- #{e}"
  end
