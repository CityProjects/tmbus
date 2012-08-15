class Route
  include Mongoid::Document

  field :name,    type: String


  has_and_belongs_to_many :stations, class_name: 'Station'




  ## validations


  ## scopes
  ####################################


  ## callbacks
  ####################################




  ## class-methods
  ####################################
  class << self



  end

  ## instance-methods
  ####################################







end
