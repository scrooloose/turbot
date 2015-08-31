require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Message do
  describe ".messages_awaiting_response_for" do
    it "returns messages with no response" do
      p = ProfileFactory.create
      MessageFactory.create(response: "the response", responded_at: DateTime.now, profile: p)
      m = MessageFactory.create(profile: p)

      expect(Message.messages_awaiting_response_for(p.username).to_a).to eq([m])
    end
  end
end

