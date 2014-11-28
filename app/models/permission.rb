class Permission < ActiveRecord::Base
  #Permissions for managing permits of the given type
  enum permission_type: [ :RATE, :RECORD_SERVICE ]
  belongs_to :service_type
  has_and_belongs_to_many :trusted_apps

  validates :service_type, presence: true
  validates :permission_type, presence: true
end
