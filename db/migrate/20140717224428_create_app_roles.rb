class CreateAppRoles < ActiveRecord::Migration
  def change
    create_table :app_roles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
