class Service < ActiveRecord::Base
  belongs_to :consumer
  belongs_to :permit
  belongs_to :rating

  # Required Attributes
  validates :permit, presence: true
  validates :consumer, presence: true
end
