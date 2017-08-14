# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create Static Permissions
StaticPermission.targets.each do |target, target_value|
  StaticPermission.permission_types.each do |perm_type, perm_type_value|
    StaticPermission.create({ target: target_value, permission_type: perm_type_value }).save
  end
end

# User Permissions
super_permissions = []
UserPermission.actions.each do |key, action|
  UserPermission.targets.each do |key2, target|
    permission = UserPermission.create({ action: action, target: target })
    permission.save
    if permission.action == UserPermission.actions["ALL"] then
      super_permissions.push(permission)
    end
  end
end

# Initial admin user
admin = User.create({ email: "admin@admin.com", password: "password", 
              password_confirmation: "password" })

super_permissions.each do |perm|
  admin.user_permissions << perm
end
admin.save

#Trusted App for self
web_interface = TrustedApp.create({ app_name: "Web Interface"})
web_interface.save

# Default Service Type
taxi = ServiceType.new({ name: "Taxi" })
taxi.trusted_app = web_interface
taxi.save

# TrustedApp Permissions for the Taxi
Permission.permission_types.each do |perm_type, perm_type_value|
  Permission.create({ service_type: taxi, permission_type: perm_type_value })
end

# If in development, create a trusted_app w/ all permissions
if Rails.env == 'development'

  def get_random(array)
      len = array.length
      return array[rand(len)]
  end
  def new_person(app, service_type)
      first_names = ['Adam', 'Steve', 'Brian', 'Dave', 'Jim']
      last_names = ['Miller', 'Scott', 'Smith', 'Broll', 'Thompson']

      person = Person.create(first_name: get_random(first_names),
                             last_name: get_random(last_names),
                             trusted_app: app)
      counter = Permit.all.length+1
      permit = Permit.new(permit_number: counter,
                          beacon_id: counter,
                          service_type: service_type,
                          permitable: person,
                          average_rating: rand(5),
                          total_ratings: rand(100).round,
                          valid: true)
      if not permit.save
          puts "Could not make permit #{permit.errors}"
      end

      return person
  end

  signature = 'DEV_APP'
  hash = Digest::SHA1.hexdigest(signature)
  dev_app = TrustedApp.create({app_name: "Development App", 
                               description: "Demo App used for testing.",
                               contact_name: "Brian Broll",
                               contact_email: "brian.broll@gmail.com",
                               sha_hash: hash})
  dev_app.save

  # Add permissions
  StaticPermission.all.each do |perm|
    dev_app.static_permissions << perm
  end
  Permission.all.each do |perm|
    dev_app.permissions << perm
  end
  dev_app.save

  # Create some companies
  companies = [
  {name: 'Allied Cab',
   url: 'www.nashvillecab.com', 
   average_rating: 50, 
   total_ratings: 23, 
   phone_number: '6153333333'},

  {name: 'Nashvegas Cab',
   url: 'www.taxicab.com', 
   average_rating: 1.2222222, 
   total_ratings: 18, 
   phone_number: '9524652618'},

  {name: 'Yellow Cab',
   url: 'www.taxicab.com', 
   average_rating: 3.222, 
   total_ratings: 12, 
   phone_number: '9524652618'},

  {name: 'Music City Cab',
   url: 'www.taxicab.com', 
   average_rating: 2.33, 
   total_ratings: 1, 
   phone_number: '9524652618'},

  {name: 'Green Cab',
   url: 'www.taxicab.com', 
   average_rating: 1, 
   total_ratings: 5, 
   phone_number: '9524652618'},

  {name: 'TaxiTaxi',
   url: 'www.taxicab.com', 
   average_rating: 4, 
   total_ratings: 12, 
   phone_number: '9524652618'},

  {name: 'Pink Cab',
   url: 'www.taxicab.com', 
   average_rating: 3, 
   total_ratings: 10, 
   phone_number: '9524652618'} ]

  companies.each do |company_info|
    company = Company.new(company_info)
    company.trusted_app = web_interface
    if not company.save 
      puts "Company Errors:\n#{company.errors.full_messages}"
    end

    # Issue a permit for the taxi service
    counter = Permit.all.length + 1
    permit = Permit.new(permit_number: counter, 
                        valid: true, 
                        beacon_id: counter,
                        service_type: taxi,
                        permitable: company)
    if not permit.save and company.save
      puts "Permit Errors:\n#{permit.errors.full_messages}"
    end

    # Add people to company
    [1..10].each do |t|
      company.people << new_person(web_interface, taxi)
    end

    if not company.save
      puts "Adding People Errors:\n#{company.errors.full_messages}"
    end
  end

  # TODO Add Permit and stuff

end
