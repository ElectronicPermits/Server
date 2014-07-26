class Rating < ActiveRecord::Base
  belongs_to :consumer
  belongs_to :permit
  belongs_to :service

  # Required Attributes
  validates :rating, presence: true
  validates :permit, presence: true
  validates :consumer, presence: true
end
