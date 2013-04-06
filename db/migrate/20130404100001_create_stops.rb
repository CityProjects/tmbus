class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|

      t.string :eid # ratt station_id
      t.string :tag

      t.string :name
      t.string :long_name

      t.float :latitude
      t.float :longitude

      t.timestamps
    end

    add_index :stops, :eid, unique: true
    add_index :stops, :tag, unique: true
  end
end
