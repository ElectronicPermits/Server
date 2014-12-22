require 'test_helper'

class API::V1::ServicesControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @service = services(:service_1)
    @app_signature = @service.consumer.trusted_app.app_name
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:services)
  end

  # Creation tests have been moved to integration tests 
  # as the authentication needs to be tested as well

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
