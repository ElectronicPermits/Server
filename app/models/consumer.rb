class Consumer < ActiveRecord::Base
  belongs_to :trusted_app
  has_many :services, :ratings
end
