class RouteStop < ActiveRecord::Base
  include ClassnameTagLogger

  attr_accessible :order_idx
  attr_accessible :direction

  belongs_to :route
  belongs_to :stop


  ## validations

  validates :direction, presence: true, inclusion: { in: [0, 1] }

  validates_presence_of :route_id
  validates_presence_of :stop_id



  ## scopes
  ####################################


  ## callbacks
  ####################################


  ## class_methods
  ####################################



  ## instance_methods
  ####################################




end
