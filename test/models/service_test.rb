require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  setup do
    @service = services(:service_1)
  end

  test "should not create service without permit" do
    service = services(:service_4)
    service.permit = nil
    assert_not service.save, "Saved service without permit"
  end


  test "should not create service without consumer" do
    service = services(:service_4)
    service.consumer = nil
    assert_not service.save, "Saved service without consumer"
  end

end
