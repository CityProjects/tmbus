# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130404100003) do

  create_table "route_stops", :force => true do |t|
    t.integer  "order_idx"
    t.integer  "direction",  :null => false
    t.integer  "route_id"
    t.integer  "stop_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "route_stops", ["direction"], :name => "index_route_stops_on_direction"
  add_index "route_stops", ["order_idx"], :name => "index_route_stops_on_order_idx"
  add_index "route_stops", ["route_id", "direction", "order_idx"], :name => "route_direction_order_uniq", :unique => true
  add_index "route_stops", ["route_id", "stop_id", "direction"], :name => "route_stop_direction_uniq", :unique => true
  add_index "route_stops", ["route_id"], :name => "index_route_stops_on_route_id"
  add_index "route_stops", ["stop_id"], :name => "index_route_stops_on_stop_id"

  create_table "routes", :force => true do |t|
    t.string   "eid"
    t.string   "ename"
    t.string   "tag"
    t.string   "name"
    t.string   "direction0_name"
    t.string   "direction1_name"
    t.integer  "vehicle_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "routes", ["eid"], :name => "index_routes_on_eid", :unique => true
  add_index "routes", ["tag"], :name => "index_routes_on_tag", :unique => true
  add_index "routes", ["vehicle_type"], :name => "index_routes_on_vehicle_type"

  create_table "stops", :force => true do |t|
    t.string   "eid"
    t.string   "ename"
    t.string   "tag"
    t.string   "name"
    t.string   "alternate_names"
    t.string   "allowed_vehicles"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "stops", ["allowed_vehicles"], :name => "index_stops_on_allowed_vehicles"
  add_index "stops", ["alternate_names"], :name => "index_stops_on_alternate_names"
  add_index "stops", ["eid"], :name => "index_stops_on_eid", :unique => true
  add_index "stops", ["name"], :name => "index_stops_on_name"
  add_index "stops", ["tag"], :name => "index_stops_on_tag", :unique => true

end
