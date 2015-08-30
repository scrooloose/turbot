class MessageRepository
  def self.instance
    @instance ||= new
  end

  def messages_awaiting_response_for(username)
    DB[:messages].join(:profiles, id: :profile_id).where(profiles__username: username).where(response: nil).select(Sequel.lit('messages.*'))
  end

  def save(profile: nil, message: nil)
    #TODO: make this not suck
    profile_id = ProfileRepository.instance.find(pof_key: profile.pof_key)[:id]

    DB[:messages].insert(content: message, profile_id: profile_id)
  end


private
  def initialize
  end
end
