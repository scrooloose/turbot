class TopicRegistry
  attr_reader :topics

  def initialize
    @topics = []
  end

  def all_interest_matchers
    topics.map(&:interest_matchers).flatten
  end

  def add(topic)
    topics << topic
  end

  def add_from_file(fname)
    yml = YAML.load_file(fname)
    yml['topics'].each do |topic_hash|
      t = Topic.new(name: topic_hash['name'],
                    interest_matchers: topic_hash['interest_matchers'],
                    message: topic_hash['message'])
      add(t)
    end
  end

  def matching(bio_fragment)
    topics.select {|t| t.matches?(bio_fragment)}
  end
end
