class Permission < ActiveRecord::Base
  belongs_to :service_type
  has_and_belongs_to_many :trusted_apps

  validates :service_type, presence: true
end
