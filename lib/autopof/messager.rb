class Messager
  attr_reader :dry_run, :message_limit, :webdriver, :sleep_between_msgs

  def initialize(dry_run: true, message_limit: 2, webdriver: nil, sleep_between_msgs: true)
    @dry_run = dry_run
    @message_limit = message_limit
    @webdriver = webdriver || PofWebdriver::Base.new
    @sleep_between_msgs = sleep_between_msgs
  end

  def go
    Profile.messagable(message_limit).each do |profile|
      msg_text = MessageBuilder.new(profile).message
      Log.info("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
      attempt_to_send(msg_text, profile) unless dry_run
      sleep(rand(60) + 60) if sleep_between_msgs
    end
  end

private
  def attempt_to_send(msg, profile)
    webdriver.send_message(message: msg, profile: profile)
  rescue StandardError => e
    #vomit out stuff to stdout since cron will email that to us - i.e.
    #effectively emailing us the error report
    puts "Failed to send message to #{profile.username}"
    puts e.message
    puts e.backtrace
  end
end

