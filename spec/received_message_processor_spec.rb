require File.dirname(__FILE__) + "/spec_helper"

RSpec.describe ReceivedMessageProcessor do
  it "forwards .process_message onto #process_message" do
    processor_double = instance_double(ReceivedMessageProcessor)
    expect(processor_double).to receive(:process_message)
    expect(ReceivedMessageProcessor).to receive(:new).with(username: "foo").and_return(processor_double)
    ReceivedMessageProcessor.process_message(username: "foo")
  end

  describe "#process_message" do
    it "ignores previously processed messages" do
      sender = ProfileFactory.create
      message = MessageFactory.create_received(sender: sender)
      ReceivedMessageProcessor.new(username: sender.username, sent_at: message.sent_at).process_message
    end

    context "when processing new messages" do
      it "saves the message" do
        ReceivedMessageProcessor.new(
          username: "foo",
          sent_at: Time.now,
          content: "foo",
          profile_page: test_file_content('emma.html')
        ).process_message
      end

      it "creates a profile if one doesn't exist" do
        expect {
          ReceivedMessageProcessor.new(
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).process_message
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
          ).process_message
        }.to_not change(Profile, :count)
      end
    end
  end
end
