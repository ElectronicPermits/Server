require 'test_helper'

class API::V1::ViolationsControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @violation = violations(:violation_1)
    @app_signature = @violation.trusted_app.app_name
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:violations)
  end

  #test "should create violation" do
    #assert_difference('Violation.count') do
      #post :create, :format => :json, violation: { description: @violation.description, issue_date: @violation.issue_date, name: @violation.name, closed: @violation.closed, ordinance: @violation.ordinance }, permit_number: @violation.permit.permit_number, app_signature: @app_signature
    #end

  #end

  test "should show violation" do
    get :show, :format => :json, id: @violation
    assert_response :success
  end

  test "should update violation" do
    patch :update, :format => :json, id: @violation, violation: { description: @violation.description, issue_date: @violation.issue_date, name: @violation.name, closed: @violation.closed, ordinance: @violation.ordinance }, app_signature: @app_signature
  end

end
