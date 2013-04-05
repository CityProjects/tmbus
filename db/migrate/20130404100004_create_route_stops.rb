class CreateRouteStops < ActiveRecord::Migration
  def change
    create_table :route_stops do |t|

      t.integer :route_stop_order

      t.references :direction
      t.references :stop

      t.timestamps
    end

    add_index :route_stops, :direction_id
    add_index :route_stops, :stop_id
    add_index :route_stops, :route_stop_order
    add_index :route_stops, [:direction_id, :stop_id], unique: true
    add_index :route_stops, [:direction_id, :route_stop_order], unique: true
  end
end
