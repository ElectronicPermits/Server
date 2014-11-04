class AddUserPermissionsUsersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :user_permissions_users, :id => false do |t|
        t.integer :user_permission_id
        t.integer :user_id
    end
  end

  def self.down
    drop_table :user_permissions_users
  end
end
