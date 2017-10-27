require "rails_helper"

RSpec.describe ReceivedMessageProcessor do
  it "forwards .perform onto #perform" do
    processor_double = instance_double(described_class)
    expect(processor_double).to receive(:perform)
    args = { username: "username", recipient: "recipient", sent_at: "sent_at", content: "content" }
    expect(described_class).to receive(:new).with(args).and_return(processor_double)
    described_class.perform(args)
  end

  describe "#perform" do
    it "ignores previously processed messages" do
      sender = create(:profile)
      receiver = create(:profile)
      message = sender.sent_message(recipient: receiver, content: "foo")
      described_class.new(recipient: receiver, username: sender.username, sent_at: message.sent_at, content: "foo").perform
    end

    context "when processing new messages" do
      it "saves the message" do
        expect {
          described_class.new(
            recipient: create(:profile),
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).perform
        }.to change(Message, :count).by(1)

      end

      it "creates a profile if one doesn't exist" do
        recipient = create(:profile)

        expect {
          described_class.new(
            recipient: recipient,
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).perform
        }.to change(Profile, :count).by(1)
      end

      it "doesn't create a profile if it already exists" do
        create(:profile, :emma)
        recipient = create(:profile)

        expect {
          described_class.new(
            recipient: recipient,
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).perform
        }.to_not change(Profile, :count)
      end
    end
  end
end
