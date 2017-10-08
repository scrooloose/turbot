class PofSessionJob < ApplicationJob
  queue_as :default

  def perform(user_id:, messages: 2, sleep_strategy: SleepStrategy.new, search_pages: 2, dry_run: true)
    user = User.find(user_id)

    wd = PofWebdriver::Base.new(sleep_strategy: sleep_strategy, user: user)

    messager = Messager.new({
      dry_run: dry_run,
      webdriver: wd,
      sender: user,
      profile_repo: user.profile,
      message_count: messages,
      sleep_strategy: sleep_strategy
    })

    PofSession.new(
      search_pages_to_process: search_pages,
      dry_run: dry_run,
      webdriver: wd,
      messager: messager
    ).run
  end
end
