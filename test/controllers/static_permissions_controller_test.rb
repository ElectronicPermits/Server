require 'test_helper'

class StaticPermissionsControllerTest < ActionController::TestCase
  setup do
    @static_permission = StaticPermission.first
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:static_permissions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create static_permission" do
    assert_difference('StaticPermission.count') do
      post :create, static_permission: { permission_type: @static_permission.permission_type, target: @static_permission.target }
    end

    assert_redirected_to static_permission_path(assigns(:static_permission))
  end

  test "should show static_permission" do
    get :show, id: @static_permission
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @static_permission
    assert_response :success
  end

  test "should update static_permission" do
    patch :update, id: @static_permission, static_permission: { permission_type: @static_permission.permission_type, target: @static_permission.target }
    assert_redirected_to static_permission_path(assigns(:static_permission))
  end

  test "should destroy static_permission" do
    assert_difference('StaticPermission.count', -1) do
      delete :destroy, id: @static_permission
    end

    assert_redirected_to static_permissions_path
  end
end
