require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#message" do
    it "opens with 'Hi [name]' if the profile has a name" do
      p = ProfileFactory.build(name: "Jane", interests: ["biking"])
      expect(MessageBuilder.new(p).message).to start_with("Hi Jane")
    end

    it "opens with 'Hi there!' if the profile has no name" do
      p = ProfileFactory.build(name: nil, interests: ["biking"])
      expect(MessageBuilder.new(p).message).to start_with("Hi there!")
    end

    it "has a body from a topic" do
      p = ProfileFactory.build(interests: ["biking"])

      #just check the message mentions biking... not exactly an exhaustive test
      #but enough for now
      expect(MessageBuilder.new(p).message).to include("biking")
    end
  end
end
