class AddConsumerRefToRating < ActiveRecord::Migration
  def change
    add_reference :ratings, :consumer, index: true
  end
end
