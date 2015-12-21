require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Topic do
  describe "#matches?" do
    it "is true if any interest matchers match the fragment" do
      t = TopicFactory.build(interest_matchers: ['foo', 'bar'])
      expect(t.matches?("some foo here")).to be
      expect(t.matches?("some bar here")).to be
    end

    it "is false when no interest matchers match the fragment" do
      t = TopicFactory.build(interest_matchers: ['foo', 'bar'])
      expect(t.matches?("no match here")).not_to be
    end
  end
end
