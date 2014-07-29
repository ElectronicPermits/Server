class ServiceType < ActiveRecord::Base
  has_many :companies
  has_many :people, through: :companies
  has_many :permits, through: :people
  has_many :ratings, through: :permits
  has_many :services, through: :permits

  validates :name, uniqueness: true
end
