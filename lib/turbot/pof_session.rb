class PofSession
  attr_reader :webdriver, :search_pages_to_process, :messager, :dry_run, :error_email, :user

  def initialize(webdriver: nil, search_pages_to_process: 3, messager: nil, dry_run: true, error_email: Config['admin_email'])
    @webdriver = webdriver
    @search_pages_to_process = search_pages_to_process
    @dry_run = dry_run
    @error_email = error_email
    @messager = messager || raise(ArgumentError)
  end

  def run
    check_messages
    cache_profiles
    send_some_messages
  end

private

  def cache_profiles
    webdriver.cache_profiles_from_search_page(num_pages: search_pages_to_process)
  rescue StandardError => e
    handle_error(e)
  end

  def send_some_messages
    messager.go
  rescue StandardError => e
    handle_error(e)
  end

  def check_messages
    webdriver.check_messages
  rescue StandardError => e
    handle_error(e)
  end

  def handle_error(e)
    if TURBOT_ENV == "production"
      body = e.message + "\n" + e.backtrace.join("\n")
      Pony.mail(to: error_email, from: error_email, subject: 'Pofbot Error', body: body)
    else
      raise e
    end
  end
end
