class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer, :rating
      t.string :comments

      t.timestamps
    end
  end
end
