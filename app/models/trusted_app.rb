class TrustedApp < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_and_belongs_to_many :static_permissions
  has_many :consumers


  # Recording who updated the permit info
  has_many :people
  has_many :permits
  has_many :companies
  has_many :vehicles
  has_many :violations
  has_many :service_types

  validates :sha_hash, uniqueness: true
  validates :app_name, presence: true
end
