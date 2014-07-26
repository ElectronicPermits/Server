require 'test_helper'

class API::V1::AddressesControllerTest < ActionController::TestCase
  setup do
    @address = addresses(:one)
  end

  #test "should get index" do
    #get :index, :format => :json
    #assert_response :success
    #assert_not_nil assigns(:addresses)
  #end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  test "should create address" do
    assert_difference('Address.count') do
      post :create, :format => :json, address: { city: @address.city, line1: @address.line1, line2: @address.line2, state: @address.state, zipcode: @address.zipcode }
    end

    #assert_redirected_to address_path(assigns(:address))
  end

  test "should show address" do
    get :show, :format => :json, id: @address
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @address
    #assert_response :success
  #end

  test "should update address" do
    patch :update, :format => :json, id: @address, address: { city: @address.city, line1: @address.line1, line2: @address.line2, state: @address.state, zipcode: @address.zipcode }
    #assert_redirected_to address_path(assigns(:address))
  end

  #test "should destroy address" do
    #assert_difference('Address.count', -1) do
      #delete :destroy, id: @address
    #end

    #assert_redirected_to addresses_path
  #end
end