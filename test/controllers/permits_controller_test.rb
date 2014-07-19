require 'test_helper'

class PermitsControllerTest < ActionController::TestCase
  setup do
    @permit = permits(:permit_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:permits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create permit" do
    assert_difference('Permit.count') do
      post :create, permit: { beacon_id: @permit.beacon_id, permit_expiration_date: @permit.permit_expiration_date, permit_number: @permit.permit_number, status: @permit.status, training_completion_date: @permit.training_completion_date, valid: @permit.valid }
    end

    assert_redirected_to permit_path(assigns(:permit))
  end

  test "should show permit" do
    get :show, id: @permit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @permit
    assert_response :success
  end

  test "should update permit" do
    patch :update, id: @permit, permit: { beacon_id: @permit.beacon_id, permit_expiration_date: @permit.permit_expiration_date, permit_number: @permit.permit_number, status: @permit.status, training_completion_date: @permit.training_completion_date, valid: @permit.valid }
    assert_redirected_to permit_path(assigns(:permit))
  end

  test "should destroy permit" do
    assert_difference('Permit.count', -1) do
      delete :destroy, id: @permit
    end

    assert_redirected_to permits_path
  end
end
