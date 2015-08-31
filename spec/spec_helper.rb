AUTOPOF_ENV='test'

require File.dirname(__FILE__) + "/../lib/autopof"
require 'database_cleaner'
DatabaseCleaner.strategy = :transaction

spec_dir = File.dirname(__FILE__)
require "#{spec_dir}/factories/profile_factory"
require "#{spec_dir}/factories/message_factory"

require "#{spec_dir}/helpers/topic_helpers"

def test_file_path(test_file)
  "#{root_dir}/spec/test_files/#{test_file}"
end

def root_dir
  @root_dir ||= File.dirname(__FILE__) + "/.."
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.include TopicHelpers

  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
