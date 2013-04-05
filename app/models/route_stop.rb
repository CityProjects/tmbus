class RouteStop < ActiveRecord::Base
  include ClassnameTagLogger

  attr_accessible :route_stop_order

  belongs_to :direction
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
