class Consumer < ActiveRecord::Base
  belongs_to :trusted_app
  has_many :services
  has_many :ratings

  #required
  validates :trusted_app, presence: true
end
