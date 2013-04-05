class RattDataCollector

  def collect_places
    routes = []

    (1..4).each do |t|
      doc = Nokogiri::HTML(Net::HTTP.get URI.parse("http://www.ratt.ro/statii#{t}.html"))

      routes_string = ""
      doc.css('#centerContentContainer div a ~ div div[style] div[style*="text-align:center"] > span').each do |node|
        routes_string += node.content.gsub(/\r/, '') + "\n"
      end

      routes_string = routes_string.gsub(/ \n/, "\n").gsub(/\n+/, "\n")


      current_route = nil
      routes_string.split(/\n/).each do |station|
        if station =~ /^((M\s\d+)|(LINIA\s\d+)|(Expres\s\d+))/
          current_route = { name: station, stations: [] }
          routes << current_route

          puts "ROUTE: #{t} - #{station}"

        elsif station =~ /^SENS\s/
          current_route[:name] = "#{current_route[:name]} - #{station}"

        else
          current_route[:stations] << station

          Place.where(name: station).first_or_create!
        end
      end

    end
    routes
  end



end
