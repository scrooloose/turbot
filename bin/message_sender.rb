#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../lib/autopof"
msg_limit = ENV['message_limit'] ? ENV['message_limit'].to_i : 2
Messager.new(message_limit: msg_limit).go

