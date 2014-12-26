class Company < ActiveRecord::Base
  belongs_to :trusted_app
  has_one :address, as: :addressable
  has_many :permit, as: :permitable
  has_many :people

  validates :trusted_app, presence: true
  validates :name, presence: true, uniqueness: true
end
