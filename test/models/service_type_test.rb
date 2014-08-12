require 'test_helper'

class ServiceTypeTest < ActiveSupport::TestCase

  test "should not save with duplicate name" do
    service_type_copy = service_types(:service_type_1)
    service_type = ServiceType.new
    service_type.trusted_app = service_type_copy.trusted_app
    service_type.name = service_type_copy.name
    assert_not service_type.save
  end

  test "should not save without trusted_app" do
    service_type = service_types(:service_type_1)
    service_type.trusted_app = nil
    assert_not service_type.save
  end

end
