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
    topics.each do |t|
      if t.match?
        return t.message
      end
    end

    raise "Could not build message. No topics matched"
  end

  def topics
    @topics ||= [Topics::Biking.new(profile: profile)]
  end

  def signoff
    "Martin"
  end
end
