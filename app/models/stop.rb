class Stop < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasExternalRefs

  attr_accessible :name
  attr_accessible :latitude, :longitude
  attr_accessible :allowed_vehicles

  has_many :route_stops
  has_many :routes, through: :route_stops, uniq: true


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
