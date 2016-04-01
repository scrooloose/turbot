class Message < Sequel::Model(:messages)
  subset(:with_response, 'response IS NOT NULL')

  def self.messages_awaiting_response_for(username)
    join(:profiles, id: :profile_id).where(profiles__username: username).where(response: nil).select(Sequel.lit('messages.*'))
  end

  def self.create_sent_message(recipient: nil, content: nil)
    create(recipient_profile_id: recipient.id, content: content, sender_profile_id: Profile.me.id)
  end

  def self.create_received_message(sender: nil, content: nil, sent_at: nil)
    create(recipient_profile_id: Profile.me.id, content: content, sender_profile_id: sender.id, sent_at: sent_at)
  end

  def self.exists_for?(username: nil, sent_at: sent_at)
    join(:profiles, id: :sender_profile_id).where('profiles.username' => username, 'messages.sent_at' => sent_at).any?
  end
end
