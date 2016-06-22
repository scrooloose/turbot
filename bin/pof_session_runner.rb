#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"

search_pages_to_process = ENV['pages'] && ENV['pages'].to_i || 3
message_count = ENV['message_limit'] && ENV['message_limit'].to_i || 2
dry_run = ENV['dry_run'] && ENV['dry_run'].to_i == 1

Log.info "Starting PofSession with search_pages_to_process: #{search_pages_to_process}, message_count: #{message_count}, dry_run: #{dry_run}"

sleep_strategy = SleepStrategy.new
wd = PofWebdriver::Base.new(sleep_strategy: sleep_strategy)
messager = Messager.new(dry_run: dry_run, webdriver: wd, profile_repo: Profile, message_count: message_count, sleep_strategy: sleep_strategy)

PofSession.new(
  search_pages_to_process: search_pages_to_process,
  dry_run: dry_run,
  webdriver: wd,
  messager: messager
).run
