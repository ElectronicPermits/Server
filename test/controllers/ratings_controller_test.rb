require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  setup do
    @rating = ratings(:rating_1)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  #test "should create rating" do
    #assert_difference('Rating.count') do
      #post :create, rating: { comments: @rating.comments, rating: @rating.rating, consumer_id: @rating.consumer_id }
    #end

    #assert_redirected_to rating_path(assigns(:rating))
  #end

  test "should show rating" do
    get :show, id: @rating
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @rating
    #assert_response :success
  #end

  #test "should update rating" do
    #patch :update, id: @rating, rating: { comments: @rating.comments, rating: @rating.rating }
    #assert_redirected_to rating_path(assigns(:rating))
  #end

  #test "should destroy rating" do
    #assert_difference('Rating.count', -1) do
      #delete :destroy, id: @rating
    #end

    #assert_redirected_to ratings_path
  #end

  #test "should not create rating without rating" do
    #rating = Rating.new
    #rating.comments = "TEST COMMENT"
    #assert_not rating.save
  #end

  #test "should not create rating without permit" do
    #rating = Rating.new
    #rating.rating = 3
    #rating.comments = "TEST COMMENT"
    #assert_not rating.save
  #end

  #test "should update permit rating on CREATE" do
    ##TODO
  #end

  #test "should update permit rating on UPDATE" do
    ##TODO
  #end

  #test "should update permit rating on DELETE" do
    ##TODO
  #end

  #test "cannot spam database with entries" do
    #rating = ratings(:rating_2)
    #consumer = rating.consumer
    #rating_limit = consumer.trusted_app.max_daily_limit
    #locked_account = false

    #(1..rating_limit+1).each do |i|
      #r = Rating.new
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
