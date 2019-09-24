#XMSC-3173- Switch | Monitoring - Port Utilization
require_relative "./local_lib/switches_lib.rb"
require_relative "../TS_Profiles/local_lib/profiles_lib.rb"
##############################################################################################################
##############TEST CASE: Swtich port stats - Test switch port stats panel##################################
##############################################################################################################
describe "********** TEST CASE: Swtich port stats - Test switch port stats panel **********" do
  #variables initialization 
  switch_sn= "BBBBCCDD00B0"
  switch_name = "Auto-Switch-XS-6012P-1"
  profile_name = "Profile for switch port stats"
  description = "Profile description for " + profile_name
  sw_template_name="Switch template Port stats"
  sw_template_description = "Description of "+sw_template_name
  sw_port_name = "switch port template stats"
  sw_port_description = "Description for "+sw_port_name
  #Delete all templates and profile
  include_examples "delete all switch templates"
  include_examples "delete all switch port templates"
  include_examples "delete all profiles when switch present"
  #Verify no stats tab in switch port template
  include_examples "create switch port template", sw_port_name, sw_port_description
  include_examples "verify switch port stats panel status", sw_port_name, "port_template", false, nil
  #Verify no stats tab in switch template for port
  include_examples "create switch template", sw_template_name, sw_template_description, "XS-6012P"
  include_examples "verify switch port stats panel status", sw_template_name, "switch_template", false, nil
  # Verify Profile switch config tab port dont have stats option
  include_examples "Create profile from tile when switch present", profile_name, description, false
  include_examples "verify switch port stats panel status", profile_name, "profile_switch_config", false, nil
  #verify switch tab port stats tab
  include_examples "verify switch port stats panel status", switch_name, "switch_tab", true, switch_sn
  #add Switch into profile
  include_examples "assign switch(es) to profile", profile_name, [switch_sn]
  include_examples "verify switch port stats panel status", profile_name, "profile_switch_tab", true, switch_sn
end

