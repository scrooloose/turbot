class Profile
  attr_reader :pof_key, :username, :bio, :interests, :name

  def initialize(pof_key: nil, username: nil, bio: nil, interests: nil,
                 name: nil)
    @pof_key = pof_key
    @username = username
    @bio = bio
    @interests = interests
    @name = name
    parse_bio
  end

  def has_interest_matching?(*regexs)
    regexs.detect do |regex|
      if interests.detect {|i| i =~ regex}
        return true
      end
    end
  end

private

  def parse_bio
    bp = BioParser.new(bio: bio, interest_matchers: Topics::Base.all_interest_matchers)
    @interests.push(*bp.interests)
  end
end
