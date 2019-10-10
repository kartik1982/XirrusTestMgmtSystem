require 'rspec'
require 'watir'
require 'pathname'
require 'rest-client'
require 'net/ssh'
require 'net/scp'
require 'logger'
require 'json'
require 'optparse'
require 'headless'
require 'time_diff'
require 'pp'
require 'csv'
require 'gmail'
require 'nokogiri'
require 'active_support/time'

require_relative "spec_runner.rb"
require_relative "../api/api_client/api_client.rb"
require_relative "../api/entitlement_api/entitlement_api.rb"
require_relative "../api/gmail_api/gmail_api.rb"
require_relative '../api/logstash_api/logstash_api.rb'
require_relative "../gui/ui.rb"
require_relative "../arrays/array.rb"
require_relative "../cli/ssh/ssh_session.rb"
require_relative "../vmd/fog/fog_session.rb"


pn = Pathname.new("xirrus-auto")
if pn.exist?
  load "#{pn}"
else
  puts "please save your default config settings at #{ENV['HOME']}/.xirrus-auto \n"
  puts "copy the dot_xirrus-auto_example file to ~/.xirrus-auto and modify for your settings\n"
end
def log(text)
  if File.exists?(@log_file)

    File.open(@log_file,'a'){|f| f.puts(text) }
  end
end
def api
  API::ApiClient.new(args={username: @username, password: @password, host: @login_url})
end

def get_token_by_email_password(email, password)
  begin
    path="http://10.100.185.250:3000/api/v1/login"
    response = RestClient.post path, {email: "#{email}", password: "#{password}"}.to_json, {content_type: :json, accept: :json}
    response_json = JSON.parse(response, :symbolize_names => true)
    token =  response_json[:token] 
    return token
  rescue
    puts "#{value} NOT FOUND IN DATABASE"
  end
end
def move_log_file_to_remote_server(server_addr, local_path, remote_path, testcase_name)
    begin
        Net::SSH.start(server_addr, "xirrus", password: "Xirrus!23") do |ssh|
        ssh.exec!("mkdir -p #{remote_path}")
        ssh.scp.upload! "#{local_path}/#{testcase_name}.html", "#{remote_path}/#{testcase_name}.html"
        ssh.scp.upload! "#{local_path}/#{testcase_name}.txt", "#{remote_path}/#{testcase_name}.txt"
       end
    rescue
      puts "something wrong with file transfer"
    end
  end
  
def get_entitlement_api_args
  env = @env
  case env
  when "production"
  args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test03-api-94151060.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
  }
  when "preview"
    # $VERBOSE = nil
    # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test03-api-94151060.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
    }
  when "test03"
    args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test03-api-94151060.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
    }
  when "test01"
    args={
        username: @username,
        password:@password,
        host: @login_url,
        ent_url: "https://test01-api-311195077.cloud.xirrus.com",
        ent_load: { product: "ENTITLEMENTS", scope: "READ_WRITE"}
    }
    args
 end
end

def entitlement_api
  API::EntitlementApi.new(get_entitlement_api_args)
end

def get_tenant_load
  args= { name: "suspicious-entitlement-update-automation-xms-admin",
                  erpId: "suspicious-entitlement-update-automation-xms-admin",
                  tenantProperties: {
                    apCountLimit: 4,
                    easypassPortalExpiration: Time.now + 12.months*1000,
                    allowEasypass: true,
                    allowAosAppcon: true},
                    expirationDate: Time.now + 12.months*1000,
                  products: ["XMS"]}
end

def get_user_load
  args= { lastName: "Dinte",
         phone: "111-222-3333",
         tenantUsers: [ ],
         status: "ACTIVE",
         showWelcome: false,
         password: {
             isSet: true,
             value: "Qwerty1@"
         },
       email: "suspicious+entitlement+update+automation+xms+admin@xirrus.com",
       acceptedEula: true,
       description: "Description",
       roles: [
            "ROLE_BACKOFFICE_SUPER_ADMIN",
            "ROLE_XMS_ADMIN"
       ],
       forceResetPassword: false,
       firstName: "suspicious-entitlement-update-automation-xms-admin"}
end