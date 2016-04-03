#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"

search_pages_to_process = ENV['pages'] && ENV['pages'].to_i || 3
messages_to_send = ENV['message_limit'] && ENV['message_limit'].to_i || 2
dry_run = ENV['dry_run'] && ENV['dry_run'].to_i == 1

Log.info "Starting PofSession with search_pages_to_process: #{search_pages_to_process}, messages_to_send: #{messages_to_send}, dry_run: #{dry_run}"

PofSession.new(
  search_pages_to_process: search_pages_to_process, messages_to_send: messages_to_send, dry_run: dry_run,
  webdriver: PofWebdriver::Base.new
).run
