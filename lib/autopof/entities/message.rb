class Message < Sequel::Model(:messages)
  subset(:with_response, 'response IS NOT NULL')

  def self.messages_awaiting_response_for(username)
    join(:profiles, id: :profile_id).where(profiles__username: username).where(response: nil).select(Sequel.lit('messages.*'))
  end
end
