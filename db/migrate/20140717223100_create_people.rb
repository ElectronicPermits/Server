class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :date_of_birth
      t.string :race
      t.string :sex
      t.integer :height
      t.integer :weight
      t.string :phone_number

      t.timestamps
    end
  end
end
