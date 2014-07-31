require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "should not save vehicle without trusted_app" do
    vehicle = vehicles(:vehicle_1)
    vehicle.trusted_app = nil
    assert_not vehicle.save
  end

  test "should not save vehicle without make" do
    vehicle = vehicles(:vehicle_1)
    vehicle.make = nil
    assert_not vehicle.save
  end

  test "should not save vehicle without model" do
    vehicle = vehicles(:vehicle_1)
    vehicle.model = nil
    assert_not vehicle.save
  end

  test "should not save vehicle without license_plate" do
    vehicle = vehicles(:vehicle_1)
    vehicle.license_plate = nil
    assert_not vehicle.save
  end

end
