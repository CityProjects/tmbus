# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do

  factory :route do

    name "Bus 40"
    vehicle_type Vehicle::VEHICLE_TYPE_BUS

  end


end
