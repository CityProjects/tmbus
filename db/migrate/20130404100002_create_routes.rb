class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|

      t.string :eid # ratt traseu_id
      t.string :ename # ratt traseu name
      t.string :tag

      t.string :name

      t.string :direction0_name
      t.string :direction1_name

      t.integer :vehicle_type


      t.timestamps
    end

    add_index :routes, :eid, unique: true
    add_index :routes, :tag, unique: true
    add_index :routes, :vehicle_type

  end
end
