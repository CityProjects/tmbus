class Station
  include Mongoid::Document
  include Mongoid::Geospatial
  include Extras::Finders

  field :_id,       type: String
  field :name,      type: String
  field :raw_name,  type: String

  field :geoloc,    type: Point, spatial: true
  spatial_index :geoloc


  #todo: define location lat,lng - need to check mongo geolocation support


  belongs_to  :junction, class_name: 'Junction'

  has_and_belongs_to_many :routes, class_name: 'Route'


  has_and_belongs_to_many :junction_stations, class_name: 'Station'



  STATIONS_URL = 'http://82.77.146.19/txt/select_statie.php'
  STATIONS_GEOLOCATIONS_URL = 'http://www.ratt.ro/harta/source/stations.xml'

  ## validations

  validates :raw_name, presence: true



  ## scopes
  ####################################


  ## callbacks
  ####################################




  ## class-methods
  ####################################
  class << self

    def update_stations_data
      parse_stations_data_html(get_stations_data_html)
    end


    def get_stations_data_html
      # get data from STATIONS_URL
      Nokogiri::HTML(Net::HTTP.get URI.parse(STATIONS_URL))
    end


    # @param [Nokogiri::HTML::Document] stations_data_html
    def parse_stations_data_html(stations_data_html)
      # for each station found
      #   create station = Station.new(data)
      #   save in DB:  station.save!

      stations_option_tag = stations_data_html.css("option")
      stations_option_tag.each do |line|
        station_id = line['value'].to_s
        station = find_by_id(station_id) || Station.new
        station.id = station_id
        station.raw_name = line.text
        station.save!
      end

    end

  end

end
