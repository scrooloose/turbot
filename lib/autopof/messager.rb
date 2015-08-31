class Messager
  attr_reader :dry_run, :message_limit, :webdriver

  def initialize(dry_run: true, message_limit: 2, webdriver: nil)
    @dry_run = dry_run
    @message_limit = message_limit
    @webdriver = webdriver || PofWebdriver::Base.new
  end

  def go
    profiles = Profile.messagable

    messages_sent = 0
    profiles.each do |profile|
      if msg_text = message_text_for(profile)
        Log.debug("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
        webdriver.send_message(message: msg_text, profile: profile) unless dry_run
        messages_sent += 1
      else
        Log.debug("Messenger#go - Could not send a message to #{profile.username}.")
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

