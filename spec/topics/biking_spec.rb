require File.dirname(__FILE__) + "/../spec_helper"

RSpec.describe Topics::Biking do

  describe "#match?" do
    it "is true for profiles with biking interests" do
      expect_topic_match(Topics::Biking, 'biking')
      expect_topic_match(Topics::Biking, 'road biking')
      expect_topic_match(Topics::Biking, 'mountain biking')
      expect_topic_match(Topics::Biking, 'cycle touring')
      expect_topic_match(Topics::Biking, 'cycling')
      expect_topic_match(Topics::Biking, 'bike rides')
    end

    it "is false for profiles that mention motor biking" do
      expect_no_topic_match(Topics::Biking, "motorbikes")
      expect_no_topic_match(Topics::Biking, "motorbiking")
      expect_no_topic_match(Topics::Biking, "motor bikes")
      expect_no_topic_match(Topics::Biking, "motor biking")
    end
  end
end
