require 'test_helper'

class API::V1::ServiceTypesControllerTest < ActionController::TestCase
  setup do
    @service_type = service_types(:taxi)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:service_types)
  end

  #test "should get new" do
    #get :new, :format => :json
    #assert_response :success
  #end

  test "should create service_type" do
    assert_difference('ServiceType.count') do
      post :create, :format => :json, service_type: { description: @service_type.description, name: @service_type.name }
    end

  end

  test "should show service_type" do
    get :show, :format => :json, id: @service_type
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, :format => :json, id: @service_type
    #assert_response :success
  #end

  test "should update service_type" do
    patch :update, :format => :json, id: @service_type, service_type: { description: @service_type.description, name: @service_type.name }
  end

  test "should destroy service_type" do
    assert_difference('ServiceType.count', -1) do
      delete :destroy, :format => :json, id: @service_type
    end

  end
end
