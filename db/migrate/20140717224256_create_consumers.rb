class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :unique_user_id

      t.timestamps
    end
  end
end
