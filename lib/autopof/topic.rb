class Topic
  attr_reader :name, :interest_matchers, :message

  def initialize(name: nil, interest_matchers: nil, message: nil)
    @name = name
    @interest_matchers = interest_matchers.map {|s| Regexp.new(s, Regexp::IGNORECASE)}
    @message = message
  end

  def matches?(bio_fragment)
    interest_matchers.any? do |regex|
      bio_fragment.match(regex)
    end
  end
end
