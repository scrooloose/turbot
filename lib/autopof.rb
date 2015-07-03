require "rubygems"
require "bundler/setup"

require "nokogiri"
require "pry"
require "open-uri"
require "pp"
require "sequel"
require "yaml"

AUTOPOF_ENV = if ENV['AUTOPOF_ENV']
                ENV['AUTOPOF_ENV'].to_sym
              else
                :development
              end

Sequel::Model.plugin :timestamps
DB = Sequel.connect(
  YAML.load_file(File.dirname(__FILE__) + "/../config/db.yml")[AUTOPOF_ENV.to_s]
)

lib_dir = File.dirname(__FILE__) + "/autopof"

require "#{lib_dir}/orm/profile_record"

require "#{lib_dir}/profile"
require "#{lib_dir}/profile_parser"
require "#{lib_dir}/bio_parser"
require "#{lib_dir}/message_builder"

require "#{lib_dir}/topics/base"
require "#{lib_dir}/topics/biking"
