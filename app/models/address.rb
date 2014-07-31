class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :addressable, presence: true
end
