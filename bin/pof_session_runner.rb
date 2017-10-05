#!/usr/bin/env ruby
require "pathname"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", Pathname.new(__FILE__).realpath)

require "rubygems"
require "bundler/setup"
require File.expand_path("../../config/environment", Pathname.new(__FILE__).realpath)

require 'slop'
require 'mechanize'

opts = Slop.parse do |o|
  o.banner = "Usage: TURBOT_ENV=[env-name] ./bin/pof_session_runner.rb [options]"
  o.separator ""
  o.separator "Required"
  o.integer "-u", "--user-id", "ID of user to act as"
  o.separator ""
  o.separator "Optional"
  o.integer "-p", "--search-pages", "Number of 'Search pages' to extract & cache profiles from (default: 3)", default: 3
  o.integer "-m", "--messages", "Number of messages to send (default: 2)", default: 2
  o.boolean "-d", "--dry-run", "Whether to do a dry run (no messages sent) (default: false)", default: false
  o.boolean "-h", "--help", "Display usage"
end

if opts.help?
  puts opts
  exit
end

unless opts[:user_id]
  puts opts
  exit
end

user = User.find(opts[:user_id])

Rails.logger.debug "Starting PofSession with search_pages_to_process: #{opts[:search_pages]}, message_count: #{opts[:messages]}, dry_run: #{opts.dry_run?}"

sleep_strategy = SleepStrategy.new
wd = PofWebdriver::Base.new(sleep_strategy: sleep_strategy, user: user)
messager = Messager.new(dry_run: opts.dry_run?, webdriver: wd, sender: user, profile_repo: user.profile, message_count: opts[:messages], sleep_strategy: sleep_strategy)

PofSession.new(
  search_pages_to_process: opts[:search_pages],
  dry_run: opts.dry_run?,
  webdriver: wd,
  messager: messager
).run
