class AddPermitRefToViolations < ActiveRecord::Migration
  def change
    add_reference :violations, :permit, index: true
  end
end
