require 'test_helper'

class API::V1::CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:company_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  #test "should get new" do
    #get :new
    #assert_response :success
  #end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { average_rating: @company.average_rating, name: @company.name, phone_number: @company.phone_number }
    end

    #assert_redirected_to company_path(assigns(:company))
  end

  test "should show company" do
    get :show, :format => :json, id: @company
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @company
    #assert_response :success
  #end

  test "should update company" do
    patch :update, :format => :json, id: @company, company: { average_rating: @company.average_rating, name: @company.name, phone_number: @company.phone_number }
    #assert_redirected_to company_path(assigns(:company))
  end

  #test "should destroy company" do
    #assert_difference('Company.count', -1) do
      #delete :destroy, id: @company
    #end

    #assert_redirected_to companies_path
  #end
end
