class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|

      t.string :eid # ratt traseu_id (not used in logic, just for reference)
      t.string :tag

      t.string :name
      t.string :long_name

      t.integer :vehicle_type

      t.timestamps
    end

    add_index :routes, :eid
    add_index :routes, :vehicle_type
  end
end
