class AddTrustedAppRefToConsumer < ActiveRecord::Migration
  def change
    add_reference :consumers, :trusted_app, index: true
  end
end
