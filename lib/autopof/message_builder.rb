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
      "Hi #{profile.name.capitalize},"
    else
      "Hi there!"
    end
  end

  def body
    Topics::Base.all_topics.each do |topic_class|
      topic = topic_class.new
      if topic.match?(profile)
        return topic.message(profile).sub(/\n*$/, '')
      end
    end

    raise(NoMatchingTopicError, "Could not build message. No topics matched")
  end

  def signoff
    "Martin"
  end
end
