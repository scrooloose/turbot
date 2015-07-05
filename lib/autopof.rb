require "rubygems"
require "bundler/setup"

require "nokogiri"
require "pry"
require "open-uri"
require "pp"
require "sequel"
require "yaml"
require "mechanize"
require "logger"

AUTOPOF_ENV = if ENV['AUTOPOF_ENV']
                ENV['AUTOPOF_ENV'].to_sym
              else
                :development
              end

Sequel::Model.plugin :timestamps
DB = Sequel.connect(
  YAML.load_file(File.dirname(__FILE__) + "/../config/db.yml")[AUTOPOF_ENV.to_s]
)


Log = Logger.new("/tmp/autopof_log")


lib_dir = File.dirname(__FILE__) + "/autopof"
require "#{lib_dir}/orm/profile_record"
require "#{lib_dir}/orm/message_record"
require "#{lib_dir}/profile_fetcher"
require "#{lib_dir}/profile"
require "#{lib_dir}/profile_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"
require "#{lib_dir}/message_sender"
require "#{lib_dir}/topics/base"
require "#{lib_dir}/topics/biking"
require "#{lib_dir}/topics/reading"
require "#{lib_dir}/topics/running"
