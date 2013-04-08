class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|

      t.string :eid # ratt traseu_id
      t.string :ename # ratt traseu name
      t.string :tag

      t.string :name
      t.string :long_name
      t.string :alternate_names

      t.integer :vehicle_type

      t.integer :stop1_id
      t.integer :stop2_id

      t.timestamps
    end

    add_index :routes, :eid, unique: true
    add_index :routes, :tag, unique: true
    add_index :routes, :vehicle_type

  end
end
