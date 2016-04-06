class Messager
  attr_reader :dry_run, :profiles, :webdriver, :sleep_strategy, :attempts

  def initialize(dry_run: true, profiles: nil, webdriver: PofWebdriver::Base.new, sleep_strategy: SleepStrategy.new, attempts: 3)
    @dry_run = dry_run
    @profiles = profiles
    @webdriver = webdriver
    @sleep_strategy = sleep_strategy
    @attempts = attempts
  end

  def go
    profiles.each do |profile|
      msg_text = MessageBuilder.new(profile).message
      Log.info("Messenger#go - Sending message to #{profile.username}. Message: #{msg_text}")
      attempt_to_send(msg_text, profile)
      sleep_strategy.sleep
    end
  end

private
  def attempt_to_send(msg, profile)
    cur_attempt = 1

    begin
      webdriver.send_message(message: msg, profile: profile) unless dry_run
      Message.create_sent_message(recipient: profile, content: msg)
    rescue PofWebdriver::Error => e
      if cur_attempt <= attempts
        cur_attempt += 1
        retry
      else
        profile.make_unavailable!
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

