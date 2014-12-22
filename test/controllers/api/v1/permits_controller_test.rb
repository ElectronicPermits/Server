require 'test_helper'

class API::V1::PermitsControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @permit = permits(:permit_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:permits)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  # Need to add association
  # TODO
  #test "should create permit" do
    #assert_difference('Permit.count') do
      #post :create, :format => :json, permit: { beacon_id: @permit.beacon_id, permit_expiration_date: @permit.permit_expiration_date, permit_number: @permit.permit_number, status: @permit.status, training_completion_date: @permit.training_completion_date, valid: @permit.valid }
    #end

  #end

  test "should show permit" do
    get :show, :format => :json, id: @permit.beacon_id
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @permit
    #assert_response :success
  #end

  # Updating permits has been moved to integration testing

  #test "should destroy permit" do
    #assert_difference('Permit.count', -1) do
      #delete :destroy, id: @permit
    #end

  #end
  test "should not create permit without permitable association" do
    assert_no_difference('Permit.count') do
      post :create, :format => :json, permit: { beacon_id: @permit.beacon_id, permit_expiration_date: @permit.permit_expiration_date, permit_number: @permit.permit_number, status: @permit.status, training_completion_date: @permit.training_completion_date, valid: @permit.valid }
    end
  end
 
end
