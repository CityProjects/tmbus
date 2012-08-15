class BusStop
  include Mongoid::Document


  has_and_belongs_to_many :bus_station_node, class_name: 'BusNode'



  def self.parse_bus_stops_geo_locations

  end

end