class ProfileInterest < ActiveRecord::Base
  belongs_to :profile
  belongs_to :interest
end
