class Topics::Cooking < Topics::Base
  def self.interest_matchers
    [/cook(ing)?/i]
  end

  def message
<<-EOS
I also enjoy an epic session in the kitchen. Have you cooked anything awesome lately? I've recently been obsessing over curry again after stealing some secret techniques from a friend. Yumm!
EOS
  end
end
