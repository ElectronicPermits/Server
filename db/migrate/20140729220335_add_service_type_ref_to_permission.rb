class AddServiceTypeRefToPermission < ActiveRecord::Migration
  def change
    add_reference :permissions, :service_type, index: true
  end
end
