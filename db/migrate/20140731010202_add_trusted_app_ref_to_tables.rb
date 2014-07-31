class AddTrustedAppRefToTables < ActiveRecord::Migration
  def change
    add_reference :companies, :trusted_app, index: true
    add_reference :people, :trusted_app, index: true
    add_reference :permits, :trusted_app, index: true
    add_reference :service_types, :trusted_app, index: true
    add_reference :violations, :trusted_app, index: true
    add_reference :vehicles, :trusted_app, index: true
  end
end
