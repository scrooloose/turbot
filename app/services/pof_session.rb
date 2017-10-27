class PofSession
  attr_reader :webdriver, :search_pages_to_process, :messager, :dry_run, :error_email, :user

  def initialize(webdriver:, search_pages_to_process: 3, messager:, dry_run: true)
    @webdriver = webdriver
    @search_pages_to_process = search_pages_to_process
    @dry_run = dry_run
    @messager = messager
  end

  def run
    check_messages
    cache_profiles
    send_some_messages
  #rescue StandardError => e
    #handle_error(e)
  end

private

  def cache_profiles
    webdriver.cache_profiles_from_search_page(num_pages: search_pages_to_process)
  end

  def send_some_messages
    messager.perform
  end

  def check_messages
    webdriver.check_messages
  end

  def handle_error(e)
    if Rails.env.production?
      AdminMailer.error(error: e).deliver_now!
    else
      raise e
    end
  end
end
