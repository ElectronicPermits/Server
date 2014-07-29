class Rating < ActiveRecord::Base
  belongs_to :service
  belongs_to :consumer
  belongs_to :permit

  # Required Attributes
  validates :rating, presence: true
  validates :permit, presence: true
  validates :consumer, presence: true
end
