class AddStaticPermissionsTrustedAppsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :static_permissions_trusted_apps, :id => false do |t|
        t.integer :static_permission_id
        t.integer :trusted_app_id
    end
  end

  def self.down
    drop_table :static_permissions_trusted_apps
  end
end
