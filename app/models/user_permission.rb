class UserPermission < ActiveRecord::Base
  ACTION_TYPES = [ ALL = 'all', CREATE = 'create', MODIFY = 'modify', DELETE = 'delete' ]
  TARGET_TYPES = [ USERS = 'users', TRUSTED_APPs = 'trusted_apps' ]

  has_and_belongs_to_many :user

  validates :action, presence: true,
    inclusion: { in: ACTION_TYPES }
  validates :target, presence: true, 
    inclusion: { in: TARGET_TYPES }
end
