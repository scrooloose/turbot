#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../lib/autopof"
pages = ENV['pages'] ? ENV['pages'].to_i : 3
ProfileFetcher.new(num_pages: pages).run
