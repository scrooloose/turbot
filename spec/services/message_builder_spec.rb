require "rails_helper"

RSpec.describe MessageBuilder do
  describe "#message" do
    before do
      create(:topic, :likes_biking)
    end

    it "opens with 'How's it going [name]?' if the profile has a name" do
      create(:topic, :likes_biking)
      p = build(:profile, name: "Jane", interests: ["biking"])
      expect(MessageBuilder.new(profile: p, sender_user: create(:user)).message).to start_with("How's it going Jane?")
    end

    it "opens with 'How's it going?' if the profile has no name" do
      p = build(:profile, name: nil, interests: ["biking"])
      expect(MessageBuilder.new(profile: p, sender_user: create(:user)).message).to start_with("How's it going?")
    end

    it "has a body from a topic" do
      p = build(:profile, interests: ["biking"])

      #just check the message mentions biking... not exactly an exhaustive test
      #but enough for now
      expect(MessageBuilder.new(profile: p, sender_user: create(:user)).message).to include("biking")
    end
  end
end
