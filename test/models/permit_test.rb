require 'test_helper'

class PermitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save without permitable" do
    permit = permits(:permit_2)
    permit.permitable = nil
    assert_not permit.save
  end

  test "should not save without validity" do
    permit = permits(:permit_2)
    permit.valid = nil
    assert_not permit.save
  end

  test "should not save without permit_number" do
    permit = permits(:permit_2)
    permit.permit_number = nil
    assert_not permit.save
  end

end
