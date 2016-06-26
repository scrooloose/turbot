require "rubygems"
require "bundler/setup"

require "nokogiri"
require "byebug"
require "open-uri"
require "pp"
require "active_record"
require "yaml"
require "mechanize"
require "nokogiri"
require "logger"
require "pony"
require "securerandom"
require "pry-byebug"
require "timecop"

ROOT_DIR = File.dirname(__FILE__) + '/..'

AUTOPOF_ENV ||= if ENV['AUTOPOF_ENV']
                  ENV['AUTOPOF_ENV'].to_sym
                else
                  :development
                end

ActiveRecord::Base.establish_connection(
  YAML.load_file("#{ROOT_DIR}/config/db.yml")[AUTOPOF_ENV.to_s]
)

lib_dir = File.dirname(__FILE__) + "/autopof"
require "#{lib_dir}/config"
require "#{lib_dir}/entities/message"
require "#{lib_dir}/entities/profile"
require "#{lib_dir}/profile_page_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"
require "#{lib_dir}/messager"
require "#{lib_dir}/received_message_processor"
require "#{lib_dir}/profile_cacher"
require "#{lib_dir}/pof_session"
require "#{lib_dir}/sleep_strategy"
require "#{lib_dir}/pof_webdriver/base.rb"
require "#{lib_dir}/my_logger.rb"

require "#{lib_dir}/topic"
require "#{lib_dir}/topic_registry"

Log = MyLogger.new("#{ROOT_DIR}/log/#{AUTOPOF_ENV}.log")
Log.level = Logger::INFO

TopicRegistryInstance = TopicRegistry.new
TopicRegistryInstance.add_from_file("#{ROOT_DIR}/config/config.yml") unless AUTOPOF_ENV == :test
