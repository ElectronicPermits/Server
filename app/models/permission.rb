class Permission < ActiveRecord::Base
  #Permissions for managing permits of the given type
  enum permission_type: [ :RATE, 
                          :RECORD_SERVICE, 
                          :MANAGE_VIOLATIONS,
                          :MANAGE_PERMITS # Includes creating people, vehicles, companies
                                          # as these are issued permits
                        ]
  belongs_to :service_type
  has_and_belongs_to_many :trusted_apps

  validates :service_type, presence: true
  validates :permission_type, presence: true
end
