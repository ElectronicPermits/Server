class StaticPermission < ActiveRecord::Base
  has_and_belongs_to_many :trusted_apps
  enum permission_type: [ :CREATE, 
                          :UPDATE, 
                          :DESTROY,
                          :ALL
                        ]
  # Things that can be created by trusted app
  enum target: [ :ADDRESS, 
                 :COMPANY, 
                 :PERSON, 
                 :SERVICE_TYPE, 
                 :VEHICLE
               ]

  validates :target, presence: true
  validates :permission_type, presence: true
 end
