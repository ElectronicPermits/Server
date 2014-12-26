class AddContactToTrustedApps < ActiveRecord::Migration
  def change
    add_column :trusted_apps, :contact_name, :string
    add_column :trusted_apps, :contact_email, :string
  end
end
