class AddServiceTypeToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :service_type_id, :integer
  end
end
