class Messager
  attr_reader :dry_run, :message_limit, :webdriver, :sleep_between_msgs, :retries

  def initialize(dry_run: true, message_limit: 2, webdriver: PofWebdriver::Base.new, sleep_between_msgs: true, retries: 3)
    @dry_run = dry_run
    @message_limit = message_limit
    @webdriver = webdriver || PofWebdriver::Base.new
    @sleep_between_msgs = sleep_between_msgs
    @retries = retries
  end

  def go
    Profile.messagable(message_limit).each do |profile|
      msg_text = MessageBuilder.new(profile).message
      Log.info("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
      attempt_to_send(msg_text, profile)
      sleep(rand(60) + 60) if sleep_between_msgs
    end
  end

private
  def attempt_to_send(msg, profile)
    attempts = 0

    begin
      webdriver.send_message(message: msg, profile: profile, dry_run: dry_run)
    rescue StandardError => e
      if attempts < retries
        attempts += 1
        retry
      else
        #vomit out stuff to stdout since cron will email that to us - i.e.
        #effectively emailing us the error report
        if AUTOPOF_ENV != 'test'
          puts "Failed to send message to #{profile.username}"
          puts e.message
          puts e.backtrace
        end
      end
    end
  end

end

