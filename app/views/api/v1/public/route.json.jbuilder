json.partial! 'api/v1/route', route: @route

json.directions do |json|

  (0..1).each do |direction|

    json.set! direction do |json|
      json.name "Dir #{direction}"

      json.stops @route.route_stops.where(direction: direction) do |json, route_stop|
        json.partial! 'api/v1/route_stop', route_stop: route_stop, with: :stop
      end
    end

  end
end

