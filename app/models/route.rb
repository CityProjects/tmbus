class Route
  include Mongoid::Document

  field :_id,                type: String
  field :transport_type,     type: Integer  # 11:bus, 12:troleibuz, 13:expres, 14:metropolitan, 14:P*, 21:tramvai
  field :transport_name,     type: String
  field :direction,          type: Integer # 1=tur, -1=retur

  has_and_belongs_to_many :stations, class_name: 'Station'


  ROUTES_URL = 'http://82.77.146.19/txt/select_traseu.php?id_statie='


  TRANSPORT_TYPE_STRING_TO_INT_MAP = { '' => 11, 'Tb' => 12, 'E' => 13, 'M' => 14, 'P' => 15, 'Tv' => 21 }


  ## validations

  validates :transport_type, inclusion: { in: TRANSPORT_TYPE_STRING_TO_INT_MAP.values }


  ## scopes
  ####################################


  ## callbacks
  ####################################




  ## class-methods
  ####################################
  class << self

    def update_routes_data
      Station.each do |station|
        parse_routes_data_html(station, get_routes_data_html(station.id))
      end
    end

    def get_routes_data_html(station_id)
      #get data from ROUTES_URL
      new_url = ROUTES_URL + station_id.to_s
      Nokogiri::HTML(Net::HTTP.get URI.parse(new_url))
    end



    def parse_routes_data_html(station, routes_data_html)

      route_option_tag = routes_data_html.css("option")
      route_option_tag.each do |line|
        route = station.routes.build()
        route.id = line['value'].to_s

        route_parts = line.text.strip.match(/\[(\d)\]\s+(\D*)([0-9a-z\-]*)/i)
        route.direction = ( route_parts[1] == '0' ? 1 : -1 )
        route.transport_type = TRANSPORT_TYPE_STRING_TO_INT_MAP[ route_parts[2] ]
        route.transport_name = route_parts[3]

        route.save!
      end



    end

  end

  ## instance-methods
  ####################################





  def friendly_type_name(short = true)
    case self.transport_type
      when 11
        return short ? "" : "Autobuz"
      when 12
        return short ? "Tb" : "Troleibuz"



      else
        "unknown"
    end
  end



end
