require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: REPORTS - CREATION - ALL WIDGETS AND TIMES ###########################################
################################################################################################################
describe "********** TEST CASE: REPORTS - CREATION - ALL WIDGETS AND TIMES  **********" do

  decription_prefix = "portal description for "
  include_examples "delete all reports except for pre-canned"
  
  page_types = ["Top Access Points by usage","Access Point Throughput","Top Manufacturers by usage","Top Applications by usage","Top Application Categories by usage"]
  page_times = ["Last Hour","Last Day","Last 7 Days","Last 30 Days"]

  page_types.each { |page_type|
    report_name = UTIL.random_title.downcase + " - for testing all the widgets and times"
    include_examples "create report from header menu", report_name, decription_prefix + report_name
      page_times.each { |page_time|
        include_examples "edit report from tile", report_name, page_type, page_time
      }
    }    
end

