class MessageFactory
  def self.create(params = {})
    profile = params.delete(:profile) || ProfileFactory.create
    Message.create_sent_message({recipient: profile, content: "the content"}.merge(params))
  end
end
