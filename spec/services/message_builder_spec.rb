require "rails_helper"

RSpec.describe MessageBuilder do
  describe "#message" do
    before do
      @biking = create(:interest, :biking)
      @sender = create(:user)
      @template_message = create(:template_message, interest: @biking, user: @sender, content: "I like biking")
    end

    it "opens with 'How's it going [name]?' if the profile has a name" do
      p = build(:profile, name: "Jane", interests: [@biking])
      expect(described_class.new(profile: p, sender_user: @sender).perform).to start_with("How's it going Jane?")
    end

    it "opens with 'How's it going?' if the profile has no name" do
      p = build(:profile, name: nil, interests: [@biking])
      expect(described_class.new(profile: p, sender_user: @sender).perform).to start_with("How's it going?")
    end

    it "has a body from a template message" do
      p = build(:profile, interests: [@biking])

      #just check the message mentions biking... not exactly an exhaustive test
      #but enough for now
      expect(described_class.new(profile: p, sender_user: @sender).perform).to include("biking")
    end
  end
end
