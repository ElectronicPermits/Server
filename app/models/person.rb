class Person < ActiveRecord::Base
  has_one :address, as :addressable
  belongs_to :company
  has_many :permits
  has_and_belongs_to_many :vehicles
end
