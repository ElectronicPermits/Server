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

  # Creation, update, delete are all integration tests now

  test "should show company" do
    get :show, :format => :json, id: @company.name
    assert_response :success
  end
end
