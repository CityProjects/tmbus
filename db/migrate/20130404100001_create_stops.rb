class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|

      t.string :eid # ratt station_id
      t.string :ename # ratt station name
      t.string :tag

      t.string :name
      t.string :alternate_names
      t.string :allowed_vehicles

      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :stops, :eid, unique: true
    add_index :stops, :tag, unique: true
    add_index :stops, :allowed_vehicles
    add_index :stops, :name
    add_index :stops, :alternate_names

  end
end
