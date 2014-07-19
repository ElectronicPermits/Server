class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.float :start_latitude
      t.float :start_longitude
      t.float :end_latitude
      t.float :end_longitude
      t.time :start_time
      t.time :end_time
      t.decimal :estimated_cost
      t.decimal :actual_cost

      t.timestamps
    end
  end
end
