require "rubygems"
require "nokogiri"
require "open-uri"

class Ratt::DataParser

  STATIONS    = "http://82.77.146.19/txt/select_statie.php"
  ROUTES      = "http://82.77.146.19/txt/select_traseu.php?id_statie="
  TEMP_FILE1  = "app/models/ratt/stations.txt"
  TEMP_FILE2  = "app/models/ratt/routes.txt"

  def self.parse
    station_file = File.open(TEMP_FILE1, "w")

    id = []
    if File.exists?(TEMP_FILE1) && File.file?(TEMP_FILE1)
      station_page = Nokogiri::HTML(open(STATIONS))
      station_option_tag = station_page.css("option")
      station_option_tag.each do |line|
        station_file.puts line['value'].to_s + " => " + line.text
        id += [ line['value'].to_i ]
      end
    station_file.close
    end

    route_file = File.open(TEMP_FILE2, "w")

    if File.exists?(TEMP_FILE2) && File.file?(TEMP_FILE2)
      id.each do |i|
        new_id = ROUTES + i.to_s
        #puts new_id
        route_page = Nokogiri::HTML(open(new_id))
        route_option_tag  = route_page.css("option")
        route_option_tag.each do |line|
          route_file.puts "Route id: " + i.to_s + " with transport vehicle id " + line['value'].to_s + " => " + line.text
        end
        route_file.puts "\n"
      end
      route_file.close
    end
  end
end
