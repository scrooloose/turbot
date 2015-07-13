require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#topics" do
    def test_likes(bio: nil, interests: nil, interest_matchers: [/biking/])
    end

    it "recognizes interest matchers" do
      bp = BioParser.new(bio: "I like biking and football", interest_matchers: [/biking/])
      expect(bp.interests).to eq(['biking'])
    end

    it "doesn't recognize anti-interests" do
      bp = BioParser.new(bio: "I hate biking and football", interest_matchers: [/biking/])
      expect(bp.interests).to be_empty
    end

  end
end
