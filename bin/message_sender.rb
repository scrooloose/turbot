#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../lib/autopof"
msg_limit = ENV['message_limit'] ? ENV['message_limit'].to_i : 2
dry_run = if ENV['dry_run']
            ENV['dry_run'].to_i == 1
          else
            true
          end

Messager.new(dry_run: dry_run, message_limit: msg_limit, webdriver: PofWebdriver::Base.new).go

