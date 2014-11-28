class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :permission_type

      t.timestamps
    end
  end
end
