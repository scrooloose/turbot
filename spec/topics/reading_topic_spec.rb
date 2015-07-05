require File.dirname(__FILE__) + "/../spec_helper"

RSpec.describe Topics::Reading do
  describe '#match?' do
    it "is true for profiles with reading interests" do
      expect_topic_match(Topics::Reading, 'books')
      expect_topic_match(Topics::Reading, 'reading')
    end

    it "is false for profiles without reading interests" do
      expect_no_topic_match(Topics::Reading, 'horses')
    end
  end
end
