class Permit < ActiveRecord::Base
  belongs_to :permitable, polymorphic: true
  has_many :ratings
  has_many :services
  has_many :violations

  #Required attributes
  validates :permitable, presence: true
end
