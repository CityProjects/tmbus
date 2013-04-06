class RattDataCollector
  STOPS_URL = "http://82.77.146.19/txt/select_statie.php"
  ROUTES_URL = "http://82.77.146.19/txt/select_traseu.php?id_statie="

  def collect_data
    doc = Nokogiri::HTML(Net::HTTP.get URI.parse(STOPS_URL))
    doc.css("select > option").each do |node|
      Stop.where('eid = ?', node['value']).first_or_create!(name: node.content, eid: node['value'])
    end

    Stop.find_each do |stop|
      doc = Nokogiri::HTML(Net::HTTP.get URI.parse(ROUTES_URL + stop.eid.to_s))
      doc.css("select > option").each do |node|
        name = node.content.gsub(/\[\d\]/, '').strip
        direction = node.content[1] == '0' ? 0 : 1
        route = Route.where('eid = ?', node['value']).first_or_create!(name: name, eid: node['value'])
        RouteStop.where('route_id = ? AND stop_id = ? AND direction = ?', route.id, stop.id, direction).first_or_create! do |rs|
          rs.route_id = route.id
          rs.stop_id = stop.id
          rs.direction = direction
        end
      end
    end
  end



  #def collect_places
  #  routes = []
  #  (1..4).each do |t|
  #    doc = Nokogiri::HTML(Net::HTTP.get URI.parse("http://www.ratt.ro/statii#{t}.html"))
  #    routes_string = ""
  #    doc.css('#centerContentContainer div a ~ div div[style] div[style*="text-align:center"] > span').each do |node|
  #      routes_string += node.content.gsub(/\r/, '') + "\n"
  #    end
  #    routes_string = routes_string.gsub(/ \n/, "\n").gsub(/\n+/, "\n")
  #    current_route = nil
  #    routes_string.split(/\n/).each do |station|
  #      if station =~ /^((M\s\d+)|(LINIA\s\d+)|(Expres\s\d+))/
  #        current_route = { name: station, stations: [] }
  #        routes << current_route
  #
  #        puts "ROUTE: #{t} - #{station}"
  #
  #      elsif station =~ /^SENS\s/
  #        current_route[:name] = "#{current_route[:name]} - #{station}"
  #
  #      else
  #        current_route[:stations] << station
  #
  #        Place.where(name: station).first_or_create!
  #      end
  #    end
  #  end
  #  routes
  #end
end
