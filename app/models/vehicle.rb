class Vehicle < ActiveRecord::Base
  has_many :permits, as: :permitable
  has_and_belongs_to_many :people
end
