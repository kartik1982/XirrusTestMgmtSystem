require 'rest-client'
require 'json'

module API
  class LogstashApi
    
    attr_accessor :env, :base_url

    def initialize(args = {})
      @env = args[:env]
      @base_url = "http://logstash-#{@env}.cloud.xirrus.com/elasticsearch"
    end


    def search_for_today(filters)
      @current_date = (Time.now  - (3600 * 24) * 0 ).strftime("%Y.%m.%d")
      send_request(@base_url + "/filebeat-#{@current_date}/_search?q=#{make_query(filters)}")
    end

    def search(filters, max_logs)
      send_request(@base_url + "/filebeat-*/_search?size=#{max_logs}&q=#{make_query(filters)}")
    end

    def get_current_server_time
      Time.now.getlocal("+00:00").strftime("%Y-%m-%dT%H:%M:%S")
    end

    def get_server_time_offset(offset)
      hours = offset[:hours] || 0
      minutes = offset[:minutes] || 0
      (Time.now.getlocal("+00:00") - (hours*3600 + minutes*60)).strftime("%Y-%m-%dT%H:%M:%S")
    end

    private

    def send_request(path)
      begin
        response = RestClient.get(path, :format => :json, :content_type => :json, :accept => :json)
        response_json = JSON.parse(response)
        data = response_json["hits"]["hits"]
        puts JSON.pretty_generate(data)
        data
      rescue => e
        puts "TODO Handle this in a better way"
        raise e
      end
    end

    def make_query(filters)
      query = ""
      filters.each_with_index do |val, index|
        res = index+1 < filters.length ? "#{val} AND " : "#{ val}"
        query << res
      end
      query
    end

  end # LogstashApi
end # API


##########################
##########################
### EXAMPLES MAY NEED ####
##########################
#from = @logstash.get_server_time_offset({minutes: 15})
#filters = ["preserve-ip-settings", @array.serial, "@timestamp: [#{@start_time} TO #{to}]"]