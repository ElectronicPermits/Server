class Violation < ActiveRecord::Base
  belongs_to :permit

  validates :permit, presence: true
end
