require 'net/ssh'
require 'json'

require_relative "./resource/activation.rb"
require_relative "./resource/config_array_section.rb"
require_relative "./resource/get_array_section.rb"

module CLI

  class SshSession
    include Activation
    include ConfigArraySection
    include GetArraySection
    
    attr_accessor :ip, :username, :password, :session, :hostname, :device_type #device_type aos or aoslite

    def initialize(args = {})
      @ip = args[:ip]
      @username = args[:username] || "admin"
      @password = args[:password] || "admin"
      @initial_args = args
      @session = ssh_session(@ip,@username,@password)
      @device_type = args[:device_type]
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

    def cmd(commands=[])
      res = []
      counter = 0
      begin
        channel = @session.open_channel do |channel|
          puts "SSH channel successfully opened ....."

          channel.request_pty do |ch, success|
            raise "Error requesting pty" unless success

            ch.send_channel_request("shell") do |ch, success|
              raise "Error opening shell" unless success
            end
          end

          channel.on_data do |ch, data|
            #puts data
            STDOUT.print data
            res << data

            data = data.strip
            if data[-1] == "#" && counter <= commands.length
              ch.send_data( "#{commands[counter]}\n")
              counter += 1
            end
          end

          channel.on_extended_data do |ch, type, data|
            puts "Error: #{data}\n"
          end
        end
        channel.wait
      end
      #puts "SSH COMMANDS RES: #{res}"
      res = res.join(' ')

      res = res.gsub(/\t/, '').gsub(16.chr,'').gsub("\u0010",'')
      res.split(/\n/)
    end

    def show_json(_command, replace_all_whitespaces=true)
      @device_type.downcase.eql?("aos") ? commands = ["more off", "show json #{_command}", "quit"] : commands = ["show json #{_command}", "quit"]
      cleaned_show_json = cmd(commands){ |c|
        print c.gsub(16.chr, '')
        k.gsub("\u0010","")
      }.join().gsub("show json #{_command}",'').gsub("#{self.hostname}(config)\#",'').gsub("\u0010",'').gsub("#{16.chr}",'').gsub("\n",'')

      first_curly = cleaned_show_json.index('{')
      last_curly = cleaned_show_json.rindex('}')
      final_json = cleaned_show_json[first_curly..last_curly]
      final_json = final_json.gsub(/\s+/, ' ').gsub(/\s*t\s*r\s*u\s*e/, 'true').gsub(/\s*f\s*a\s*l\s*s\s*e/, 'false')
      if replace_all_whitespaces
        final_json = final_json.gsub(/\s/, '')
      end

      # Match and remove emty spaces inside integer values
      final_json.gsub!(/(\d+)\s+(\d+)/, '\1\2')

      JSON.parse(final_json)
    end

    def upgrade_aos_light_version(ap)
      s_v = show_system_software()
      unless s_v.include?(ap[:version])
        ssh_commands_aos_light(["firmware-upgrade #{ap[:url]}", "quit"])
      end
    end      

    def show_json_dhcp_server_settings()
      # TEST
      show_json("running-config", true)["system"]["ethCfg"]
    end

    def set_offline(env='test03')
      cmd(["cloud off", "activation stop", "activation interval 1", "save", "quit"])
    end

    def close
      cmd('quit')
    end

    def top
      cmd('top')
    end

    def show
      cmd('show')
    end
    def fixtures_root
      File.expand_path File.dirname(__FILE__).gsub("/cli/ssh","")+"/fixtures"
    end
  end # SSH Session
end # SSH