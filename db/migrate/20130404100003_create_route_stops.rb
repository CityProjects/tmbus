class CreateRouteStops < ActiveRecord::Migration
  def change
    create_table :route_stops do |t|

      t.integer :route_stop_order
      t.integer :direction

      t.references :route
      t.references :stop

      t.timestamps
    end

    add_index :route_stops, :route_id
    add_index :route_stops, :stop_id
    add_index :route_stops, :route_stop_order
    add_index :route_stops, :direction
    add_index :route_stops, [:route_id, :stop_id, :direction], unique: true, name: 'route_stop_direction_uniq'
    add_index :route_stops, [:route_id, :direction, :route_stop_order], unique: true, name: 'route_direction_order_uniq'
  end
end
