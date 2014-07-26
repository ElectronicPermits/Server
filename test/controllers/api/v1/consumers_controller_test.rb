require 'test_helper'

class API::V1::ConsumersControllerTest < ActionController::TestCase
  setup do
    @consumer = consumers(:consumer_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:consumers)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  test "should create consumer" do
    assert_difference('Consumer.count') do
      assert_not @consumer.trusted_app.sha_hash.nil?
      post :create, :format => :json, consumer: { unique_user_id: @consumer.unique_user_id }, app_signature: @consumer.trusted_app.sha_hash
    end

    #assert_redirected_to consumer_path(assigns(:consumer))
  end

  test "should show consumer" do
    get :show, :format => :json, id: @consumer
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @consumer
    #assert_response :success
  #end

  test "should update consumer" do
    patch :update, :format => :json, id: @consumer, consumer: { unique_user_id: @consumer.unique_user_id }
    #assert_redirected_to consumer_path(assigns(:consumer))
  end

  #test "should destroy consumer" do
    #assert_difference('Consumer.count', -1) do
      #delete :destroy, id: @consumer
    #end

    #assert_redirected_to consumers_path
  #end

  #test "should not create consumer without trusted_app" do
    #assert_not_difference('API::V1::Consumer.count') do
      #post :create, consumer: { unique_user_id: @consumer.unique_user_id }
    #end

    #assert_redirected_to consumer_path(assigns(:consumer))
  #end


end
