class Rating < ActiveRecord::Base
  belongs_to :consumer
  belongs_to :permit
  belongs_to :service
end
