class BusStation
  include Mongoid::Document


  has_and_belongs_to_many :bus_station_node, class_name: 'BusStationNode'

end