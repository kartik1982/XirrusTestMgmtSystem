require_relative "./local_lib/reports_lib.rb"
################################################################################################################
##############TEST CASE: REPORTS - EMAIL REPORTS##############################################################
################################################################################################################
describe "********** TEST CASE: REPORTS - EMAIL REPORTS **********" do

  	report_name = "Report - Email - Non-Recurring - Email Verification"
  	subject = "Attached is your requested report:"
  	user_email = "report_non_recurring@testqa.com"

    it "verify report email received" do
      sleep 30
      @gmail = API::GmailApi.new(args={})
      email = @gmail.get_latest_emails_from_riverbed_for_user(user_email).last
      expect(email.size).to be > 0
      expect(email.subject).to include(user_email)
      expect(email.subject).to include(subject+" "+report_name)
      email_content = Nokogiri::HTML.parse(email.body.to_s, nil, 'utf-8')
      expect(email_content.css("h1").first.text).to eq("Dear Customer,")
      expect(email_content.css("p")[1].text).to eq("Please find the report Report - Email - Non-Recurring - Email Verifi=\ncation attached to this email.")
      expect(email_content.css("p")[2].text).to include("This is a report email from XMS-Cloud.")
    end
end

