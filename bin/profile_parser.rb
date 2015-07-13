#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"
require 'pp'

profile_page = open(ARGV.first).read

profile = ProfileParser.new(page_content: profile_page).profile

pp "Name: #{profile.name}"
puts "\nInterests\n-------------"
pp profile.interests
puts "\nBio\n-------------"
pp profile.bio
