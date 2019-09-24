require 'rest-client'
require 'json'

module API
  class SalesforceApi
    attr_accessor :token
    REFRESH_TOKEN = "5Aep861yCOjWzSFTnNd5rdzQINclGUbtu25TGFpaSwOBsh9uJplQ.FWQ0mzqgIY7d3Enhqp4ZLbAeNZbFtUmwGQ"
    HOST = 'https://cs13.salesforce.com/services/' #apexrest/
    def initialize(args ={})
      @username = args[:username]
      @password = args[:password]
      @token = refresh_token
    end

    def token
      @token
    end
   
    def get(endpoint,params={})
      path = "#{HOST}#{endpoint}"
      unless params.empty?
        path += "?#{XMS.build_query(params)}"
      end
      res = ""
      begin
        res = RestClient.get( path , :authorization => "OAuth #{token}",
          :format => :json,
          :content_type => :json,
          :accept => :json
        ) # RestClient Post
      rescue => e
        res += "ERROR: #{e.message}"
      end
      #puts "make_request res : #{res}"
      res
    end # GET

    def post(endpoint,params)
      path = "#{HOST}#{endpoint}"
      res = ""
      begin
        res = RestClient.post( path , params.to_json , :authorization => "OAuth #{token}",
          :format => :json,
          :content_type => :json,
          :accept => :json
        ) # RestClient Post
      rescue => e
        res += "ERROR: #{e.message}"
      end
      res
    end # POST

    def update(endpoint,params)
      path = "#{HOST}#{endpoint}"
      res = ""
      begin
        res = RestClient.patch( path , params.to_json , :authorization => "OAuth #{token}",
          :format => :json,
          :content_type => :json,
          :accept => :json
        ) # RestClient Post
      rescue => e
        res += "ERROR: #{e.message}"
      end
      res
    end # UPDATE

    def delete(endpoint, params)
      path = "#{HOST}#{endpoint}"
      unless params.empty?
      path += "?#{XMS.build_query(params)}"
      end
      res = ""
      begin
        res = RestClient.delete( path ,:authorization => "OAuth #{token}",
          :format => :json,
          :content_type => :json,
          :accept => :json
        ) # RestClient Post
      rescue => e
        res += "ERROR: #{e.message}"
      end
      res
    end

   private

   def refresh_token
     res = ""
     begin
       res = RestClient.post("https://cs13.salesforce.com/services/oauth2/token", {
         grant_type: "password",
         client_id: "3MVG982oBBDdwyHiUabiYHRbjd22aIQLUaX6gYOjgctgatwmo_L4F9UsxWmXVqBaJU6.5kYDeMIezwlGnKjHv",
         client_secret: "1614004529141118473",
         username: "armen.zakaryan@xirrus.com",
         password: "Victory151Y0ZaIGWal6eQfx3vhms6k1sv"
       }, :accept => :json )
       token = JSON.parse(res.body)["access_token"]
     rescue => e 
       puts e.backtrace
       token = "ERROR: #{e.message}"
     end
     token
   end

  end # SalesforceApiClient
end # API