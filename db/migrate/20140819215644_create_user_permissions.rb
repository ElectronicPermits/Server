class CreateUserPermissions < ActiveRecord::Migration
  def change
    create_table :user_permissions do |t|
      t.string :action
      t.string :target

      t.timestamps
    end
  end
end
