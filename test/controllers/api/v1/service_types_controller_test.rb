require 'test_helper'

class API::V1::ServiceTypesControllerTest < ActionController::TestCase
  setup do
    request.env['HTTPS'] = 'on'
    @service_type = service_types(:service_type_1)
    @app_signature = @service_type.trusted_app.app_name
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
      post :create, :format => :json, service_type: { description: @service_type.description, name: new_name }, app_signature: @app_signature
    end

  end

  test "should show service_type" do
    get :show, :format => :json, id: @service_type
    assert_response :success
  end

  test "should update service_type" do
    patch :update, :format => :json, id: @service_type, service_type: { description: @service_type.description, name: @service_type.name }, app_signature: @app_signature
  end

  test "should destroy service_type" do
    assert_difference('ServiceType.count', -1) do
      delete :destroy, :format => :json, id: @service_type, app_signature: @app_signature
    end
  end

  test "should create and remove respective permissions" do
    new_name = @service_type.name

    #Get a unique name to avoid uniqueness violation
    while not ServiceType.where(:name => new_name).first.nil?
      new_name = new_name + rand(100).to_s
    end

    permission_count = Permission::PERMISSION_TYPES.length
    assert_difference('Permission.count', permission_count) do
      post :create, :format => :json, service_type: { description: @service_type.description, name: new_name }, app_signature: @app_signature
    end

    service_type = ServiceType.where(:name => new_name).first
    assert_difference('Permission.count', (-1 * permission_count)) do
      delete :destroy, :format => :json, id: service_type, app_signature: @app_signature
    end

    s_types = ServiceType.all.to_a
    s_types.each do |service_type|
      delete :destroy, :format => :json, id: service_type, app_signature: @app_signature
    end

    # Clean the database
    # Make some extra service types. 
    # This will let us know that the correct perms exist
    [1..10].each do |name|
      new_name = @service_type.name

      #Get a unique name to avoid uniqueness violation
      while not ServiceType.where(:name => new_name).first.nil?
        new_name = new_name + rand(100).to_s
      end

      permission_count = Permission::PERMISSION_TYPES.length
      assert_difference('Permission.count', permission_count) do
        post :create, :format => :json, service_type: { description: @service_type.description, name: new_name }, app_signature: @app_signature
      end
    end

  end

end
