class Topics::Reading < Topics::Base
  def match?
    has_interest_matching?(/books|reading/i)
  end

  def message
<<-EOS
I also read a lot - always have something on the go. Have you read anything awesome recently? The most interesting thing I've read lately was The Handmaid's Tale (Margaret Atwood).
EOS
  end
end
