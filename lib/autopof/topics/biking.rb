class Topics::Biking < Topics::Base
  def self.interest_matchers
    [/(?<!motor |motor)bik(e|ing)|cycling/i,
     /(bike|cycle) ?touring/i]
  end

  def message(profile)

<<-EOS
I see you're into biking. Have you been on any good rides lately? In the last couple of years I've been quite taken with the road riding in the UK.
EOS

  end
end
