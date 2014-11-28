class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :service_name
      t.integer :permission_type

      t.timestamps
    end
  end
end
