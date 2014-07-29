class AddPermissionsTrustedAppsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :permissions_trusted_apps, :id => false do |t|
        t.integer :permission_id
        t.integer :trusted_app_id
    end
  end

  def self.down
    drop_table :permissions_trusted_apps
  end
end
