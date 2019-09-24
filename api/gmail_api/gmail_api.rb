require 'gmail'
require_relative 'resource/xirrus_emails.rb'
require_relative 'resource/riverbed_emails.rb'

# Monkey Patch
# https://github.com/gmailgem/gmail/issues/228
class Object
  def to_imap_date
    date = respond_to?(:utc) ? utc.to_s : to_s
    Date.parse(date).strftime('%d-%b-%Y')
  end
end

module API
  class GmailApi
    include XirrusEmails
    include RiverbedEmails
    
    attr_accessor :gmail
    def initialize(args = {})
      begin
        @gmail_user = args[:gmail_user] || "xirrusms@gmail.com"
        @gmail_password = args[:gmail_password] || "Xirrus!234" 
        @gmail = Gmail.new(@gmail_user, @gmail_password)
      rescue => e
        puts e
        e.response
      end      
    end
    
    def get_latest_email_for_user(user, from_user , to_user)
      search_include = user
      gmails = @gmail.inbox.emails(:unread, :gm => "To/: #{search_include}", :from => from_user, :to => to_user, :after => Date.parse(DateTime.now.strftime("%Y-%m-%d")))
    end 

    def gmail_today_from_user(from_user)
      today = DateTime.now
      today_str = today.strftime("%Y-%m-%d")
      gmails = @gmail.inbox.emails(:from => from_user, :after => Date.parse(today_str))
    end
    
    def gmail_today()
      today = DateTime.now
      today_str = today.strftime("%Y-%m-%d")
      gmails = @gmail.inbox.emails(:after => Date.parse(today_str))
    end
    
    def logout
      @gmail.logout
    end
  end #Class GmailApi
end #module API