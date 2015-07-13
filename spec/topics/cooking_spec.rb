require File.dirname(__FILE__) + "/../spec_helper"

RSpec.describe Topics::Biking do

  describe "#match?" do
    it "is true for profiles with cooking interests" do
      expect_topic_match(Topics::Cooking, 'cooking')
      expect_topic_match(Topics::Cooking, 'cook')
    end

    it "is false for profiles that mention motor biking" do
      expect_no_topic_match(Topics::Cooking, "motorbikes")
    end
  end
end
