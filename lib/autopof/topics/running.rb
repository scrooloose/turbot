class Topics::Running < Topics::Base
  def self.interest_matchers
    [/running/i]
  end

  def message(profile)
<<-EOS
I also like running. Are you signed up for any upcoming events? I'm running the Bristol half marathon this year (finally!).
EOS
  end
end
