require 'test_helper'

class ServiceTypesControllerTest < ActionController::TestCase
  setup do
    @service_type = service_types(:taxi)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:service_types)
  end

  test "should show service_type" do
    get :show, id: @service_type
    assert_response :success
  end

end
