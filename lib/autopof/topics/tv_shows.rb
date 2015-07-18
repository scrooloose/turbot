class Topics::TvShows < Topics::Base
  def self.interest_matchers
    [/netflix|box\s*set/i]
  end

  def message(profile)
<<-EOS
I am also guilty of binge watching TV shows! The last was the 4th season of Homeland. I expect every new season of that show to be a trainwreck after the last season, but somehow it never is. What have you binged out on lately? :)
EOS
  end
end
