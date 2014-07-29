class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :service_name
      t.string :permission_type

      t.timestamps
    end
  end
end
