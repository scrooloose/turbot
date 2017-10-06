class PofSession
  attr_reader :webdriver, :search_pages_to_process, :messager, :dry_run, :error_email, :user

  def initialize(webdriver: nil, search_pages_to_process: 3, messager: nil, dry_run: true)
    @webdriver = webdriver
    @search_pages_to_process = search_pages_to_process
    @dry_run = dry_run
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
    if Rails.env.production?
      AdminMailer.error(error: e).deliver_now!
    else
      raise e
    end
  end
end
