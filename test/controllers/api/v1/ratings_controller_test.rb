require 'test_helper'

class API::V1::RatingsControllerTest < ActionController::TestCase
  setup do
    @rating = ratings(:rating_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "should create rating" do
    assert_not @rating.consumer.trusted_app.sha_hash.nil?
    assert_difference('Rating.count') do
      post :create, :format => :json, rating: { comments: @rating.comments, rating: @rating.rating}, consumer_id: @rating.consumer.unique_user_id, app_signature: @rating.consumer.trusted_app.sha_hash, permit_beacon_id: @rating.permit.beacon_id
    end

  end

  test "should show rating" do
    get :show, :format => :json, id: @rating
    assert_response :success
  end

  #Should NOT's
  test "should not create rating without permit" do
    assert_no_difference('Rating.count') do
      post :create, :format => :json, rating: { comments: @rating.comments, rating: @rating.rating}, consumer_id: @rating.consumer.unique_user_id, app_signature: @rating.consumer.trusted_app.sha_hash
    end

  end

  test "should not create rating without app signature" do
    assert_no_difference('Rating.count') do
      post :create, :format => :json, rating: { comments: @rating.comments, rating: @rating.rating}, consumer_id: @rating.consumer.unique_user_id, permit_beacon_id: @rating.permit.beacon_id
    end

  end

  test "should not create rating without consumer" do
    assert_no_difference('Rating.count') do
      post :create, :format => :json, rating: { comments: @rating.comments, rating: @rating.rating}, permit_beacon_id: @rating.permit.beacon_id, app_signature: @rating.consumer.trusted_app.sha_hash
    end
  end

  test "should update permit rating on CREATE" do
    #TODO
  end

  test "cannot spam database with entries" do
    rating = ratings(:rating_2)
    consumer = rating.consumer
    rating_limit = consumer.trusted_app.max_daily_posts
    locked_account = false

    (1..rating_limit+1).each do |i|
      r = Rating.new
      r.rating = 3
      r.consumer = consumer

      if not r.save then
        locked_account = true
      end

      assert locked_account
    end
  end

end
