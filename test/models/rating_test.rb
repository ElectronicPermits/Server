require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  
  test "should not create rating without rating" do
    rating = ratings(:rating_4)
    rating.rating = nil
    assert_not rating.save, "Saved rating without rating"
  end

  test "should not create rating without permit" do
    rating = ratings(:rating_4)
    rating.permit = nil
    assert_not rating.save, "Saved rating without permit"
  end

  test "should not create rating without consumer" do
    rating = ratings(:rating_4)
    rating.consumer = nil
    assert_not rating.save, "Saved rating without consumer"
  end
  
end
