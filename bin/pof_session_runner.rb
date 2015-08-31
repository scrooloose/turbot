#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"

class PofSession
  def initialize
    @wd = PofWebdriver::Base.new
  end

  def run
    check_for_responses_to_messages
    cache_profiles
    send_some_messages
  rescue Exception => e
    body = e.backtrace.join("\n")
    Pony.mail(to: Config['admin_email'], from: Config['admin_email'], subject: 'Pofbot Error', body: body)
  end

private

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

PofSession.new.run
