module TopicFactory
  def self.build(name: "test", interest_matchers: [], message: "the message")
    Topic.new(name: name, matchers: interest_matchers.join("\n"), message: message)
  end
end
