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

#User Permissions
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

#Initial admin user
admin = User.create({ email: "admin@admin.com", password: "password", 
              password_confirmation: "password" })

super_permissions.each do |perm|
  admin.user_permissions << perm
end
admin.save

#Trusted App for self
myself = TrustedApp.create({ app_name: "Web Interface"})
myself.save

# Default Service Type
taxi = ServiceType.new({ name: "Taxi" })
taxi.trusted_app = myself
taxi.save

# If in development, create a trusted_app w/ all permissions
if Rails.env == 'development'
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
end
