class CreateAppRoles < ActiveRecord::Migration
  def change
    create_table :app_roles do |t|
      t.string :service_name
      t.string :permission_type

      t.timestamps
    end
  end
end
