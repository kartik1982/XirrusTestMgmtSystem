require_relative 'api/gmail_api/gmail_api.rb'

gm = API::GmailApi.new(args={})
test = gm.get_latest_emails_from_riverbed_for_user("kartik2@gmail.com")
puts test.size
test.each do |email|
  puts email.subject
  puts email.html_part ? email.html_part.body.decoded : nil
end
puts gm.user_received_latest_email_from_riverbed("kartik2@gmail.com")
gm.logout



