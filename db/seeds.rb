# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#User Permissions
super_permissions = []
UserPermission::ACTION_TYPES.each do |action|
  UserPermission::TARGET_TYPES.each do |target|
    permission = UserPermission.create({ action: action, target: target })
    if permission.action == UserPermission::ALL then
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

#Trusted App for self

#Default Service Type
# Taxis
#TODO
