class Rating < ActiveRecord::Base
  belongs_to :consumer, :permit, :service
end
