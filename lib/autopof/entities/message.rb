class Message < Sequel::Model(:messages)
  many_to_one :sender_profile, key: :sender_profile_id, class: :Profile
  many_to_one :recipient_profile, key: :recipient_profile_id, class: :Profile

  def self.create_sent_message(recipient: nil, content: nil)
    create(recipient_profile_id: recipient.id, content: content, sender_profile_id: Profile.me.id, sent_at: Time.now)
  end

  def self.create_received_message(sender: nil, content: nil, sent_at: nil)
    create(recipient_profile_id: Profile.me.id, content: content, sender_profile_id: sender.id, sent_at: sent_at)
  end

  def self.received?(username: nil, sent_at: nil)
    join(:profiles, id: :sender_profile_id).where(profiles__username: username, messages__sent_at: sent_at).any?
  end
end
