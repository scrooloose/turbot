module Topics; end

class Topics::Base
  def self.all_topics
    #TODO: Probably do something more clever here.
    #NOTE: The order is important as the first match will be messaged
    [Topics::Biking, Topics::Reading, Topics::Running]
  end

  def self.all_interest_matchers
    all_topics.inject([]) do |all_matchers,topic|
      all_matchers.push(*topic.interest_matchers)
    end
  end

  def self.interest_matchers
    raise("Not implemented")
  end

  def match?(profile)
    profile.has_interest_matching?(interest_matchers)
  end

  def message(profile)
    raise("Not implemented")
  end

end
