class CreateStaticPermissions < ActiveRecord::Migration
  def change
    create_table :static_permissions do |t|
      t.integer :permission_type
      t.integer :target

      t.timestamps
    end
  end
end
