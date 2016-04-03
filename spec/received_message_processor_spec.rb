require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe ReceivedMessageProcessor do
  describe "#go" do
    it "ignores previously processed messages" do
      sender = ProfileFactory.create
      message = MessageFactory.create_received(sender: sender)
      ReceivedMessageProcessor.new(username: sender.username, sent_at: message.sent_at).go
    end

    context "when processing new messages" do
      it "saves the message" do
        ReceivedMessageProcessor.new(
          username: "foo",
          sent_at: Time.now,
          content: "foo",
          profile_page: test_file_content('emma.html')
        ).go
      end

      it "creates a profile if one doesn't exist" do
        expect {
          ReceivedMessageProcessor.new(
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).go
        }.to change(Profile, :count).by(1)
      end

      it "doesn't create a profile if it already exists" do
        ProfileFactory.from_test_fixture('emma.html')

        expect {
          ReceivedMessageProcessor.new(
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).go
        }.to_not change(Profile, :count)
      end
    end
  end
end
