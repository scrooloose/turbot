#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/turbot"

search_pages_to_process = ENV['p'] && ENV['p'].to_i || 3
message_count = ENV['m'] && ENV['m'].to_i || 2
dry_run = ENV['dry_run'] && ENV['dry_run'].to_i == 1
user = User.find(ENV['u'].to_i)

Log.info "Starting PofSession with search_pages_to_process: #{search_pages_to_process}, message_count: #{message_count}, dry_run: #{dry_run}", stdout: true

sleep_strategy = SleepStrategy.new
wd = PofWebdriver::Base.new(sleep_strategy: sleep_strategy, user: user)
messager = Messager.new(dry_run: dry_run, webdriver: wd, sender: user, profile_repo: user.profile, message_count: message_count, sleep_strategy: sleep_strategy)

PofSession.new(
  search_pages_to_process: search_pages_to_process,
  dry_run: dry_run,
  webdriver: wd,
  messager: messager
).run
