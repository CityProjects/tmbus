class Route < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasEid
  include Concerns::HasNames

  attr_accessible :vehicle_type

  has_many :route_stops, order: 'route_stops.direction, route_stops.route_stop_order'
  has_many :stops, through: :route_stops, order: 'route_stops.direction, route_stops.route_stop_order'

  belongs_to :stop1, class_name: 'Stop', foreign_key: 'stop1_id'
  belongs_to :stop2, class_name: 'Stop', foreign_key: 'stop2_id'



  ## validations



  ## scopes
  ####################################


  ## callbacks
  ####################################


  ## class_methods
  ####################################



  ## instance_methods
  ####################################


end
