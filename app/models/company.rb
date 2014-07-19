class Company < ActiveRecord::Base
  has_one :address, as: :addressable
  has_many :permit, as: :permitable
  has_one :service_type
  has_many :people
  #has_many :permits, through: :people
  #has_many :ratings, through: :permits
  #has_many :services, through: :permits
end
