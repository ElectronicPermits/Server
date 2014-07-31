class Violation < ActiveRecord::Base
  belongs_to :trusted_app
  belongs_to :permit

  validates :permit, presence: true
  validates :trusted_app, presence: true

  validates :name, presence: true
end
