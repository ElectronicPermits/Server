require 'test_helper'

class API::V1::VehiclesControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @vehicle = vehicles(:vehicle_1)
    @app_signature = @vehicle.trusted_app.app_name
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should show vehicle" do
    get :show, :format => :json, id: @vehicle.license_plate
    assert_response :success
  end

end
