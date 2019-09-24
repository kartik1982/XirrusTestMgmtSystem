require_relative "../msp_examples.rb"

describe "********** TEST CASE: Test the COMMANDCENTER area - DOMAINS - CREATE 5 DOMAINS (verify max limit) **********" do

  include_examples "go to commandcenter"
  (1..5).each do |i|
    tenant_name = "Adrian-Automation-Chrome-Fifth MAX LIMIT Verify " + i.to_s
    include_examples "verify domains meter updated properly", i-1, 5, false
    include_examples "create Domain", tenant_name
  end
  include_examples "verify domains meter updated properly", 5, 5, true
  include_examples "verify create new domain button disabled"
  (1..5).each do |i|
    tenant_name = "Adrian-Automation-Chrome-Fifth MAX LIMIT Verify " + i.to_s
    include_examples "delete Domain", tenant_name
    include_examples "verify domains meter updated properly", 5-i, 5, false
  end

end