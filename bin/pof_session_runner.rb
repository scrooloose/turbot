#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"

class PofSession
  def initialize
    @wd = PofWebdriver::Base.new
  end

  def cache_profiles
    pages = ENV['pages'] ? ENV['pages'].to_i : 3
    @wd.cache_profiles_from_search_page(num_pages: pages)
  end

  def send_some_messages
    msg_limit = ENV['message_limit'] ? ENV['message_limit'].to_i : 2
    dry_run = if ENV['dry_run']
                ENV['dry_run'].to_i == 1
              else
                true
              end
    Messager.new(dry_run: dry_run, message_limit: msg_limit).go
  end

  def check_for_responses_to_messages
    @wd.check_responses
  end
end

session = PofSession.new
session.check_for_responses_to_messages
session.cache_profiles
session.send_some_messages
