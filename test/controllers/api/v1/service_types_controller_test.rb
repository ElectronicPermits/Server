require 'test_helper'

class API::V1::ServiceTypesControllerTest < ActionController::TestCase
  setup do
    @service_type = service_types(:service_type_1)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:service_types)
  end

  test "should create service_type" do
    new_name = @service_type.name

    #Get a unique name to avoid uniqueness violation
    while not ServiceType.where(:name => new_name).first.nil?
      new_name = new_name + rand(100).to_s
    end

    assert_difference('ServiceType.count') do
      post :create, :format => :json, service_type: { description: @service_type.description, name: new_name }, app_signature: @service_type.trusted_app.sha_hash
    end

  end

  test "should show service_type" do
    get :show, :format => :json, id: @service_type
    assert_response :success
  end

  test "should update service_type" do
    patch :update, :format => :json, id: @service_type, service_type: { description: @service_type.description, name: @service_type.name }, app_signature: @service_type.trusted_app.sha_hash
  end

  test "should destroy service_type" do
    assert_difference('ServiceType.count', -1) do
      delete :destroy, :format => :json, id: @service_type, app_signature: @service_type.trusted_app.sha_hash
    end
  end

  test "should create respective permissions" do
    # TODO
  end

end
