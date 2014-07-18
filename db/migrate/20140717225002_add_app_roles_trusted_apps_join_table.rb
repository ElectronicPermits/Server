class AddAppRolesTrustedAppsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :app_roles_trusted_apps, :id => false do |t|
        t.integer :app_role_id
        t.integer :trusted_app_id
    end
  end

  def self.down
    drop_table :app_roles_trusted_apps
  end
end
