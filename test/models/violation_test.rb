require 'test_helper'

class ViolationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save without permit" do
    violation = violations(:violation_2)
    violation.permit = nil
    assert_not violation.save
  end
end
