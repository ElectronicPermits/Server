require 'test_helper'

class API::V1::CompaniesControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @company = companies(:company_1)
    @app_signature = @company.trusted_app.app_name
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:companies)
  end

  #test "should create company" do
    #name = "THIS IS A RANDOM, UNUSED Name"
    #post :create, :format => :json, company: { average_rating: @company.average_rating, name: name, phone_number: @company.phone_number }, app_signature: @app_signature
    #assert(@response.code === "403", "Error code: #{@response.code}")

    ##assert_redirected_to company_path(assigns(:company))
  #end

  test "should show company" do
    get :show, :format => :json, id: @company
    assert_response :success
  end

  #test "should get edit" do
    #get :edit, id: @company
    #assert_response :success
  #end

  test "should update company" do
    patch :update, :format => :json, id: @company, company: { average_rating: @company.average_rating, name: @company.name, phone_number: @company.phone_number }, app_signature: @company.trusted_app.sha_hash
    #assert_redirected_to company_path(assigns(:company))
  end

  #test "should destroy company" do
    #assert_difference('Company.count', -1) do
      #delete :destroy, id: @company
    #end

    #assert_redirected_to companies_path
  #end
end
