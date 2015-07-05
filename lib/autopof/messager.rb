class Messager
  attr_reader :dry_run, :message_limit

  def initialize(dry_run: true, message_limit: 2)
    @dry_run = dry_run
    @message_limit = message_limit
  end

  def go
    profiles = ProfileRecord.messagable_profiles

    messages_sent = 0
    profiles.each do |profile|
      if msg_text = message_text_for(profile)
        Log.debug("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
        MessageSender.new(message: msg_text, profile: profile).run unless dry_run
        messages_sent += 1
      end

      break if messages_sent >= message_limit
    end
  end

private
  def message_text_for(profile)
    MessageBuilder.new(profile).message
  rescue MessageBuilder::NoMatchingTopicError
    nil
  end
end

