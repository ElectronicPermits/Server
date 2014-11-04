class Permission < ActiveRecord::Base
  #Permissions for managing permits of the given type
  PERMISSION_TYPES = [ MANAGE = 'manage', CREATE = 'create', MODIFY = 'modify', DELETE = 'delete', RATE = 'rate', RECORD_SERVICE  = 'record_service' ]
  belongs_to :service_type
  has_and_belongs_to_many :trusted_apps

  validates :service_type, presence: true
  validates :permission_type, presence: true, 
    inclusion: { in: PERMISSION_TYPES }
end
