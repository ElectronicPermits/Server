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

  test "should not save without unique user id" do
    consumer = consumers(:consumer_2)
    consumer.unique_user_id = nil
    assert_not consumer.save
  end

  test "should not save without UNIQUE user id" do
    consumerData = consumers(:consumer_2)
    consumer = Consumer.new
    consumer.unique_user_id = consumerData.unique_user_id 
    consumer.trusted_app = consumerData.trusted_app 

    assert_not consumer.save
  end
end
