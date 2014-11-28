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
    msg = { rating: { rating: 4 }, permit_beacon_id: permit.beacon_id }

    submit_post("/ratings", msg)

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

  test "can't rate without consumer id" do
    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    post "/v1/ratings", rating: { rating: 4 }, 
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "403", "Created rating without consumer id (#{@response.code})")
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

  test "app can't record service without consumer id" do
    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    post "/v1/services", service: { start_latitude: 4, end_latitude:5, 
                                    start_longitude: 1, end_longitude: 1 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "403", "Recorded service without consumer id (#{@response.body.inspect})")

  end

  # Violations
  test "app can't create violations without correct perms" do
    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    post "/v1/violations", service: { name: "Speeding", ordinance: "..." }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "403", "Issued violation without permissions (#{@response.body.inspect})")

  end

  test "app can't update violations without correct perms" do
    assert Violation.all.count > 0

    violation = Violation.last
    msg = { permit_number: violation.permit.permit_number }
    msg[:violation] = { id: violation.id }
    msg[:violation][:name] = "newname"

    submit_patch("/violations/#{violation.id}", msg)

    assert(@response.code == "403", "Updated violation w/o permissions (#{@response.body.inspect})")
  end

  test "app can create violations with correct perms" do
    # Add a permission to @app
    assert Permission.all.count > 0, "No permissions in DB!"
    add_permission(Permission.MANAGE_VIOLATIONS)

    permit = Permit.where(:service_type_id => @service_type.id).last
    permit_beacon_id = permit.beacon_id

    msg = {}
    msg[:permit_beacon_id] = permit_beacon_id
    msg[:violation] = { name: "Speeding", ordinance: "..." }

    submit_post("/violations", msg)

    assert(@response.code == "201", "Couldn't record violation (#{@response.body.inspect})")
  end

  test "app can update violations with correct perms" do
    assert Violation.all.count > 0
    add_permission(Permission.MANAGE_VIOLATIONS)

    violation = Violation.last
    msg = {}
    msg[:violation] = { id: violation.id, permit_id: violation.permit_id }
    msg[:violation][:name] = "newname"

    submit_patch("/violations/#{violation.id}", msg)

    assert(@response.code[0] == "2", "Did not updated violation (#{@response.code})")
  end

  test "app can update permits with correct perms" do
    add_permission(Permission.MANAGE_PERMITS)
    permit = Permit.last

    vehicle = Vehicle.first
    msg = { service_type: @service_type.name, vehicle: vehicle.license_plate }
    msg[:permit] = { permit_number: 12999100094, beacon_id: 10010010101010101, status: "good" }
    submit_patch("/permits/#{permit.id}", msg)

    assert(@response.code[0] == "2", "Did not updated violation (#{@response.body.inspect})")
  end

  test "app can't update permits without correct perms" do
    permit = Permit.last

    vehicle = Vehicle.first
    msg = { service_type: @service_type.name, vehicle: vehicle.license_plate }
    msg[:permit] = { permit_number: 12999100094, beacon_id: 10010010101010108, status: "good" }
    submit_patch("/permits/#{permit.id}", msg)

    assert(@response.code == "403", "Updated violation without permissions! (#{@response.code})")
  end

  test "app can create permits with correct perms" do
    add_permission(Permission.MANAGE_PERMITS)
    oldCount = Permit.all.count

    company = Company.first
    person = Person.first
    vehicle = Vehicle.first

    permitables = {company: company.name, person: person.id, vehicle: vehicle.license_plate}
    beacon_id = 19999292993

    permitables.each do |key, value|
      msg = { service_type: @service_type.name }
      msg[:permit] = { permit_number: 12999100+beacon_id, beacon_id: beacon_id, status: "good" }
      msg[key] = value

      submit_post("/permits", msg)

      assert(@response.code[0] == "2", "Could not create permit for #{key} (#{@response.body.inspect})")
      beacon_id += 3331
    end

    assert oldCount+3 == Permit.all.count
  end

  test "app can't create permits without correct perms" do
    msg = { service_type: @service_type.name }
    msg[:permit] = { permit_number: 12999100091, beacon_id: 199999999, status: "good" }

    submit_post("/permits", msg)

    assert(@response.code == "403", "Error code: #{@response.code}")
  end

  test "app can create vehicles with correct perms" do
      #flunk
  end

  test "app can't create vehicles without correct perms" do
      #flunk
  end

  def json_response
      JSON.parse @response.body
  end

  def submit_post (url, msg)
    msg[:consumer_id] = "BRIANBROLL"
    msg[:app_signature] = @signature
    post "/v1#{url}", msg
  end

  def submit_patch (url, msg)
    msg[:consumer_id] = "BRIANBROLL"
    msg[:app_signature] = @signature

    patch "/v1#{url}", msg
  end

  def add_permission (permissions)
    assert permissions.count > 0, "No permissions!"

    permission = permissions.where(:service_type_id => @service_type.id).first
    assert_not_nil permission, "Permission is nil!"

    @app.permissions << permission # Add the given permission
    @app.save
  end

end
