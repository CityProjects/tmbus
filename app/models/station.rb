class Station
  include Mongoid::Document

  field :name,    type: String

  #todo: define location lat,lng - need to check mongo geolocation support


  belongs_to  :node, class_name: 'Node'

  has_and_belongs_to_many :routes, class_name: 'Route'


  STATIONS_URL = 'http://82.77.146.19/txt/select_statie.php'


  ## validations


  ## scopes
  ####################################


  ## callbacks
  ####################################




  ## class-methods
  ####################################
  class << self

    def parse_stations_data
      # use STATIONS_URL

    end



  end

  ## instance-methods
  ####################################




end
