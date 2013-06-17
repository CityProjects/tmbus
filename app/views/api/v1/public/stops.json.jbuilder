json.array! @stops do |stop|
  json.partial! 'api/v1/stop', stop: stop
end
