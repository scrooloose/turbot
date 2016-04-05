require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe Message do
  describe ".sent" do
    it "gets all messages sent from me" do
      sent = MessageFactory.create_sent
      MessageFactory.create_received

      expect(Message.sent.to_a).to eq([sent])
    end
  end

  describe ".received" do
    it "gets all messages received by me" do
      MessageFactory.create_sent
      received = MessageFactory.create_received

      expect(Message.received.to_a).to eq([received])
    end
  end

  describe ".responses" do
    it "gets all messages received by me in response to messages sent by me" do
      p = ProfileFactory.create
      MessageFactory.create_sent(recipient: p, sent_at: Time.now - 60)
      response = MessageFactory.create_received(sender: p, sent_at: Time.now - 30)

      #some controls
      MessageFactory.create_sent
      MessageFactory.create_received

      expect(Message.responses.to_a).to eq([response])
    end
  end

  describe ".create_sent_message" do
    let(:recipient) { ProfileFactory.create }
    subject { Message.create_sent_message(recipient: recipient, content: "foo") }

    it "creates messages from Me" do
      expect(subject.sender_profile).to eq(Profile.me)
    end

    it "uses the given message" do
      expect(subject.content).to eq("foo")
    end

    it "uses the current time for sent_at" do
      t = Time.now
      Timecop.freeze(t) do
        expect(subject.sent_at.to_s).to eq(t.to_s)
      end
    end
  end

  describe ".create_received_message" do
    let(:sender) { ProfileFactory.create }
    let(:time) { Time.now }
    subject { Message.create_received_message(sender: sender, content: "foo", sent_at: time) }

    it "creates messages to Me" do
      expect(subject.recipient_profile).to eq(Profile.me)
    end

    it "uses the given message" do
      expect(subject.content).to eq("foo")
    end

    it "uses the given time for sent_at" do
      expect(subject.sent_at.to_s).to eq(time.to_s)
    end

  end

  describe ".received?" do
    it "is true if we have received a message from the given username at the given time" do
      p = ProfileFactory.create(username: "foobar")
      m = MessageFactory.create_received(profile: p)
      expect(Message.received?(username: "foobar", sent_at: m.sent_at)).to be
    end

    it "is false unless a Message exists for the given username and time" do
      m = MessageFactory.create_received(profile: p)

      expect(Message.received?(username: "foobar", sent_at: Time.now)).to_not be
      expect(Message.received?(username: m.sender_profile.username, sent_at: Time.now - 1000)).to_not be
    end
  end
end

