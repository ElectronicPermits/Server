class Person < ActiveRecord::Base
  belongs_to :trusted_app
  belongs_to :company
  has_one :address, as: :addressable
  has_many :permits, as: :permitable
  has_and_belongs_to_many :vehicles

  validates :trusted_app, presence: true

  validates :first_name, presence: true
  validates :last_name, presence: true
end
