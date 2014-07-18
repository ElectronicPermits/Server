class TrustedApp < ActiveRecord::Base
  has_many :consumers
  has_and_belongs_to_many :app_roles
end
