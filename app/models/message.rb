class Message < ApplicationRecord
  belongs_to :sender_profile, class_name: "Profile"
  belongs_to :recipient_profile, class_name: "Profile"
end
