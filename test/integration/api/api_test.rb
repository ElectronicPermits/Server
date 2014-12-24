# This contains the tests for the API as it 
# is used by the trusted apps
#
# A lot of the functionality has already been 
# tested in the controllers for the api.
#
require 'test_helper'
require 'open-uri'

class ApiTest < ActionDispatch::IntegrationTest
  setup do 
    https!
    assert https?
    host! "api.vcap.me"  # Reflects back to localhost

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
    get api_v1_company_path company.name

    assert_equal company.id, json_response["id"]
  end

  # Feedback creation permissions
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

    # Also check that the consumer is created
    assert Consumer.where(:unique_user_id => "BRIANBROLL").first.nil?
    post "/v1/ratings", rating: { rating: 4 }, consumer_id: "BRIANBROLL",
                        permit_beacon_id: permit_beacon_id, app_signature: @signature

    assert(@response.code == "201", "Unable to create rating (#{@response.code})")
    assert_not Consumer.where(:unique_user_id => "BRIANBROLL").first.nil?
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
    msg = { service_type: @service_type.name, 
            vehicle: {license_plate: vehicle.license_plate} }
    msg[:permit] = { permit_number: 12999100094, beacon_id: 10010010101010101, status: "good" }
    submit_patch("/permits/#{permit.beacon_id}", msg)

    assert(@response.code[0] == "2", "Did not updated violation (#{@response.body.inspect})")
  end

  test "app can't update permits without correct perms" do
    permit = Permit.last

    vehicle = Vehicle.first
    msg = { service_type: @service_type.name, 
            vehicle: {license_plate: vehicle.license_plate} }
    msg[:permit] = { permit_number: 12999100094, beacon_id: 10010010101010108, status: "good" }
    submit_patch("/permits/#{permit.beacon_id}", msg)

    assert(@response.code == "403", "Updated violation without permissions! (#{@response.code})")
  end

  test "app can create permits with correct perms" do
    add_permission(Permission.MANAGE_PERMITS)
    oldCount = Permit.all.count

    company = Company.first
    person = Person.first
    vehicle = Vehicle.first

    permitables = {company: {name: company.name}, 
                   person: {id: person.id}, 
                   vehicle: {license_plate: vehicle.license_plate}}
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

  # Static Permission tests
  test "app can update vehicles with correct perms" do
      vehicle = Vehicle.first
      id = vehicle.id
      oldPlate = vehicle.license_plate

      msg = {license_plate: "ATHSDV"}
      add_static_permission(:UPDATE, :VEHICLE)
      submit_patch("/vehicles/#{URI.escape(oldPlate)}", {vehicle: msg})

      assert(@response.code[0] == "2", 
             "Could not update vehicle (#{@response.body.inspect})")
      assert(Vehicle.find(id).license_plate == "ATHSDV", 
            "License plate did not actually change")
  end

  test "app can't update vehicles without correct perms" do
      vehicle = Vehicle.first
      oldPlate = vehicle.license_plate
      vehicle.license_plate = "ATHSDV"
      submit_patch("/vehicles/#{URI.escape(oldPlate)}", {vehicle: vehicle})
      assert(@response.code == "403", 
             "Could update vehicle w/o perms (#{@response.body.inspect})")
  end

  test "app can create vehicles with correct perms" do
      vehicle = {make: "Ford", 
                 model: "Ranger", 
                 license_plate: "AME900"}
      add_static_permission(:CREATE, :VEHICLE)
      submit_post("/vehicles", {vehicle: vehicle})
      assert(@response.code[0] == "2", 
             "Could not create vehicle (#{@response.body.inspect})")
  end

  test "app can't create vehicles without correct perms" do
      vehicle = {make: "Ford", 
                 model: "Ranger", 
                 license_plate: "AME900"}
      submit_post("/vehicles", {vehicle: vehicle})
      assert(@response.code == "403", 
             "Could create vehicle w/o perms (#{@response.body.inspect})")
  end

  # People
  # Person or Company Permissions?
  test "app can add/remove person to company with correct perms" do
      add_static_permission(:UPDATE, :COMPANY)
      company = Company.first
      person = Person.first.id
      oldPeopleCount = company.people.count
      msg = {person: {action: 'add', id: person}}
      submit_patch("/companies/#{URI.escape(company.name)}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't add person (#{@response.body.inspect})")

      company = Company.first
      peopleCount = company.people.count
      assert(oldPeopleCount+1 == peopleCount, 
            'Didn\'t add a person to the company')

      # Remove the person
      msg[:person][:action] = 'remove'
      submit_patch("/companies/#{URI.escape(company.name)}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't remove person (#{@response.body.inspect})")

      company = Company.first
      peopleCount = company.people.count
      assert(oldPeopleCount == peopleCount, 
            'Didn\'t remove person from the company')
  end

  test "app can add/remove vehicle to person with correct perms" do
      add_static_permission(:UPDATE, :PERSON)
      person = Person.first
      oldVehicleCount = person.vehicles.count
      vehicle = Vehicle.first
      msg = {vehicle:{action: 'add', license_plate: vehicle.license_plate}}
      submit_patch("/people/#{person.id}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't add vehicle to person (#{@response.body.inspect})")
      person = Person.first
      vehicleCount = person.vehicles.count
      assert(oldVehicleCount+1 == vehicleCount,
             'Didn\'t add vehicle to person');

      # Remove vehicle
      vehicle = Vehicle.first
      msg[:vehicle][:action] = 'remove'
      submit_patch("/people/#{person.id}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't remove vehicle from person (#{@response.body.inspect})")
      person = Person.first
      vehicleCount = person.vehicles.count
      assert(oldVehicleCount == vehicleCount,
             'Didn\'t add vehicle to person');
  end

  test "app can update people with correct perms" do
      add_static_permission(:UPDATE, :PERSON)
      person = Person.first
      oldName = person.first_name
      msg = {first_name: "Steve"}
      submit_patch("/people/#{person.id}", {person: msg})
      assert(@response.code[0] == "2", 
             "Couldn't update person (#{@response.body.inspect})")
  end

  test "app can't update people without correct perms" do
      person = Person.first
      oldName = person.first_name
      msg = {first_name: "Steve"}
      submit_patch("/people/#{person.id}", {person: msg})
      assert(@response.code == "403", 
             "Could update person w/o perms (#{@response.body.inspect})")
  end

  test "app can create people with address" do
      add_static_permission(:CREATE, :PERSON)
      person = {first_name: "Matt",
                last_name: "Smith"}
      address = {line1: "436 English Ivy Drive",
                 city: "Nashville",
                 state: "TN", 
                 zipcode: "37211"}
      submit_post("/people", {person: person, address: address})
      assert(@response.code[0] == "2", 
             "Could not create person (#{@response.body.inspect})")

      # Check on the address creation
      storedPerson = Person.where(first_name: person[:first_name])
                           .where(last_name: person[:last_name]).first
      storedAddress = storedPerson.address
      assert_not(storedAddress.nil?, "Address not created")
      assert(storedAddress[:line1] == address[:line1], "Address not correct")

      # Update address
      add_static_permission(:UPDATE, :PERSON)
      person = storedPerson
      oldName = person.first_name
      msg = {address: {line1: "432 English Ivy Drive"}}
      submit_patch("/people/#{person.id}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't update person's address (#{@response.body.inspect})")

      # Check that the address has been updated
      storedPerson = Person.where(first_name: person[:first_name])
                           .where(last_name: person[:last_name]).first
      storedAddress = storedPerson.address
      assert_not(storedAddress.nil?, "Address not created")
      assert(storedAddress[:line1] == '432 English Ivy Drive', 
             "Address not correct")
  end

  test "app can create people with correct perms" do
      add_static_permission(:CREATE, :PERSON)
      person = {first_name: "Matt",
                last_name: "Smith"}
      submit_post("/people", {person: person})
      assert(@response.code[0] == "2", 
             "Could not create company (#{@response.body.inspect})")

      # Add address later
      add_static_permission(:UPDATE, :PERSON)
      person = Person.where(first_name: "Matt")
                     .where(last_name: "Smith").first
      address = {line1: "436 English Ivy Drive",
                 city: "Nashville",
                 state: "TN", 
                 zipcode: "37211"}
      msg = {address: address}
      submit_patch("/people/#{person.id}", msg)
      assert(@response.code[0] == "2", 
             "Couldn't add person's address (#{@response.body.inspect})")

      person = Person.where(first_name: "Matt")
                     .where(last_name: "Smith").first
      assert(person.address[:line1] == "436 English Ivy Drive", 
             "Address not added to person")
  end

  test "app can't create people without correct perms" do
      person = {first_name: "Matt",
                last_name: "Smith"}
      submit_post("/people", {person: person})
      assert(@response.code == "403", 
             "Could create person w/o perms (#{@response.body.inspect})")
  end

  # Companies
  test "app can't update companies without correct perms" do
      add_static_permission(:CREATE, :COMPANY)
      company = Company.first
      oldName = company.name
      msg = {name: "ATHSDV"}
      submit_patch("/companies/#{URI.escape(oldName)}", {company: msg})
      assert(@response.code == "403", 
             "Could update company w/o perms (#{@response.body.inspect})")
  end

  test "app can create companies with correct perms" do
      company = {name: "NEW COMPANY"}
      add_static_permission(:CREATE, :COMPANY)
      submit_post("/companies", {company: company})
      assert(@response.code[0] == "2", 
             "Could not create company (#{@response.body.inspect})")

      # Add address later
      add_static_permission(:UPDATE, :COMPANY)
      address = {line1: '4404 Waterford Circle',
                 city: 'Nashville',
                 state: 'TN',
                 zipcode: '37211'}
      submit_patch("/companies/#{URI.escape('NEW COMPANY')}", {address: address})
      assert(@response.code[0] == "2", 
             "Couldn't update company's address (#{@response.body.inspect})")

      # Verify the address
      company = Company.where(name: "NEW COMPANY").first
      assert(company.address[:line1] == '4404 Waterford Circle',
             "Company address not added")

  end

  test "app can create companies with address" do
      add_static_permission(:CREATE, :COMPANY)
      msg = {company: {name: 'I AM A NEW COMPANY'},
             address: {line1: '436 English Ivy Drive',
                       city: 'Nashville',
                       state: 'Tennessee',
                       zipcode: '37211'}}
      submit_post("/companies", msg)
      assert(@response.code[0] == "2", 
             "Couldn't create company with address (#{@response.body.inspect})")

      # Check that the address was created
      company = Company.where(name: 'I AM A NEW COMPANY').first
      assert_not(company.address.nil?, 'Address not stored (nil)')
      assert(company.address[:line1] == '436 English Ivy Drive',
            'Address not stored correctly')

      # Update address
      add_static_permission(:UPDATE, :COMPANY)
      newAddress = {line1: '4404 Waterford Circle',
                    city: 'Nashville',
                    state: 'TN',
                    zipcode: '37211'}
      submit_patch("/companies/#{URI.escape(company.name)}", {address: newAddress})
      assert(@response.code[0] == "2", 
             "Couldn't update company's address (#{@response.body.inspect})")

      # Check that the address has been updated
      storedCompany = Company.where(name: 'I AM A NEW COMPANY').first
      storedAddress = storedCompany.address
      assert_not(storedAddress.nil?, "Address missing after update")
      assert(storedAddress[:line1] == '4404 Waterford Circle', 
             "Address not updated")
  end

  test "app can't create companies without correct perms" do
      company = {name: "NEW COMPANY"}
      submit_post("/companies", {company: company})
      assert(@response.code == "403", 
             "Could create company w/o perms (#{@response.body.inspect})")
  end

  # Service Types
  test "app can update service types with correct perms" do
      add_static_permission(:UPDATE, :SERVICE_TYPE)
      name = ServiceType.first.name
      desc = "NEW DESCRIPTION"
      msg = {description: desc}
      submit_patch("/service_types/#{URI.escape(name)}", {service_type: msg})
      assert(@response.code[0] == "2", 
             "Could not update service type (#{@response.body.inspect})")
  end

  test "app can't update service types without correct perms" do
      name = ServiceType.first.name
      desc = "NEW DESCRIPTION"
      msg = {description: desc}
      submit_patch("/service_types/#{URI.escape(name)}", {service_type: msg})
      assert(@response.code == "403", 
             "Could update service type w/o perms (#{@response.body.inspect})")
  end

  test "app can create/delete service types with correct perms" do
      permissionCount = Permission.all.count
      name = "Wrecker"
      serviceType = {name: name, description: "... wreckers and stuff"}
      add_static_permission(:CREATE, :SERVICE_TYPE)
      submit_post("/service_types", {service_type: serviceType})
      assert(@response.code[0] == "2", 
             "Could not create service type (#{@response.body.inspect})")

      # Permissions should be added to database
      permissionDiff = Permission.permission_types.count
      assert(permissionCount + permissionDiff == Permission.all.count,
            "Permissions were not created (#{permissionCount} + #{permissionDiff}"+
            " != #{Permission.all.count}")

      # Remove serviceType
      add_static_permission(:DESTROY, :SERVICE_TYPE)
      assert_difference('ServiceType.count', -1) do
        submit_destroy "/service_types/#{URI.escape(name)}"
      end

      # Permissions should be removed from database
      assert(permissionCount == Permission.all.count, 
            "Permissions have not been removed from database")
  end

  test "app can't delete service types without correct perms" do
      name = ServiceType.first[:name]
      submit_destroy "/service_types/#{URI.escape(name)}"
      assert(@response.code == "403", 
             "Could delete service type w/o perms (#{@response.body.inspect})")
  end

  test "app can't create service types without correct perms" do
      serviceType = {name: "Wrecker", description: "... wreckers and stuff"}
      submit_post("/service_types", {service_type: serviceType})
      assert(@response.code == "403", 
             "Could create service type w/o perms (#{@response.body.inspect})")
  end

  test "app can't create service types with duplicate name" do
      name = ServiceType.first.name
      serviceType = {name: name, description: "... wreckers and stuff"}
      add_static_permission(:CREATE, :SERVICE_TYPE)
      submit_post("/service_types", {service_type: serviceType})
      assert(@response.code[0] != "2", 
             "Could create service type w/ duplicate name (#{@response.code})")
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

  def submit_destroy (url)
    msg = {consumer_id: "BRIANBROLL",
           app_signature: @signature}

    delete "/v1#{url}", msg
  end

  def add_permission (permissions)
    assert permissions.count > 0, "No permissions!"

    permission = permissions.where(:service_type_id => @service_type.id).first
    assert_not_nil permission, "Permission is nil!"

    @app.permissions << permission # Add the given permission
    @app.save
  end

  def add_static_permission (action, target)
    action = StaticPermission.permission_types[action]
    target = StaticPermission.targets[target]
    permission = StaticPermission.where(:target => target)
                    .where(:permission_type => action).first
    assert_not_nil permission, 
      "Permission (action: #{action}, target: #{target}) is nil!"

    @app.static_permissions << permission # Add the given permission
    @app.save
  end

end
