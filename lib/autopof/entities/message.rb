class Message < Sequel::Model(:messages)
  def self.messages_awaiting_response_for(username)
    join(:profiles, id: :profile_id).where(profiles__username: username).where(response: nil).select(Sequel.lit('messages.*'))
  end
end
