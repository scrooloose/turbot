class Topic
  attr_reader :name, :interest_matchers, :message

  def initialize(name: nil, interest_matchers: nil, message: nil)
    @interest_matchers = interest_matchers.map {|s| Regexp.new(s, Regexp::IGNORECASE)}
    @message = message
  end

  def match?(profile)
    profile.has_interest_matching?(interest_matchers)
  end
end
