class UserPermission < ActiveRecord::Base
  #ACTION_TYPES = Hash[ 'ALL', 'all', 'CREATE', 'create', 'MODIFY', 'modify', 'DELETE', 'delete' ]
  enum action: [ :ALL, :CREATE, :MODIFY, :DELETE ]
  enum target: [ :USERS, :TRUSTED_APPS ]
  #TARGET_TYPES = Hash[ 'USERS', 'users', 'TRUSTED_APPs', 'trusted_apps' ]

  has_and_belongs_to_many :user

  validates :action, presence: true
  validates :target, presence: true
end
