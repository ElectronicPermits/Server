require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test "should not save without addressable" do
    address = addresses(:address_1)
    address.addressable = nil
    assert_not address.save
  end
end
