json.(route_stop, :id, :direction, :order_idx, :route_id, :stop_id)

if defined?(with)
  if with == :route
    json.partial! 'api/v1/route', route: route_stop.route
  elsif with == :stop
    json.partial! 'api/v1/stop', stop: route_stop.stop
  end
end
