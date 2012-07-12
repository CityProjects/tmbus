require "rubygems"
require "nokogiri"
require "open-uri"

class Ratt::DataParser

  STATIONS = "http://82.77.146.19/txt/select_statie.php"
  TEMP_FILE = "app/models/ratt/temp.txt"

  def self.parse_stations
    f = File.open(TEMP_FILE, "w")
    if File.exists?(TEMP_FILE) || File.file?(TEMP_FILE)
      page = Nokogiri::HTML(open(STATIONS))
      id = page.css("option")
      id.each do |i|
        f.puts i['value'].to_s + "  =>  " + i.text
      end
    f.close
    end
  end

  def self.parse_routes

  end
end
