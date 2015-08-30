require "rubygems"
require "bundler/setup"

require "nokogiri"
require "byebug"
require "open-uri"
require "pp"
require "sequel"
require "yaml"
require "mechanize"
require "logger"

ROOT_DIR = File.dirname(__FILE__) + '/..'

AUTOPOF_ENV = if ENV['AUTOPOF_ENV']
                ENV['AUTOPOF_ENV'].to_sym
              else
                :development
              end

Sequel::Model.plugin :timestamps
DB = Sequel.connect(
  YAML.load_file("#{ROOT_DIR}/config/db.yml")[AUTOPOF_ENV.to_s]
)

Log = Logger.new("/tmp/autopof_log")

Config = YAML.load_file("#{ROOT_DIR}/config/config.yml")

lib_dir = File.dirname(__FILE__) + "/autopof"
require "#{lib_dir}/profile_repository"
require "#{lib_dir}/message_repository"
require "#{lib_dir}/profile_fetcher"
require "#{lib_dir}/profile"
require "#{lib_dir}/profile_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"
require "#{lib_dir}/message_sender"
require "#{lib_dir}/messager"
require "#{lib_dir}/pof_webdriver_common"
require "#{lib_dir}/response_fetcher"
require "#{lib_dir}/topics/base"
require "#{lib_dir}/topics/biking"
require "#{lib_dir}/topics/reading"
require "#{lib_dir}/topics/running"
require "#{lib_dir}/topics/cooking"
require "#{lib_dir}/topics/tv_shows"
require "#{lib_dir}/topics/game_of_thrones"
