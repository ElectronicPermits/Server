class Person < ActiveRecord::Base
  has_one :address, as: :addressable
  has_many :permits, as: :permitable
  belongs_to :company
  has_and_belongs_to_many :vehicles
end
