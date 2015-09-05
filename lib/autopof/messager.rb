class Messager
  attr_reader :dry_run, :message_limit, :webdriver

  def initialize(dry_run: true, message_limit: 2, webdriver: nil)
    @dry_run = dry_run
    @message_limit = message_limit
    @webdriver = webdriver || PofWebdriver::Base.new
  end

  def go
    Profile.messagable(message_limit).each do |profile|
      msg_text = MessageBuilder.new(profile).message
      Log.info("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
      webdriver.send_message(message: msg_text, profile: profile) unless dry_run
    end
  end
end

