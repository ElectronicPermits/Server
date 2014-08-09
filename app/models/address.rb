class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :addressable, presence: true
  validates :line1, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
end
