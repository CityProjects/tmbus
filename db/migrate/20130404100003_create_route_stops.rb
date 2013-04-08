class CreateRouteStops < ActiveRecord::Migration
  def change
    create_table :route_stops do |t|

      t.integer :order_idx
      t.integer :direction

      t.references :route
      t.references :stop

      t.timestamps
    end

    add_index :route_stops, :route_id
    add_index :route_stops, :stop_id
    add_index :route_stops, :order_idx
    add_index :route_stops, :direction
    add_index :route_stops, [:route_id, :stop_id, :direction], unique: true, name: 'route_stop_direction_uniq'
    add_index :route_stops, [:route_id, :direction, :order_idx], unique: true, name: 'route_direction_order_uniq'
  end
end
