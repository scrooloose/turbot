class Topics::Biking < Topics::Base
  def match?
    has_interest_matching?(
      /(?<!motor |motor)bik(e|ing)|cycling/i,
      /(bike|cycle) ?touring/i
    )
  end

  def message

<<-EOS
I see you're into biking. Have you been on any good rides lately? In the last couple of years I've been quite taken with the road riding in the UK.
EOS

  end
end
