#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../lib/autopof"
require 'pp'

profile_page = ProfilePageParser.new(page_content: open(ARGV.first).read)

pp "Name: #{profile_page.name}"

puts "\nInterests\n-------------"
pp profile_page.interests

puts "\nInterests parsed from bio\n-------------"
pp BioParser.new(bio: profile_page.bio, topics: TopicRegistryInstance.topics).matching_topics.map(&:name)

puts "\nBio\n-------------"
pp profile_page.bio
