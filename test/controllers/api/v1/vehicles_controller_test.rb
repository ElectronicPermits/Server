require 'test_helper'

class API::V1::VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = vehicles(:vehicle_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:vehicles)
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post :create, :format => :json, vehicle: { color: @vehicle.color, inspection_date: @vehicle.inspection_date, license_plate: @vehicle.license_plate, make: @vehicle.make, model: @vehicle.model, year: @vehicle.year }, app_signature: @vehicle.trusted_app.sha_hash
    end

  end

  test "should show vehicle" do
    get :show, :format => :json, id: @vehicle
    assert_response :success
  end

  test "should update vehicle" do
    patch :update, :format => :json, id: @vehicle, vehicle: { color: @vehicle.color, inspection_date: @vehicle.inspection_date, license_plate: @vehicle.license_plate, make: @vehicle.make, model: @vehicle.model, year: @vehicle.year }, app_signature: @vehicle.trusted_app.sha_hash
  end

end
