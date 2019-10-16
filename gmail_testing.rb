require_relative 'api/gmail_api/gmail_api.rb'
require 'nokogiri'

@gmail = API::GmailApi.new(args={})
to_email_address = "xmsc.sync.alerts@cambiumnetworks.com"
email = @gmail.get_latest_emails_from_xirrus_for_user(to_email_address).first
    # expect(email.size).to be > 0
    # expect(email.subject).to include(email_address)
    # expect(email.subject).to include("Suspicious Entitlement")
    subject = email.subject
    body = email.body
    email_content = Nokogiri::HTML(email.body.to_s,'UTF-8')
    els = email_content.css("h1")
    els.each do |el|
      puts el.text
    end
    els = email_content.css("p")
    els.each do |el|
      puts el.text
    end
    sleep 1
    
# test = gm.get_latest_emails_from_riverbed_for_user("kartik2@gmail.com")
# puts test.size
# test.each do |email|
  # puts email.subject
  # puts email.html_part ? email.html_part.body.decoded : nil
# end
# puts gm.user_received_latest_email_from_riverbed("kartik2@gmail.com")
@gmail.logout



