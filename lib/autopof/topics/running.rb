class Topics::Running < Topics::Base
  def match?
    has_interest_matching?(/running/i)
  end

  def message
<<-EOS
I also like running. Are you signed up for any upcoming events? I'm running the Bristol half marathon this year (finally!).
EOS
  end
end
