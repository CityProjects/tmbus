class Node
  include Mongoid::Document

  field :name,    type: String

  #todo: define location lat,lng, radius?


  has_many :stations, class_name: 'Station'



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
