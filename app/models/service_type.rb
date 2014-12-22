class ServiceType < ActiveRecord::Base
  belongs_to :trusted_app

  has_many :permissions
  has_many :permits
  #has_many :companies
  has_many :people, through: :companies
  # more than just people can have permits

  validates :name, uniqueness: true
  validates :trusted_app, presence: true
end
