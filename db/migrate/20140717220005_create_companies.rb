class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.float :average_rating
      t.string :phone_number

      t.timestamps
    end
  end
end
