class RouteStop < ActiveRecord::Base
  include ClassnameTagLogger

  attr_accessible :route_stop_order
  attr_accessible :direction

  belongs_to :route
  belongs_to :stop


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
