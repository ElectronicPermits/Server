require 'test_helper'

class UserPermissionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'shouldn\'t save with custom action' do
    user_permission = user_permissions(:users_CREATE)
    assert_raises(ArgumentError) {
        user_permission.action = "asdfasdfasdfasdf"
    }
  end

  test 'shouldn\'t save with custom target' do
    user_permission = user_permissions(:users_CREATE)
    assert_raises(ArgumentError) {
        user_permission.target = "asdfasdfasdfasdf"
    }
  end
end
