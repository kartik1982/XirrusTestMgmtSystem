require_relative "../local_lib/switches_lib.rb"
require_relative "../../TS_Profiles/local_lib/profiles_lib.rb"
require_relative "../../TS_Profile/local_lib/profile_lib.rb"
require_relative "../../TS_MSP/local_lib/msp_lib.rb"
##############################################################################################################
##############TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB###################################
##############################################################################################################
describe "********** TEST CASE: Test the COMMANDCENTER area - ACCESS POINTS TAB **********" do
  
	profile_name = "Profile to be deployed - " + UTIL.ickey_shuffle(3)
	profile_description = "Description for " + profile_name
	domain_name= "Deploy switch template to this domain 1" 
	sw_port_temp_access_name = "Switch port access template to deploy"
	sw_port_temp_access_desc = "Description of "+sw_port_temp_access_name
	sw_port_temp_trunk_name = "Switch port trunk template to deploy"
  sw_port_temp_trunk_desc = "Description of "+sw_port_temp_trunk_name
	switch_template_name = "switch template to deploy"
	switch_template_description = "Description of "+switch_template_name
	switch_model= "XS-6012P"
	switch_serial_number = "BBBBCCDD00D0"	
	sw_port_config_access = {name: sw_port_temp_access_name, description: sw_port_temp_access_desc, icon: "antenna", portenable: "enabled", speed: "Auto", type: "Access", native_vlan: "200", member_vlans: "200,300", poe: "enabled", poe_priority: "Critical", stp_guard: "enabled", access_security: "disabled", auth_mode: "802.1x MAC Based"}
  sw_port_config_trunk = {name: sw_port_temp_trunk_name, description: sw_port_temp_trunk_desc, icon: "transmission", portenable: "enabled", speed: "Auto", type: "Trunk", native_vlan: "100", member_vlans: "200,300", poe: "enabled", poe_priority: "High", stp_guard: "disabled", access_security: "disabled", auth_mode: ""}
  #Delete all templates and profiles
	include_examples "delete all switch port templates"
	include_examples "delete all switch templates"
	include_examples "delete all profiles when switch present"	
	#Add and confiure switch port templates	Access and Trunk
	include_examples "create switch port template", sw_port_temp_access_name, sw_port_temp_access_desc
	include_examples "configure switch port template", sw_port_config_access
  include_examples "create switch port template", sw_port_temp_trunk_name, sw_port_temp_trunk_desc
	include_examples "configure switch port template", sw_port_config_trunk
  #Add Switch template and configure
  include_examples "create switch template", switch_template_name, switch_template_description, switch_model
  include_examples "configure switch template using port template", switch_template_name, sw_port_temp_access_name, sw_port_temp_trunk_name, {}, {} 
  #Add Profile and configure
  include_examples "Create profile from tile when switch present", profile_name, profile_description, false
  include_examples "perform changes on switch tab of a profile by loading switch template", profile_name, switch_template_name, switch_model
	include_examples "go to commandcenter"
	include_examples "create Domain", domain_name
	include_examples "assign unassign switch to domain", switch_serial_number, "assign", domain_name
	#Deploy Switch port template
	include_examples "deploy switch port template to a domain from switch port template landing page", sw_port_temp_access_name, domain_name
	include_examples "deploy switch port template to a domain from switch port template landing page", sw_port_temp_trunk_name, domain_name
	#Deploy switch template
	include_examples "deploy switch template to a domain from switch template landing page", switch_template_name, domain_name
	#Deploy profile
	include_examples "deploy profile to a domain from profiles landing page", profile_name, domain_name
	#Scope to child domain
	include_examples "go to commandcenter"
	include_examples "manage specific domain", domain_name 
	#verify switch port template
	include_examples "verify switch port template configuration", sw_port_config_access
	include_examples "verify switch port template configuration", sw_port_config_trunk
	#verify switch template
	include_examples "verify switch template using port template config", switch_template_name, switch_model, sw_port_config_access, sw_port_config_trunk, {}, {}
	#Verify Profile
	include_examples "verify profile switch tab configuration using port config", profile_name, switch_model, sw_port_config_access, sw_port_config_trunk, {}, {}
	include_examples "go to commandcenter"
	include_examples "assign unassign switch to domain", switch_serial_number, "unassign", domain_name
	include_examples "delete Domain", domain_name
  include_examples "delete all switch port templates"
  include_examples "delete all switch templates"
  include_examples "delete all profiles when switch present"  
end