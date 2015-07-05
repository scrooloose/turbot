module TopicHelpers
  def expect_topic_match(topic_class, *interests)
    p = ProfileFactory.build(interests: interests)
    expect(topic_class.new(profile: p).match?).to be
  end

  def expect_no_topic_match(topic_class, *interests)
    p = ProfileFactory.build(interests: interests)
    expect(topic_class.new(profile: p).match?).not_to be
  end
end
