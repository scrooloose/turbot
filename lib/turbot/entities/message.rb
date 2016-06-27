class Message < ActiveRecord::Base
  scope :sent, ->{ where(sender_profile_id: Profile.me.id) }
  scope :received, -> { where(recipient_profile_id: Profile.me.id) }

  scope :responses, -> {
    select('*').
    from('messages as received_msgs').
    where("received_msgs.recipient_profile_id" => Profile.me.id).
    where('EXISTS (SELECT *
                   FROM messages
                   WHERE messages.recipient_profile_id = received_msgs.sender_profile_id)')
  }

  belongs_to :sender_profile, class_name: "Profile"
  belongs_to :recipient_profile, class_name: "Profile"

  def self.create_sent_message(recipient: nil, content: nil, sent_at: Time.now)
    create(recipient_profile_id: recipient.id, content: content, sender_profile_id: Profile.me.id, sent_at: sent_at)
  end

  def self.create_received_message(sender: nil, content: nil, sent_at: nil)
    create(recipient_profile_id: Profile.me.id, content: content, sender_profile_id: sender.id, sent_at: sent_at)
  end

  def self.received?(username: nil, sent_at: nil)
    received.joins(:sender_profile).where("profiles.username = ?", username).where("messages.sent_at" => sent_at).any?
  end
end
