class MessageBuilder
  class NoMatchingInterestError < StandardError; end

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
    interests = profile.interests

    if interests.empty?
      raise(NoMatchingInterestError, "Could not build message. No interests matched")
    end

    template_messages = interests.map { |i| i.template_messages.find_by(user: sender_user) }.flatten.compact

    if template_messages.empty?
      raise(NoMatchingInterestError, "Could not build message. No template message matched")
    end

    template_messages.first.content.sub(/\n*$/, '')
  end

  def signoff
    sender_user.name
  end
end
