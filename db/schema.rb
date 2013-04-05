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

ActiveRecord::Schema.define(:version => 20130404100004) do

  create_table "directions", :force => true do |t|
    t.string   "eid"
    t.string   "tag"
    t.integer  "first_stop_id"
    t.integer  "last_stop_id"
    t.integer  "route_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "directions", ["route_id"], :name => "index_directions_on_route_id"

  create_table "route_stops", :force => true do |t|
    t.integer  "route_stop_order"
    t.integer  "direction_id"
    t.integer  "stop_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "route_stops", ["direction_id"], :name => "index_route_stops_on_direction_id"
  add_index "route_stops", ["route_stop_order"], :name => "index_route_stops_on_route_stop_order"
  add_index "route_stops", ["stop_id"], :name => "index_route_stops_on_stop_id"

  create_table "routes", :force => true do |t|
    t.string   "eid"
    t.string   "tag"
    t.string   "name"
    t.string   "short_name"
    t.integer  "vehicle_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "stops", :force => true do |t|
    t.string   "eid"
    t.string   "tag"
    t.string   "name"
    t.string   "short_name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stops", ["eid"], :name => "index_stops_on_eid"
  add_index "stops", ["tag"], :name => "index_stops_on_tag"

end
