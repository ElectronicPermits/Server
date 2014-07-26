class AddPermitRefToService < ActiveRecord::Migration
  def change
    add_reference :services, :permit, index: true
  end
end
