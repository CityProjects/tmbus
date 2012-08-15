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

    def get_stations_data_html
      # get data from STATIONS_URL
    end


    def parse_stations_data_html(stations_data_html)
      # for each station found
      #   create station = Station.new(data)
      #   save in DB:  station.save!

    end



  end

  ## instance-methods
  ####################################




end
