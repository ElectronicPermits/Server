class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
      t.string :permit_number
      t.date :permit_expiration_date
      t.date :training_completion_date
      t.string :status
      t.boolean :valid, :default => true
      t.string :beacon_id
      t.float :average_rating, :default => 0
      t.references :permitable, polymorphic: true

      t.timestamps
    end
  end
end
