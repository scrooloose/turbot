class MessageBuilder
  class NoMatchingTopicError < StandardError; end

  attr_reader :profile, :sender_user

  def initialize(profile:, sender_user:)
    @profile = profile
    @sender_user = sender_user
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
    sender_user.name
  end
end
