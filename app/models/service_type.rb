class ServiceType < ActiveRecord::Base
  belongs_to :trusted_app

  has_many :permissions
  has_many :permits

  validates :name, uniqueness: true
  validates :trusted_app, presence: true
end
