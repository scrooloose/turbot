class MessageBuilder
  class NoMatchingTopicError < StandardError; end

  attr_reader :profile

  def initialize(profile)
    @profile = profile
  end

  def message
    "#{greeting} #{body}\n#{signoff}"
  end

private

  def greeting
    if profile.name
      "How's it going #{profile.name.capitalize}?"
    else
      "How's it going?"
    end
  end

  def body
    TopicRegistryInstance.topics.each do |topic|
      if topic.match?(profile)
        return topic.message.sub(/\n*$/, '')
      end
    end

    raise(NoMatchingTopicError, "Could not build message. No topics matched")
  end

  def signoff
    Config['name']
  end
end
