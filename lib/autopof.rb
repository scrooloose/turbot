require "rubygems"
require "bundler/setup"

require "nokogiri"
require "byebug"
require "open-uri"
require "pp"
require "sequel"
require "yaml"
require "mechanize"
require "nokogiri"
require "logger"
require "pony"
require "securerandom"

ROOT_DIR = File.dirname(__FILE__) + '/..'

AUTOPOF_ENV ||= if ENV['AUTOPOF_ENV']
                  ENV['AUTOPOF_ENV'].to_sym
                else
                  :development
                end

Sequel::Model.plugin :timestamps
DB = Sequel.connect(
  YAML.load_file("#{ROOT_DIR}/config/db.yml")[AUTOPOF_ENV.to_s]
)
DB.extension(:pagination)

Log = Logger.new("#{ROOT_DIR}/log/#{AUTOPOF_ENV}.log")
Log.level = Logger::INFO

lib_dir = File.dirname(__FILE__) + "/autopof"
require "#{lib_dir}/config"
require "#{lib_dir}/entities/message"
require "#{lib_dir}/entities/profile"
require "#{lib_dir}/profile_page_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"
require "#{lib_dir}/messager"
require "#{lib_dir}/profile_cacher"
require "#{lib_dir}/pof_webdriver/base.rb"

require "#{lib_dir}/topic"
require "#{lib_dir}/topic_registry"

TopicRegistryInstance = TopicRegistry.new
TopicRegistryInstance.add_from_file("#{ROOT_DIR}/config/config.yml") unless AUTOPOF_ENV == :test
