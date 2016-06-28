module MessageFactory
  def self.create(params = {})
    profile = params.delete(:profile) || ProfileFactory.create
    profile.sent_message({recipient: profile, content: "the content"}.merge(params))
  end
  singleton_class.send(:alias_method, :create_sent, :create)
end
