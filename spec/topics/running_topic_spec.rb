require File.dirname(__FILE__) + "/../spec_helper"

RSpec.describe Topics::Running do
  describe '#match?' do
    it "is true for profiles with running interests" do
      expect_topic_match(Topics::Running, 'running')
    end

    it "is false for profiles without running interests" do
      expect_no_topic_match(Topics::Running, 'horses')
    end
  end
end
