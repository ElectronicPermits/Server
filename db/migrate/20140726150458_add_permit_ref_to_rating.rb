class AddPermitRefToRating < ActiveRecord::Migration
  def change
    add_reference :ratings, :permit, index: true
  end
end
