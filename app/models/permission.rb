class Permission < ActiveRecord::Base
  PERMISSION_TYPES = [ MANAGE = 'manage', CREATE = 'create', MODIFY = 'modify', DELETE = 'delete', RATE = 'rate', RECORD_SERVICE  = 'record_service' ]
  belongs_to :service_type
  has_and_belongs_to_many :trusted_apps

  validates :service_type, presence: true
  validates :permission_type, presence: true, 
    inclusion: { in: PERMISSION_TYPES }
end
