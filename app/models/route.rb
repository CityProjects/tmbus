class Route < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasEid
  include Concerns::HasNames

  attr_accessible :vehicle_type


  has_many :directions

  #has_many :route_stops, dependent: :destroy, order: 'stop_order'
  #has_many :stops, through: :route_stops
  #
  #belongs_to :from_stop, class_name: 'Stop'
  #belongs_to :to_stop,


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
