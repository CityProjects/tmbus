class Stop < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasEid
  include Concerns::HasNames

  attr_accessible :latitude, :longitude

  has_many :route_stops
  has_many :directions, through: :route_stops, uniq: true


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
