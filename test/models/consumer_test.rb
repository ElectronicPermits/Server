require 'test_helper'

class ConsumerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should not save without trusted app" do
    consumer = consumers(:consumer_2)
    consumer.trusted_app = nil
    assert_not consumer.save
  end
end
