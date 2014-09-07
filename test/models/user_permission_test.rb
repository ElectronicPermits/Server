require 'test_helper'

class UserPermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'shouldn\'t save with custom action' do
    user_permission = user_permissions(:users_create)
    user_permission.action = "asdfasdfasdfasdf"
    assert_not user_permission.save, 
      "saved user with action not in enum"
  end

  test 'shouldn\'t save with custom target' do
    user_permission = user_permissions(:users_create)
    user_permission.target = "asdfasdfasdfasdf"
    assert_not user_permission.save,
      "saved user with target not in enum"
  end
end
