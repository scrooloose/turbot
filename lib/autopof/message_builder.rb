class MessageBuilder
  attr_reader :profile

  def initialize(profile)
    @profile = profile
  end

  def message
    "#{greeting}\n#{body}\n#{signoff}"
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
      topic = topic_class.new(profile: profile)
      if topic.match?
        return topic.message
      end
    end

    raise "Could not build message. No topics matched"
  end

  def signoff
    "Martin"
  end
end
