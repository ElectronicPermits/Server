class Vehicle < ActiveRecord::Base
  belongs_to :trusted_app
  has_many :permits, as: :permitable
  has_and_belongs_to_many :people

  validates :trusted_app, presence: true
  #validates :people, presence: true

  validates :make, presence: true
  validates :model, presence: true
  validates :license_plate, presence: true, uniqueness: true
end
