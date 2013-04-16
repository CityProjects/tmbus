json.partial! 'api/v1/route', route: @route

json.directions((0..1)) do |direction|

  json.name "Dir #{direction}"

  json.stops @route.route_stops.where(direction: direction) do |json, route_stop|
    json.partial! 'api/v1/route_stop', route_stop: route_stop, with: :stop
  end

end
