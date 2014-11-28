# This contains the tests for the API as it 
# is used by the trusted apps
#
# A lot of the functionality has already been 
# tested in the controllers for the api.
#
require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  setup do 
    https!
    host! "api.vcap.me"

    @signature = "APP"
    @app = TrustedApp.create(app_name: "APP", 
                             sha_hash: Digest::SHA1.hexdigest(@signature))

    @service_type = ServiceType.first
    @permit = @service_type.permits.first

    # Create permissions
    permission = Permission.create(:permission_type => Permission.permission_types['RATE'], 
                                   :service_type_id => @service_type.id)
    permission.save

  end

  test "app can retrieve permit info" do
    # This should be done with a GET request to 
    # the necessary endpoint
    permit = Permit.first
    get api_v1_permit_path permit.beacon_id

    assert_equal permit[:id], json_response["id"]
  end

  test "app can retrieve company info" do
    company = Company.first
    get api_v1_company_path company.id

    assert_equal company.id, json_response["id"]
  end

  # Creation permissions
  test "app can't rate without perms" do
    permit = Permit.last
    permit_beacon_id = permit.beacon_id
    post "/v1/ratings", rating: { rating: 4 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature
    assert_response(403)
  end

  test "app can rate with correct perms" do
    # Add a permission to @app
    assert Permission.all.count > 0, "No permissions in DB!"
    permissions = Permission.RATE

    assert permissions.count > 0, "No permissions!"

    permission = permissions.where(:service_type_id => @service_type.id).first
    assert_not_nil permission, "Permission is nil!"

    @app.permissions << permission # Add the given permission
    @app.save

    # Get the permit to rate
    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    post "/v1/ratings", rating: { rating: 4 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "201", "Unable to create rating (#{@response.code})")
  end

  test "app can't record service without perms" do
    permit = Permit.last
    permit_beacon_id = permit.beacon_id
    post "/v1/services", service: { start_latitude: 4, end_latitude:5, 
                                    start_longitude: 1, end_longitude: 1 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature
    assert_response(403)
  end

  test "app can record service with correct perms" do
    # Add a permission to @app
    assert Permission.all.count > 0, "No permissions in DB!"
    permissions = Permission.RECORD_SERVICE

    assert permissions.count > 0, "No permissions!"

    permission = permissions.where(:service_type_id => @service_type.id).first
    assert_not_nil permission, "Permission is nil!"

    @app.permissions << permission # Add the given permission
    @app.save

    # Get the permit to rate
    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    post "/v1/services", service: { start_latitude: 4, end_latitude:5, 
                                    start_longitude: 1, end_longitude: 1 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "201", "Unable to record service (#{@response.body.inspect})")

  end


  def json_response
      JSON.parse @response.body
  end

end
