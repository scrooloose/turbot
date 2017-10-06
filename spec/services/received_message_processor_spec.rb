require "rails_helper"

RSpec.describe ReceivedMessageProcessor do
  it "forwards .process_message onto #process_message" do
    processor_double = instance_double(ReceivedMessageProcessor)
    expect(processor_double).to receive(:process_message)
    expect(ReceivedMessageProcessor).to receive(:new).with(username: "foo").and_return(processor_double)
    ReceivedMessageProcessor.process_message(username: "foo")
  end

  describe "#process_message" do
    it "ignores previously processed messages" do
      sender = create(:profile)
      receiver = create(:profile)
      message = sender.sent_message(recipient: receiver, content: "foo")
      ReceivedMessageProcessor.new(recipient: receiver, username: sender.username, sent_at: message.sent_at, content: "foo").process_message
    end

    context "when processing new messages" do
      it "saves the message" do
        expect {
          ReceivedMessageProcessor.new(
            recipient: create(:profile),
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).process_message
        }.to change(Message, :count).by(1)

      end

      it "creates a profile if one doesn't exist" do
        recipient = create(:profile)

        expect {
          ReceivedMessageProcessor.new(
            recipient: recipient,
            username: "foo",
            sent_at: Time.now,
            content: "foo",
            profile_page: test_file_content('emma.html')
          ).process_message
        }.to change(Profile, :count).by(1)
      end

      it "doesn't create a profile if it already exists" do
        create(:profile, :emma)
        recipient = create(:profile)

        expect {
          ReceivedMessageProcessor.new(
            recipient: recipient,
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
