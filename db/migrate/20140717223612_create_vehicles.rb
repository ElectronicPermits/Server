class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string, :make
      t.string, :model
      t.string, :color
      t.string, :year
      t.date, :inspection_date
      t.string :license_plate

      t.timestamps
    end
  end
end
