namespace :db do
  desc 'Migrate database. Required: ENV["AUTOPOF_ENV"]'
  task :migrate do
    env = ENV['AUTOPOF_ENV'] || raise("AUTOPOF_ENV must be set")
    system("sequel -m db/migrations -e #{env} ./config/db.yml")
  end

  desc 'Rollback to revision. Required: ENV["AUTOPOF_ENV"], ENV["rev"]'
  task :rollback do
    env = ENV['AUTOPOF_ENV'] || raise("AUTOPOF_ENV must be set")
    rev = ENV['REV'] || raise("ENV['REV'] must be set")
    system("sequel -m db/migrations -M #{rev} -e #{env} ./config/db.yml")
  end
end

desc 'Load Env'
task :environment do
  require File.dirname(__FILE__) + '/lib/autopof'
end

desc 'Output a bunch of stats'
task stats: :environment do
  puts "Total profiles cached: #{Profile.count}"
  puts "Total messages sent: #{Message.count}"
  puts "Total responses received: #{Message.with_response.count}"

  messagable_count = 0
  Profile.unmessaged.each_page(100) do |page|
    page.each do |profile|
      messagable_count += 1 if profile.matches_any_topic?
    end
  end
  puts "Messagable profiles remaining: #{messagable_count}"
end

namespace :bootstrap do
  desc 'Setup Profile. Required: ENV["AUTOPOF_ENV"], ENV["pof_profile_id"]'
  task setup_profile: :environment do
    pof_profile_id = ENV['pof_profile_id']

    require 'net/http'
    page = Net::HTTP.get('www.pof.com', "/viewprofile.aspx?profile_id=#{pof_profile_id}")
    profile = ProfileCacher.new(page).cache
    puts "Update config.yml now. Set 'user_profile_id' to #{profile.id}"
  end
end
