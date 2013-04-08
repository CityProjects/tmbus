class RattDataCollector
  include ClassnameTagLogger

  STOPS_URL = 'http://82.77.146.19/txt/select_statie.php'
  ROUTES_URL = 'http://82.77.146.19/txt/select_traseu.php?id_statie='
  ARRIVAL_TIMES_URL = 'http://82.77.146.19/txt/afis_msg.php?id_traseu='
  GSPREADSHEET_URL = 'https://spreadsheets.google.com/spreadsheet/pub?key=0AtCtEmR70abcdG5ZaWRpRnI5dTFlUXN3U3Y0c0N2Wmc&gid=5'

  THREAD_COUNT = 6

  def collect_stops_data
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(STOPS_URL)))
    doc.css('select > option').each do |node|
      stop_eid = node['value']
      stop_name = node.content.strip
      stop = Stop.where('eid = ?', stop_eid).first
      if stop.nil?
        Stop.create!(eid: stop_eid, ename: stop_name)
        #TODO: nofify admin of new data
      else
        stop.update_attributes!(ename: stop_name)
      end
    end
  end



  def collect_routes_data
    time0 = Time.now

    Stop.find_in_batches(batch_size: THREAD_COUNT) do |stops|

      threads = []
      routes_by_stop = {}
      mutex = Mutex.new

      stops.each do |stop|
        threads << Thread.new(stop.id, stop.eid) do |stop_id, stop_eid|
          scraped_data = scrape_routes_for_stop(stop_eid)
          mutex.synchronize do
            routes_by_stop[stop_id] = scraped_data
          end
        end
      end

      threads.each {|t| t.join }

      routes_by_stop.each do |stop_id, routes|
        routes.each do |route|
          route_name = route[:name]
          route_eid = route[:eid]
          direction = route[:direction]
          vehicle_type = case
            when route_name =~ /^\d+/
              Vehicle::VEHICLE_TYPE_BUS
            when route_name =~ /^Tb/
              Vehicle::VEHICLE_TYPE_TROLLEY
            when route_name =~ /^E/
              Vehicle::VEHICLE_TYPE_EXPRESS
            when route_name =~ /^M/
              Vehicle::VEHICLE_TYPE_METRO
            when route_name =~ /^Tv/
              Vehicle::VEHICLE_TYPE_TRAM
          end
          puts "vehicle: #{vehicle_type}"

          rt = Route.where('eid = ?', route_eid).first
          if rt.nil?
            rt = Route.create!(name: route_name, eid: route_eid, ename: route_name)
            #TODO: nofify admin of new data
          else
            rt.update_attributes!(ename: route_name, vehicle_type: vehicle_type)
          end

          rs = RouteStop.where('route_id = ? AND stop_id = ?', rt.id, stop_id).first
          if rs.nil?
            rs = RouteStop.new
            rs.route_id = rt.id
            rs.stop_id = stop_id
            rs.direction = direction
            rs.save!
            #TODO: nofify admin of new data
          else
            rs.update_attributes!(direction: direction)
          end
        end
      end

    end

    logger.debug("collect_routes_data - time: #{Time.now - time0}")
  end





  def collect_arrival_times


  end





  def collect_from_gspreadsheet
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(GSPREADSHEET_URL)))
    order_idx = 0
    doc.css('#content table#tblMain tr').each do |tr_node|
      if tr_node.children[1].content =~ /^\d+/
        route_eid = tr_node.children[1].content.strip
        stop_eid = tr_node.children[3].content.strip
        stop_name = tr_node.children[6].content.strip
        stop_long_name = tr_node.children[5].content.gsub(/\(.+\)/, '').strip
        stop_lat = tr_node.children[8].content.strip
        stop_lng = tr_node.children[9].content.strip

        stop = Stop.where('eid = ?', stop_eid).first
        if stop
          stop.update_attributes!(name: stop_name, long_name: stop_long_name, latitude: stop_lat, longitude: stop_lng)
          logger.debug("updated Stop #{stop}")

          route = Route.where('eid = ?', route_eid).first
          if route
            rs = stop.route_stops.where('route_id = ?', route.id).first
            if rs
              rs.update_attributes!(order_idx: order_idx)
              logger.debug("updated RouteStop #{rs}")
              order_idx += 1
            end
          end
        end

      else # not a 'Stop' row
        order_idx = 0
      end
    end
  end






  private



  def scrape_routes_for_stop(stop_eid)
    logger.debug("-> scrape_routes_for_stop(#{stop_eid})")
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(ROUTES_URL + stop_eid.to_s)))
    routes = []
    doc.css("select > option").each do |node|
      route_name = node.content.strip.gsub(/\[\d\]/, '').strip
      route_eid = node['value']
      direction = node.content.strip[1] == '0' ? 0 : 1
      routes << { eid: route_eid, name: route_name, direction: direction}
    end
    return routes
  end




  def scrape_arrival_times(route_eid, stop_eid)
    arrival_times_url = ARRIVAL_TIMES_URL + route_eid.to_s + "&id_statie=" + stop_eid.to_s
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(arrival_times_url)))
    content = doc.css('br + br + font').first.content
    parts = content.match(/Sosire1:\s+(.+)Sosire2:\s+(.+)/)
    return [parts[1].strip, parts[2].strip]
  end








#def collect_places
#  routes = []
#  (1..4).each do |t|
#    doc = Nokogiri::HTML(Net::HTTP.get URI.parse("http://82.77.146.19/statii#{t}.html"))
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
