require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  setup do
    @service = services(:service_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:services)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  #test "should create service" do
    #assert_difference('Service.count') do
      #post :create, service: { actual_cost: @service.actual_cost, end_latitude: @service.end_latitude, end_longitude: @service.end_longitude, end_time: @service.end_time, estimated_cost: @service.estimated_cost, start_longitude: @service.start_longitude, start_latitude: @service.start_latitude, start_time: @service.start_time }
    #end

    #assert_redirected_to service_path(assigns(:service))
  #end

  test "should show service" do
    get :show, id: @service
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @service
    #assert_response :success
  #end

  #test "should update service" do
    #patch :update, id: @service, service: { actual_cost: @service.actual_cost, end_longitude: @service.end_longitude, end_latitude: @service.end_latitude, end_time: @service.end_time, estimated_cost: @service.estimated_cost, start_latitude: @service.start_latitude, start_longitude: @service.start_longitude, start_time: @service.start_time }
    #assert_redirected_to service_path(assigns(:service))
  #end

  #test "should destroy service" do
    #assert_difference('Service.count', -1) do
      #delete :destroy, id: @service
    #end

    #assert_redirected_to services_path
  #end
end
