class Message < Sequel::Model(:messages)
  def_dataset_method(:sent) do
    where(sender_profile_id: Profile.me.id)
  end

  def_dataset_method(:received) do
    where(recipient_profile_id: Profile.me.id)
  end

  def_dataset_method(:responses) do
    from(Sequel.lit('messages AS received_msgs')).
    where(recipient_profile_id: Profile.me.id).
    where('EXISTS (SELECT * FROM messages WHERE recipient_profile_id = received_msgs.sender_profile_id)')
  end

  many_to_one :sender_profile, key: :sender_profile_id, class: :Profile
  many_to_one :recipient_profile, key: :recipient_profile_id, class: :Profile

  def self.create_sent_message(recipient: nil, content: nil, sent_at: Time.now)
    create(recipient_profile_id: recipient.id, content: content, sender_profile_id: Profile.me.id, sent_at: sent_at)
  end

  def self.create_received_message(sender: nil, content: nil, sent_at: nil)
    create(recipient_profile_id: Profile.me.id, content: content, sender_profile_id: sender.id, sent_at: sent_at)
  end

  def self.received?(username: nil, sent_at: nil)
    join(:profiles, id: :sender_profile_id).where(profiles__username: username, messages__sent_at: sent_at).any?
  end
end
