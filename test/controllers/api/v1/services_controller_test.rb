require 'test_helper'

class API::V1::ServicesControllerTest < ActionController::TestCase
  setup do
    @service = services(:service_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:services)
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, :format => :json, service: { actual_cost: @service.actual_cost, end_latitude: @service.end_latitude, end_longitude: @service.end_longitude, end_time: @service.end_time, estimated_cost: @service.estimated_cost, start_longitude: @service.start_longitude, start_latitude: @service.start_latitude, start_time: @service.start_time }, consumer_id: @service.consumer.unique_user_id, app_signature: @service.consumer.trusted_app.sha_hash, permit_beacon_id: @service.permit.beacon_id
    end

  end

  test "should show service" do
    get :show, :format => :json, id: @service
    assert_response :success
  end

  test "should not create service without consumer" do
    assert_no_difference('Service.count') do
      post :create, :format => :json, service: { actual_cost: @service.actual_cost, end_latitude: @service.end_latitude, end_longitude: @service.end_longitude, end_time: @service.end_time, estimated_cost: @service.estimated_cost, start_longitude: @service.start_longitude, start_latitude: @service.start_latitude, start_time: @service.start_time }
    end

  end

end
