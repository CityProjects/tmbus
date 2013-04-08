json.partial! 'api/v1/route', route: @route

json.stops @route.route_stops do |json, route_stop|
  json.partial! 'api/v1/route_stop', route_stop: route_stop, with: :stop
end
