# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :route_stop_info do
    route_id 1
    route_stop_id 1
    route_stop_order 1
    arrival_time1_value "2013-04-04 14:18:49"
    arrival_time1_type 1
    arrival_time2_value "2013-04-04 14:18:49"
    arrival_time2_type 1
  end
end
