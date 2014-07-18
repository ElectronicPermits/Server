class Service < ActiveRecord::Base
  belongs_to :consumer, :permit, :rating
end
