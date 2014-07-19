class Service < ActiveRecord::Base
  belongs_to :consumer
  belongs_to :permit
  belongs_to :rating
end
