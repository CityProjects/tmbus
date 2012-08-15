require 'faker'
FactoryGirl.define do


  factory :station do
    raw_name "A. Saguna_1"
  end


  factory :route do
    number { "#{rand 1..40}" }
    type { Route::ROUTE_TYPE_INT_TO_SHORT_STRING_MAP.keys.sample }
    direction { [-1, 1].sample }
    ratt_updated_at { 1.hour.ago }
  end





end
