module TopicHelpers
  def expect_topic_match(topic_class, *interests)
    p = ProfileFactory.build(interests: interests)
    expect(topic_class.new.match?(p)).to be
  end

  def expect_no_topic_match(topic_class, *interests)
    p = ProfileFactory.build(interests: interests)
    expect(topic_class.new.match?(p)).not_to be
  end
end
