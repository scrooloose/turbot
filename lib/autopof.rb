require "rubygems"
require "bundler/setup"

require "nokogiri"
require "pry"

lib_dir = File.dirname(__FILE__) + "/autopof"
require "#{lib_dir}/profile"
require "#{lib_dir}/profile_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"

require "#{lib_dir}/topics/base"
require "#{lib_dir}/topics/biking"
