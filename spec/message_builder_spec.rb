require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe MessageBuilder do
  describe "#message" do
    it "opens with 'How's it going [name]?' if the profile has a name" do
      p = ProfileFactory.build(name: "Jane", interests: ["biking"])
      expect(MessageBuilder.new(p, sender_user: UserFactory.create).message).to start_with("How's it going Jane?")
    end

    it "opens with 'How's it going?' if the profile has no name" do
      p = ProfileFactory.build(name: nil, interests: ["biking"])
      expect(MessageBuilder.new(p, sender_user: UserFactory.create).message).to start_with("How's it going?")
    end

    it "has a body from a topic" do
      p = ProfileFactory.build(interests: ["biking"])

      #just check the message mentions biking... not exactly an exhaustive test
      #but enough for now
      expect(MessageBuilder.new(p, sender_user: UserFactory.create).message).to include("biking")
    end
  end
end
