class AppRole < ActiveRecord::Base
  has_and_belongs_to_many :trusted_apps
end
