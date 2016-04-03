class PofSession
  attr_reader :webdriver, :search_pages_to_process, :messages_to_send, :dry_run, :error_email

  def initialize(webdriver: PofWebdriver::Base.new, search_pages_to_process: 3, messages_to_send: 2, dry_run: true, error_email: Config['admin_email'])
    @webdriver = webdriver
    @search_pages_to_process = search_pages_to_process
    @messages_to_send = messages_to_send
    @dry_run = dry_run
    @error_email = error_email
  end

  def run
    check_messages
    cache_profiles
    send_some_messages
  rescue Exception => e
    if AUTOPOF_ENV == "production"
      body = e.message + "\n" + e.backtrace.join("\n")
      Pony.mail(to: Config['admin_email'], from: Config['admin_email'], subject: 'Pofbot Error', body: body)
    else
      raise e
    end
  end

private

  def cache_profiles
    webdriver.cache_profiles_from_search_page(num_pages: search_pages_to_process)
  end

  def send_some_messages
    Messager.new(dry_run: dry_run, webdriver: webdriver, profiles: Profile.messagable(messages_to_send), sleep_strategy: webdriver.sleep_strategy).go
  end

  def check_messages
    webdriver.check_messages
  end
end
