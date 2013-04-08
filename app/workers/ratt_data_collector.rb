class RattDataCollector
  include ClassnameTagLogger

  STOPS_URL = "http://82.77.146.19/txt/select_statie.php"
  ROUTES_URL = "http://82.77.146.19/txt/select_traseu.php?id_statie="
  ARRIVAL_TIMES_URL = "http://82.77.146.19/txt/afis_msg.php?id_traseu="

  THREAD_COUNT = 6

  def collect_stops_data
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(STOPS_URL)))
    doc.css("select > option").each do |node|
      stop_eid = node['value']
      stop_name = node.content.strip
      stop = Stop.where('eid = ?', stop_eid).first
      if stop.nil?
        Stop.create!(name: stop_name, eid: stop_eid)
        #TODO: nofify admin of new data
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

          rt = Route.where('eid = ?', route_eid).first
          if rt.nil?
            rt = Route.create!(name: route_name, eid: route_eid)
            #TODO: nofify admin of new data
          end

          rs = RouteStop.where('route_id = ? AND stop_id = ? AND direction = ?', rt.id, stop_id, direction).first
          if rs.nil?
            rs = RouteStop.new
            rs.route_id = rt.id
            rs.stop_id = stop_id
            rs.direction = direction
            rs.save!
            #TODO: nofify admin of new data
          end
        end
      end

    end

    logger.debug("collect_routes_data - time: #{Time.now - time0}")
  end





  def collect_arrival_times


  end







  private



  def scrape_routes_for_stop(stop_eid)
    logger.debug("-> scrape_routes_for_stop(#{stop_eid})")
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(ROUTES_URL + stop_eid.to_s)))
    routes = []
    doc.css("select > option").each do |node|
      route_name = node.content.gsub(/\[\d\]/, '').strip
      route_eid = node['value']
      direction = node.content[1] == '0' ? 0 : 1
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
