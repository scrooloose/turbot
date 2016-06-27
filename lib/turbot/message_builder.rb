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
    if profile.topics.empty?
      raise(NoMatchingTopicError, "Could not build message. No topics matched")
    end

    profile.topics.first.message.sub(/\n*$/, '')
  end

  def signoff
    Config['name']
  end
end
