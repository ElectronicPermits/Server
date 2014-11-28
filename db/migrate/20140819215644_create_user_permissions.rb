class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :user_permissions do |t|
      t.integer :action
      t.integer :target

      t.timestamps
    end
  end
end
