require 'net/telnet'
require 'json'

require_relative "./resource/activation.rb"
require_relative "./resource/config_array_section.rb"
require_relative "./resource/get_array_section.rb"
require_relative "./resource/navigation.rb"

module CLI
  class Telnet
    include Activation
    include ConfigArraySection
    include GetArraySection
    include Navigation
    attr_accessor :ip, :username, :password, :session, :hostname
    
    def initialize(args = {})
      @ip = args[:ip]
      @username = args[:username] || "admin"
      @password = args[:password] || "admin"
      @initial_args = args
      @session = telnet_session(@ip, @username, @password, args[:timeout], args[:waiting_time])
    end

    def telnet_session(ip, username, password, timeout=nil, waiting_time=nil)
      timeout ||= 60
      waiting_time ||= 3
      session = Net::Telnet::new('Host' => ip,
      'Timeout' => timeout,
      'Waittime' => waiting_time,
      #'Binmode' => true,
      'Prompt' => /[$%#] /)
      login_prompt = /[Uu]sername[: ]*\z/n
      password_prompt= /[Pp]ass(?:word|phrase)[: ]*\z/n
      options={"LoginPrompt" => login_prompt, "PasswordPrompt" => password_prompt, "Name" => username, "Password" => password}
      session.login(options, password){|c|
        print c.gsub(16.chr, '') unless c.nil? || c.empty?
      }
      session
    end

    def cmd(command)
      begin
        output = @session.cmd(command) { |c| print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty? }

        if (output.nil? || output.empty?)
          throw NoAraraytelnetDataError
        end
      rescue Errno::EPIPE, NoAraraytelnetDataError, XMS::NoAraraytelnetDataError => e
        puts e
        puts "Hmmmmmmm AGAIN, Telnet Connection is broken! Trying to Reconnect..."
        begin
          puts "Close Connection"
          @session.close()

          puts "Let's ping to see an AP is dead or alive"
          puts "Sleep 20 seconds before ping"
          sleep 20

          up = ping(@ip, 4, 30, 10)
          if up
            puts "Successful Ping, AP is Online"
          else
            throw "AP is Ofline, Unsuccessful Ping, Please, check your AP's -> :#{@ip} connectivity to bring it Online"
          end

          puts "Trying to establish a new Telnet Connection..."
          @session = telnet_session(@ip, @username, @password, 80, 8)

          output = @session.cmd(command) {
            i = 9
          #|c| print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty?
          }

        rescue => e
          puts " - ***************** - \n\n -- Could't Reconnect \n\n - ***************** - \n"
          puts " - ***************** - \n\n -- Actual Error \n  #{e} \n - ***************** - \n"

          throw "Can't Reconnect to the AP: #{@ip}, Error: #{e}"
        end
      end

      unless output.nil? || output.empty?
        output = output.gsub(16.chr,'').gsub("\u0010",'')
        output = output.split(/\n/)
      end
      output
    end

    def show_json(_command)
      cleaned_show_json = @session.cmd("show json #{_command}"){|c|
        print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty?
      }

      if cleaned_show_json
        cleaned_show_json = cleaned_show_json.gsub("show json #{_command}",'').gsub("#{self.hostname}(config)\#",'').gsub("\u0010",'').gsub("#{16.chr}",'').gsub("\n",'')
        last_curly = cleaned_show_json.rindex('}')
        final_json = cleaned_show_json[0..last_curly]
        JSON.parse(final_json)
      else
        puts "\n\n\n Something Went Wrong NO DATA Returned back from AP Telnet Session \n\n\n"
      end
    end

    def memfree
      show_mem_free = cmd("show memfree")
      show_mem_free.get_line("MemFree:").split(' ')[1]
    end

    def close_connection
      @session.close
    end

    def close(level=2)
      top
      level.times {cmd('exit')}
    end

    def download_aos_version(aos_url)
      cmd("configure")
      cmd("file")
      cmd("http-get #{aos_url}")
      cmd("exit")
      cmd("exit")
      cmd("exit")
    end

    def upgrade_aos_version(aos_version)
      cmd("configure")
      cmd("file")
      cmd("active-image #{aos_version}")
      cmd("exit")
      cmd("exit")
    end

    def commands(commands_array)
      for i in 0..commands_array.length-1 do
        cmd(commands_array[i]) #{ |c| print c }
      end
    end

    def ssid_time_settings(ssid_name)
      ssid_settings = show_ssid(ssid_name)
      time_on = ssid_settings.get_line("Time on").split(' ')[2].strip
      time_off = ssid_settings.get_line("Time off").split(' ')[2].strip
      days_on = ssid_settings.get_line("Days on").split(' ')[2..-1]
      [time_on, time_off, days_on]
    end

    def group_time_settings(group_name)
      g_settings = show_group(group_name)
      time_on = g_settings.get_line("Time on").split(' ')[2].strip
      time_off = g_settings.get_line("Time off").split(' ')[2].strip
      days_on = g_settings.get_line("Days on").split(' ')[2..-1]
      [time_on, time_off, days_on]
    end

    def clear_syslog()
      configure
      cmd("clear syslog ")
    end
  end # telnet
end # CLI