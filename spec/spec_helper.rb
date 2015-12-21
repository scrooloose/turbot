AUTOPOF_ENV='test'

require File.dirname(__FILE__) + "/../lib/autopof"
require 'database_cleaner'
DatabaseCleaner.strategy = :transaction

#A bunch of the specs just assume a biking topic exists - so just create it
#here. It seems a bit dodgy, but just do it until it becomes a problem.
TopicRegistryInstance.add(
  Topic.new(
    name: "biking",
    interest_matchers: ['(?<!motor |motor)bik(e|ing)|cycling', '(bike|cycle) ?touring'],
    message: "I see you're into biking. Have you been on any good rides lately? In the last couple of years I've been quite taken with the road riding in the UK."
  )
)

spec_dir = File.dirname(__FILE__)
require "#{spec_dir}/factories/profile_factory"
require "#{spec_dir}/factories/message_factory"
require "#{spec_dir}/factories/topic_factory"

def test_file_path(test_file)
  "#{root_dir}/spec/test_files/#{test_file}"
end

def root_dir
  @root_dir ||= File.dirname(__FILE__) + "/.."
end

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
