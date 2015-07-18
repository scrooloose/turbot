class Topics::GameOfThrones < Topics::Base
  def self.interest_matchers
    [/game of thrones/i]
  end

  def message(profile)
<<-EOS
I also (like everyone it seems) have been following Game of Thrones over the years. That show is pretty addictive, but they should definitely give up and rename it to Game of Porn!
EOS
  end
end
