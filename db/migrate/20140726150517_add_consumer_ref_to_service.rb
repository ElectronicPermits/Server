class AddConsumerRefToService < ActiveRecord::Migration
  def change
    add_reference :services, :consumer, index: true
  end
end
