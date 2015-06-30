module Topics; end

class Topics::Base
  attr_reader :profile
  def initialize(profile: profile)
    @profile = profile
  end

  def match?
  end

  def message
  end

protected
  def has_interest_matching?(*regexs)
    regexs.detect do |regex|
      if profile.interests.detect {|i| i =~ regex}
        return true
      end
    end
  end
end
