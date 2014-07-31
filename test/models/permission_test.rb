require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save permission without service type" do
    permission = permissions(:permission_1)
    permission.service_type = nil
    assert_not permission.save
  end

  test "should not save permission without permission type" do
    permission = permissions(:permission_1)
    permission.permission_type = nil
    assert_not permission.save
  end

  test "should not save permission without ENUM permission type" do
    permission = permissions(:permission_1)
    permission.permission_type = "random string"
    assert_not permission.save
  end

end
