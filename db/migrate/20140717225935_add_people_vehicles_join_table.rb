class AddPeopleVehiclesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :people_vehicles, :id => false do |t|
        t.integer :person_id
        t.integer :vehicle_id
    end
  end

  def self.down
    drop_table :people_vehicles
  end
end
