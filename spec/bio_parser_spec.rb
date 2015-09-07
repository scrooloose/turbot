require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#topics" do
    def test_likes(bio: nil, interests: nil, interest_matchers: [/bike|biking|cycle/])
      bp = BioParser.new(bio: bio, interest_matchers: interest_matchers)
      expect(bp.interests).to eq(interests)
    end

    it "recognizes interest matchers" do
      test_likes(bio: "I like biking and football", interests: ['biking'])
      test_likes(bio: "Love to cycle and try to get away for weekends as often as possible.", interests: ['cycle'])
      test_likes(bio: "My passion in life is my bike", interests: ['bike'])
      test_likes(bio: "I'm 27; I love biking, animals, doing anything in the barn.", interests: ['biking'])
      test_likes(bio: "I'm really into biking, anything from a chick flick to a", interests: ['biking'])
      test_likes(bio: "Really enjoy watching live biking and making pancakes.", interests: ['biking'])
      test_likes(bio: "In terms of hobbies, I enjoy biking and until recently played in a ladies darts team.", interests: ['biking'])
      test_likes(bio: "This girl loves positivity, biking, cheekiness, kisses, theatre and live performance. ", interests: ['biking'])
      test_likes(bio: "In my spare time I like to do the usual watch films and biking", interests: ['biking'])

    end

    it "doesn't recognize anti-interests" do
      bp = BioParser.new(bio: "I hate biking and football", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty
    end

    it "only checks 5 words into a sentence" do
      bp = BioParser.new(bio: "one two three four five I like to do the usual watch films and biking", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty
    end

  end
end
