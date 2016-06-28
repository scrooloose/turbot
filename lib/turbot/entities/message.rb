class Message < ActiveRecord::Base
  belongs_to :sender_profile, class_name: "Profile"
  belongs_to :recipient_profile, class_name: "Profile"
end
