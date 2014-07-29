class TrustedApp < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  has_many :consumers


  # Recording who updated the permit info
  # TODO Uncomment
  #has_many :people
  #has_many :permits
  #has_many :companies
  #has_many :vehicles
  #has_many :violations
  #has_many :service_types
end
