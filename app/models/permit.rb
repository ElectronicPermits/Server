class Permit < ActiveRecord::Base
  has_many :documents, :ratings, :services
  belongs_to :person
end
