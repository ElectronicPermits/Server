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

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  test "should create rating" do
    assert_difference('Rating.count') do
      post :create, :format => :json, rating: { comments: @rating.comments, rating: @rating.rating }
    end

  end

  test "should show rating" do
    get :show, :format => :json, id: @rating
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, :format => :json, id: @rating
    #assert_response :success
  #end

  #test "should update rating" do
    #patch :update, :format => :json, id: @rating, rating: { comments: @rating.comments, rating: @rating.rating }
  #end

  #test "should destroy rating" do
    #assert_difference('Rating.count', -1) do
      #delete :destroy, id: @rating
    #end

  #end

  test "should not create rating without rating" do
    rating = Rating.new
    rating.comments = "TEST COMMENT"
    assert_not rating.save
  end

  test "should not create rating without permit" do
    rating = Rating.new
    rating.rating = 3
    rating.comments = "TEST COMMENT"
    assert_not rating.save
  end

  test "should update permit rating on CREATE" do
    #TODO
  end

  test "should update permit rating on UPDATE" do
    #TODO
  end

  test "should update permit rating on DELETE" do
    #TODO
  end

  #test "cannot spam database with entries" do
    #rating = ratings(:rating_2)
    #consumer = rating.consumer
    #rating_limit = consumer.trusted_app.max_daily_limit
    #locked_account = false

    #(1..rating_limit+1).each do |i|
      #r = API::V1::Rating.new
      #r.rating = 3
      #r.consumer = consumer

      #if not r.save then
        #locked_account = true
      #end

      #assert locked_account
    #end

    ##TODO
  #end

end
