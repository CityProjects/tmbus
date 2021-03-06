json.(route_stop, :direction, :order_idx, :route_id, :stop_id)
json.__route_stop_id route_stop.id

if defined?(with)
  if with == :route
    json.route do |json|
      json.partial! 'api/v1/route', route: route_stop.route
    end
  elsif with == :stop
    json.partial! 'api/v1/stop', stop: route_stop.stop
  end
end
