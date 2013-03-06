class Route
  include Mongoid::Document
  include Mongoid::Timestamps

  include Extras::Finders

  field :_id,                type: String
  field :type,               type: Integer  # 11:bus, 12:troleibuz, 13:expres, 14:metropolitan, 14:P*, 21:tramvai
  field :number,             type: String
  field :direction,          type: Integer # 1=tur, -1=retur

  field :ratt_updated_at,    type: Time

  has_and_belongs_to_many :stations, class_name: 'Station'


  ROUTES_URL = 'http://82.77.146.19/txt/select_traseu.php?id_statie='


  ROUTE_TYPE_STRING_TO_INT_MAP = { '' => 11, 'Tb' => 12, 'E' => 13, 'M' => 14, 'P' => 15, 'Tv' => 21 }
  ROUTE_TYPE_INT_TO_SHORT_STRING_MAP = { 11 => '', 12 => 'Tb', 13 => 'E', 14 => 'M', 15 => 'P', 21 => 'Tv' }
  ROUTE_TYPE_INT_TO_LONG_STRING_MAP = { 11 => 'Autobuz', 12 => 'Troleibuz' } #todo.. needed??


  ## validations

  validates :type, presence: true, inclusion: { in: ROUTE_TYPE_STRING_TO_INT_MAP.values }
  validates :number, presence: true
  validates :direction, presence: true, inclusion: { in: [ 1, -1 ] }

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
        route_id = line['value'].to_s
        route = find_by_id(route_id) || station.routes.build()
        route.id = route_id

        route_parts = line.text.strip.match(/\[(\d)\]\s+(\D*)([0-9a-z\-]*)/i)
        route.direction = ( route_parts[1] == '0' ? 1 : -1 )
        route.type = ROUTE_TYPE_STRING_TO_INT_MAP[ route_parts[2] ]
        route.number = route_parts[3]

        route.ratt_updated_at = Time.zone.now

        route.save!
      end

    end



    def clean_outdated_routes(days_old = 5)
      Route.or( { :ratt_updated_at.lt => days_old.days.ago }, { :ratt_updated_at => nil} ).delete
    end

  end

  ## instance-methods
  ####################################





  def name(short = true)
    "#{ROUTE_TYPE_INT_TO_SHORT_STRING_MAP[self.type]}#{self.number}(#{self.direction})"
  end



end
