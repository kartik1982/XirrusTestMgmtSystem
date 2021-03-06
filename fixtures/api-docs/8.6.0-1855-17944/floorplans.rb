module XMS 
   module NG 
      class ApiClient 
# POST - Duplicate Building
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @return [XMS::NG::ApiClient::Response]
def duplicate_building(args = {}) 
 post("/floorplans.json/building/#{args[:buildingId]}", args)
end 

# GET - Get Building
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_building(args = {}) 
 get("/floorplans.json/building/#{args[:buildingId]}", args)
end 

# PUT - Update Building
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @custom args [String] :NONAME body BuildingDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_building(args = {}) 
 put("/floorplans.json/building/#{args[:buildingId]}", args)
end 

# GET - Get heat
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_heat(args = {}) 
 get("/floorplans.json/#{args[:floorplanId]}/heat", args)
end 

# PUT - Update Floorplans
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @custom args [String] :NONAME body List[FloorplanDto] *required 
# @return [XMS::NG::ApiClient::Response]
def update_floorplans(args = {}) 
 put("/floorplans.json/#{args[:buildingId]}", args)
end 

# POST - Add Floorplan
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @custom args [String] :NONAME body List[FloorplanDto] *required 
# @return [XMS::NG::ApiClient::Response]
def add_floorplan(args = {}) 
 post("/floorplans.json/#{args[:buildingId]}", args)
end 

# POST - Duplicate Floorplan
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def duplicate_floorplan(args = {}) 
 post("/floorplans.json/#{args[:floorplanId]}/duplicate", args)
end 

# PUT - Set or Update Arrays for Floorplan
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @custom args [String] :NONAME body List[FloorplanArrayDto] *required 
# @return [XMS::NG::ApiClient::Response]
def set_or_update_arrays_for_floorplan(args = {}) 
 put("/floorplans.json/#{args[:floorplanId]}/arrays", args)
end 

# GET - List Arrays for Floorplan
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def list_arrays_for_floorplan(args = {}) 
 get("/floorplans.json/#{args[:floorplanId]}/arrays", args)
end 

# PUT - Order Floorplans
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[FloorplanDto]  
# @return [XMS::NG::ApiClient::Response]
def order_floorplans(args = {}) 
 put("/floorplans.json/orderFloors", args)
end 

# GET - List Floorplans for Building
#
# @param args [Hash] 
# @custom args [String] :buildingId path string *required 
# @return [XMS::NG::ApiClient::Response]
def list_floorplans_for_building(args = {}) 
 get("/floorplans.json/#{args[:buildingId]}/floors", args)
end 

# GET - List Buildings
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name", "floorCount"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_buildings(args = {}) 
 get("/floorplans.json/building", args)
end 

# POST - Add Building
#
# @param args [Hash] 
# @custom args [String] :NONAME body BuildingDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_building(args = {}) 
 post("/floorplans.json/building", args)
end 

# DELETE - Delete Building
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def delete_building(args = {}) 
  body_delete("/floorplans.json/building", args[:array_of_ids])
end 

# GET - Get Floorplan
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_floorplan(args = {}) 
 get("/floorplans.json/#{args[:floorplanId]}", args)
end 

# DELETE - Delete Floorplan
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def delete_floorplan(args = {}) 
  body_delete("/floorplans.json/", args[:array_of_ids])
end 

# GET - List Arrays
#
# @return [XMS::NG::ApiClient::Response]
def list_arrays 
 get("/floorplans.json/arrays")
end 


       end 
   end 
  end