class Permit < ActiveRecord::Base
  belongs_to :trusted_app
  belongs_to :service_type
  belongs_to :permitable, polymorphic: true
  has_many :ratings
  has_many :services
  has_many :violations

  #Required attributes
  validates :permitable, presence: true

  validates :beacon_id, presence: true, uniqueness: true
  validates :valid, presence: true
  validates :permit_number, presence: true, uniqueness: true
end
