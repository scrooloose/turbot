class MessageFactory
  def self.create(params = {})
    profile = params.delete(:profile) || ProfileFactory.create
    Message.create({profile_id: profile.id, content: "the content"}.merge(params))
  end
end
