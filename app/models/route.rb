class Route < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasExternalRefs

  attr_accessible :name
  attr_accessible :vehicle_type
  attr_accessible :direction0_name, :direction1_name

  has_many :route_stops, order: 'route_stops.direction, route_stops.order_idx'
  has_many :stops, through: :route_stops, order: 'route_stops.direction, route_stops.order_idx'





  ## validations



  ## scopes
  ####################################


  ## callbacks
  ####################################


  ## class_methods
  ####################################



  ## instance_methods
  ####################################


  def vehicle_type_name
    return Vehicle::VEHICLE_TYPES_NAMES[self.vehicle_type]
  end


  def direction_name(idx)
    name = (idx == 0 ? self.direction0_name : self.direction1_name)
    if name.blank?
      rs = self.route_stops.where(direction: idx).order('order_idx DESC').first
      stop = rs.stop if rs
      name = (stop.name.try(:strip).presence || stop.ename) if stop
    end
    name = "Dir##{idx}" if name.blank?
    return name
  end




end
