require File.dirname(__FILE__) + "/../spec_helper"

RSpec.describe Topics::Biking do

  describe "#match?" do
    def expect_match(*interests)
      p = ProfileFactory.build(interests: interests)
      expect(Topics::Biking.new(profile: p).match?).to be
    end

    def expect_no_match(*interests)
      p = ProfileFactory.build(interests: interests)
      expect(Topics::Biking.new(profile: p).match?).not_to be
    end

    it "is true for profiles with biking interests" do
      expect_match('biking')
      expect_match('road biking')
      expect_match('mountain biking')
      expect_match('cycle touring')
      expect_match('cycling')
      expect_match('bike rides')
    end

    it "is false for profiles that mention motor biking" do
      expect_no_match("motorbikes")
      expect_no_match("motorbiking")
      expect_no_match("motor bikes")
      expect_no_match("motor biking")
    end
  end
end
