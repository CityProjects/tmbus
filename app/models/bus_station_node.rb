class BusStationNode
  include Mongoid::Document

  has_and_belongs_to_many :bus_stations, class_name: 'BusStation', inverse_of: :bus_station_node

end