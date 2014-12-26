class ServiceType < ActiveRecord::Base
  belongs_to :trusted_app

  has_many :permissions
  has_many :permits

  # Convenience Associations
  has_many :companies, through: :permits, source: :permitable, source_type: "Company"
  has_many :people, through: :permits, source: :permitable, source_type: "Person"
  has_many :vehicles, through: :permits, source: :permitable, source_type: "Vehicle"
  has_many :services, through: :permits

  validates :name, uniqueness: true
  validates :trusted_app, presence: true
end
