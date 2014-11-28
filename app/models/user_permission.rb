class UserPermission < ActiveRecord::Base
  enum action: [ :ALL, :CREATE, :MODIFY, :DELETE ]
  enum target: [ :USERS, :TRUSTED_APPS ]

  has_and_belongs_to_many :user

  validates :action, presence: true
  validates :target, presence: true
end
