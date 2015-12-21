class TopicFactory
  def self.build(name: "test", interest_matchers: [], message: "the message")
    Topic.new(name: name, interest_matchers: interest_matchers, message: message)
  end
end
