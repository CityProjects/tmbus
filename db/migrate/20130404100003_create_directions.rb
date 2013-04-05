class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|

      t.string :eid # ratt traseu_id
      t.string :tag

      t.integer :first_stop_id
      t.integer :last_stop_id

      t.references :route

      t.timestamps
    end

    add_index :directions, :eid
    add_index :directions, :route_id
  end
end
