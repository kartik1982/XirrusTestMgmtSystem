require 'rest-client'
require 'json'
require_relative 'resource/accounts.rb'
require_relative 'resource/arrays.rb'

module API
  class SfdcApi
    include Arrays
    include Accounts
    
    attr_accessor :token, :username, :password
    REFRESH_TOKEN = "5Aep861yCOjWzSFTnNd5rdzQINclGUbtu25TGFpaSwOBsh9uJplQ.FWQ0mzqgIY7d3Enhqp4ZLbAeNZbFtUmwGQ"
    HOST = 'https://cs13.salesforce.com/services/' #apexrest/
    def initialize(args ={})
      @username = args[:username] || "armen.zakaryan@xirrus.com"
      @password = args[:password] || "Victory151Y0ZaIGWal6eQfx3vhms6k1sv"
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
      path += "?#{build_query(params)}"
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
    def build_query(params = {})
      res = ""
      params.each { |key,val|
        if val.kind_of?(Array)
          val.each {|v|
            res << "#{key}=#{v}&"
          }
        else
          res << "#{key}=#{val}&"
        end
      }
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
         username: @username,
         password: @password
       }, :accept => :json )
       token = JSON.parse(res.body)["access_token"]
     rescue => e 
       puts e.backtrace
       token = "ERROR: #{e.message}"
     end
     token
   end
  end # SfdcApi
end # API