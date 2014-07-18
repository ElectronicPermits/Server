class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.float, :start_coordinates
      t.float, :end_coordinates
      t.time, :start_time
      t.time, :end_time
      t.decimal, :estimated_cost
      t.decimal :actual_cost

      t.timestamps
    end
  end
end
