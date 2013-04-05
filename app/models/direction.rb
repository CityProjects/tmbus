class Direction < ActiveRecord::Base
  include ClassnameTagLogger

  include Concerns::HasEid


  belongs_to :route

  has_many :route_stops, order: 'route_stop_order'
  has_many :stops, through: :route_stops, order: 'route_stops.route_stop_order'

  belongs_to :first_stop, class_name: 'Stop', foreign_key: 'first_stop_id'
  belongs_to :last_stop, class_name: 'Stop', foreign_key: 'last_stop_id'


  ## validations



  ## scopes
  ####################################


  ## callbacks
  ####################################

  before_validation

  ## class_methods
  ####################################



  ## instance_methods
  ####################################


end
