class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.float :average_rating, :default => 0
      t.float :total_ratings, :default => 0
      t.string :phone_number

      t.timestamps
    end
  end
end
