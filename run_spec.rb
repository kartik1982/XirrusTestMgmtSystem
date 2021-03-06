require 'optparse'

require_relative "executor/helper.rb"

options={}
options[:browser]="chrome"
options[:env]="test03"
options[:ui]=false
options[:telnet] = false
options[:skip_api]=false
options[:remote_report]= false
options[:remote_srvr]="10.100.185.250"
options[:serial]=nil

OptionParser.new do |opts|
  opts.on("--env ENVIRONMENT"){|obj| options[:env]=obj}
  opts.on("--username USERNAME"){|obj| options[:username]=obj}
  opts.on("--password PASSWORD"){|obj| options[:password]=obj}
  opts.on("--project_id PROJECTID"){|obj| options[:project_id]=obj}
  opts.on("--release_id RELEASEID"){|obj| options[:release_id]=obj}
  opts.on("--testcycle_id TESTCYCLEID"){|obj| options[:testcycle_id]=obj}
  opts.on("--spec SPEC"){|obj| options[:spec]=obj}
  opts.on("--browser_name BROWSERNAME"){|obj| options[:browser_name]=obj}
  opts.on("--ui GUIENABLED"){|obj| options[:ui]=obj}
  opts.on("--telnet TELNET"){|obj| options[:telnet]=obj}
  opts.on("--skip_api SKIPAPI"){|obj| options[:skip_api]=obj}
  opts.on("--remote_report RemoteREPORTINGENABLED"){|obj| options[:remote_report]=obj}
  opts.on("--serial SERIAL","Please Provide an Array Serial"){|obj| options[:serial] = obj}
end.parse!


if options[:serial] 
  if options[:serial] != 'none'
    array_serial = options[:serial].to_sym
  else
    array_serial = nil
  end
else 
  array_serial = nil
end

settings={
  env: options[:env],
  username: options[:username],
  password: options[:password],
  browser_name: options[:browser_name],
  ui: options[:ui],
  remote_srvr: options[:remote_srvr],
  remote_report: options[:remote_report],
  project_id: options[:project_id],
  testcycle_id: options[:testcycle_id],
  release_id: options[:release_id],
  array_serial: array_serial,
  skip_api: options[:skip_api]
 }
spec = options[:spec]
#spec= "TS_Profiles/TC_Profile_01_spec.rb"
EXECUTOR.run_specs([spec], settings)