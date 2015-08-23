class MessageRepository
  def self.instance
    @instance ||= new
  end

  def save(profile: nil, message: nil)
    #TODO: make this not suck
    profile_id = ProfileRepository.instance.find(pof_key: profile.pof_key).id

    DB[:messages].insert(content: message, profile_id: profile_id)
  end


private
  def initialize
  end
end
