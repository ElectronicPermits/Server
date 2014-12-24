require 'test_helper'

class API::V1::PeopleControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @person = people(:person_1)
    @app_signature = @person.trusted_app.app_name
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:people)
  end

  test "should show person" do
    get :show, :format => :json, id: @person
    assert_response :success
  end

end
